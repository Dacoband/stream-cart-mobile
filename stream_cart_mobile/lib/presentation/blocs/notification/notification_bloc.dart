import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import '../../../domain/usecases/get_notifications_usecase.dart';
import '../../../domain/usecases/mark_notification_as_read_usecase.dart';
import '../../../domain/usecases/get_unread_notification_count_usecase.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../data/models/notification_model.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final GetUnreadNotificationCountUseCase getUnreadNotificationCountUseCase;

  // Keep track of current data for pagination
  List<NotificationEntity> _currentNotifications = [];
  int _currentPage = 1;
  int _totalItem = 0;
  int _pageSize = 10;
  String? _currentType;
  bool? _currentIsRead;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.getUnreadNotificationCountUseCase,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<LoadMoreNotifications>(_onLoadMoreNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<LoadUnreadCount>(_onLoadUnreadCount);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<NewNotificationReceived>(_onNewNotificationReceived);
    on<NotificationUpdated>(_onNotificationUpdated);
  }

  @override
  Future<void> close() {
    // Cancel any ongoing operations if needed
    return super.close();
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (isClosed) return;
    
    if (event.isRefresh) {
      // Don't emit loading if it's a refresh
    } else {
      emit(NotificationLoading());
    }

    // Reset pagination for new query
    _currentPage = event.pageIndex ?? 1;
    _pageSize = event.pageSize ?? 10;
    _currentType = event.type;
    _currentIsRead = event.isRead;

    final params = GetNotificationsParams(
      type: event.type,
      isRead: event.isRead,
      pageIndex: _currentPage,
      pageSize: _pageSize,
    );

    final result = await getNotificationsUseCase(params);

    result.fold(
      (failure) {
        emit(NotificationError(failure.message));
      },
      (response) {
        if (response.data is NotificationListEntity) {
          final notificationData = response.data as NotificationListEntity;
          _currentNotifications = notificationData.notificationList;
          _totalItem = notificationData.totalItem;

          final hasMoreData = _currentNotifications.length < _totalItem;

          emit(NotificationLoaded(
            notifications: _currentNotifications,
            totalItem: _totalItem,
            currentPage: _currentPage,
            pageSize: _pageSize,
            hasMoreData: hasMoreData,
          ));
        } else {
          emit(NotificationError('Invalid response format'));
        }
      },
    );
  }

  Future<void> _onLoadMoreNotifications(
    LoadMoreNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (isClosed) return;
    
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      
      if (!currentState.hasMoreData) return;

      emit(NotificationLoadingMore(
        currentNotifications: currentState.notifications,
        unreadCount: currentState.unreadCount,
      ));

      final nextPage = event.pageIndex;

      final params = GetNotificationsParams(
        type: event.type,
        isRead: event.isRead,
        pageIndex: nextPage,
        pageSize: event.pageSize,
      );

      final result = await getNotificationsUseCase(params);

      result.fold(
        (failure) {
          emit(NotificationError(failure.message));
        },
        (response) {
          if (response.data is NotificationListEntity) {
            final notificationData = response.data as NotificationListEntity;
            final newNotifications = notificationData.notificationList;

            _currentNotifications.addAll(newNotifications);
            _currentPage = nextPage;

            final hasMoreData = _currentNotifications.length < notificationData.totalItem;

            emit(NotificationLoaded(
              notifications: List.from(_currentNotifications),
              totalItem: notificationData.totalItem,
              currentPage: _currentPage,
              pageSize: event.pageSize,
              hasMoreData: hasMoreData,
              unreadCount: currentState.unreadCount,
            ));
          } else {
            emit(NotificationError('Invalid response format'));
          }
        },
      );
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    if (isClosed) return;
    
    final result = await markNotificationAsReadUseCase(event.notificationId);

    result.fold(
      (failure) {
        emit(NotificationError(failure.message));
      },
      (response) {
        // Update the notification in current list
        final updatedNotifications = _currentNotifications.map((notification) {
          if (notification.notificationId == event.notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

        _currentNotifications = updatedNotifications;

        // Emit success message
        emit(NotificationMarkAsReadSuccess(
          response.message,
          event.notificationId,
        ));

        // Update unread count and reload current state
        if (!isClosed) {
          add(LoadUnreadCount());
        }

        // Return to loaded state with updated data
        if (state is NotificationLoaded && !isClosed) {
          final currentState = state as NotificationLoaded;
          emit(currentState.copyWith(
            notifications: updatedNotifications,
          ));
        }
      },
    );
  }

  Future<void> _onLoadUnreadCount(
    LoadUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    if (isClosed) return;
    
    final result = await getUnreadNotificationCountUseCase();

    result.fold(
      (failure) {
        // Don't emit error for unread count, just ignore
      },
      (count) {
        emit(UnreadCountLoaded(count));
      },
    );
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (isClosed) return;
    // Use current filters or new ones
    if (!isClosed) {
      add(LoadNotifications(
        type: event.type ?? _currentType,
        isRead: event.isRead ?? _currentIsRead,
        pageIndex: 1,
        pageSize: _pageSize,
        isRefresh: true,
      ));
    }
  }

  // Getter for unread count (for external access)
  int get unreadCount {
    if (state is NotificationLoaded) {
      return (state as NotificationLoaded).unreadCount;
    }
    return 0;
  }

  // Handle new notification received via SignalR
  Future<void> _onNewNotificationReceived(
    NewNotificationReceived event,
    Emitter<NotificationState> emit,
  ) async {
    if (isClosed) return;
    
    try {

      // Parse the notification JSON
      final notificationJson = jsonDecode(event.notificationJson);
      final newNotification = NotificationModel.fromJson(notificationJson).toEntity();

      // Add to current notifications list if we have loaded state
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = [newNotification, ...currentState.notifications];
        
        emit(currentState.copyWith(
          notifications: updatedNotifications,
          totalItem: currentState.totalItem + 1,
          unreadCount: currentState.unreadCount + (newNotification.isRead ? 0 : 1),
        ));
      }
    } catch (e) {
      print('Error handling new notification: $e');
    }
  }

  // Handle notification update via SignalR
  Future<void> _onNotificationUpdated(
    NotificationUpdated event,
    Emitter<NotificationState> emit,
  ) async {
    if (isClosed) return;
    
    try {
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        
        // Update the specific notification
        final updatedNotifications = currentState.notifications.map((notification) {
          if (notification.notificationId == event.notificationId) {
            return notification.copyWith(isRead: event.isRead);
          }
          return notification;
        }).toList();

        // Recalculate unread count
        final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ));
      }
    } catch (e) {
      print('Error handling notification update: $e');
    }
  }
}
