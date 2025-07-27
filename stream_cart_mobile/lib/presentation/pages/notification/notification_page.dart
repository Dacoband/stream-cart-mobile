import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../widgets/notification_item_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  bool _isDisposed = false;
  
  // Filter states
  String? _selectedType;
  bool? _selectedIsRead;
  
  // Tab indices
  static const int _allTabIndex = 0;
  static const int _unreadTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    
    // Check authentication before loading notifications
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      // Load initial notifications only if authenticated
      context.read<NotificationBloc>().add(LoadNotifications());
    }
    
    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isDisposed || !mounted) return;
    
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final bloc = context.read<NotificationBloc>();
      if (bloc.state is NotificationLoaded) {
        final state = bloc.state as NotificationLoaded;
        if (state.hasMoreData) {
          bloc.add(LoadMoreNotifications(
            type: _selectedType,
            isRead: _selectedIsRead,
            pageIndex: state.currentPage + 1,
            pageSize: state.pageSize,
          ));
        }
      }
    }
  }

  void _onTabChanged(int index) {
    if (_isDisposed || !mounted) return;
    
    // Check authentication before loading notifications
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthSuccess) return;
    
    switch (index) {
      case _allTabIndex:
        _selectedIsRead = null;
        break;
      case _unreadTabIndex:
        _selectedIsRead = false;
        break;
    }
    
    context.read<NotificationBloc>().add(LoadNotifications(
      type: _selectedType,
      isRead: _selectedIsRead,
      pageIndex: 1,
      pageSize: 10,
    ));
  }

  void _onRefresh() {
    if (_isDisposed || !mounted) return;
    
    // Check authentication before refreshing notifications
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthSuccess) return;
    
    context.read<NotificationBloc>().add(RefreshNotifications(
      type: _selectedType,
      isRead: _selectedIsRead,
    ));
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => _NotificationFilterDialog(
        selectedType: _selectedType,
        onTypeChanged: (type) {
          if (_isDisposed || !mounted) return;
          
          // Check authentication before filtering notifications
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthSuccess) return;
          
          setState(() {
            _selectedType = type;
          });
          context.read<NotificationBloc>().add(LoadNotifications(
            type: _selectedType,
            isRead: _selectedIsRead,
            pageIndex: 1,
            pageSize: 10,
          ));
        },
      ),
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.lock,
              color: Color(0xFFB0F847),
            ),
            const SizedBox(width: 8),
            const Text('Yêu cầu đăng nhập'),
          ],
        ),
        content: const Text('Bạn cần đăng nhập để xem thông báo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF202328),
              foregroundColor: Color(0xFFB0F847),
            ),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF202328),
        foregroundColor: Color(0xFFB0F847),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Color(0xFF202328),
                height: 48,
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[500],
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(child: Text('Tất cả')),
                  Tab(child: Text('Chưa đọc')),
                ],
              ),
              // Vertical divider
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 0.75,
                top: 12,
                bottom: 12,
                child: Container(
                  width: 1.5,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is NotificationMarkAsReadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Color(0xFFB0F847),
              ),
            );
          }
        },
        builder: (context, state) {
          // Check authentication state first
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthSuccess) {
            return _buildLoginRequiredState();
          }
          
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded || state is NotificationLoadingMore) {
            List<NotificationEntity> notifications = [];
            bool isLoadingMore = false;

            if (state is NotificationLoaded) {
              notifications = state.notifications;
            } else if (state is NotificationLoadingMore) {
              notifications = state.currentNotifications;
              isLoadingMore = true;
            }

            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => _onRefresh(),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < notifications.length) {
                    final notification = notifications[index];
                    return NotificationItemWidget(
                      notification: notification,
                      onTap: () => _onNotificationTap(notification),
                      onMarkAsRead: () => _onMarkAsRead(notification.notificationId),
                    );
                  } else {
                    // Loading more indicator
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          } else if (state is NotificationError) {
            return _buildErrorState(state.message);
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFFB0F847),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.notifications_none,
                size: 64,
                color: Color(0xFFB0F847),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Không có thông báo nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Các thông báo mới sẽ xuất hiện ở đây',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRequiredState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFFB0F847),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.lock,
                size: 50,
                color: Color(0xFFB0F847),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Yêu cầu đăng nhập',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn cần đăng nhập để xem thông báo',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF202328),
              foregroundColor: Color(0xFFB0F847),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Có lỗi xảy ra',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onRefresh,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  void _onNotificationTap(NotificationEntity notification) {
    // Check authentication state first
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! AuthSuccess) {
      // Show login required dialog
      _showLoginRequiredDialog();
      return;
    }

    // Mark as read if not already read
    if (!notification.isRead) {
      _onMarkAsRead(notification.notificationId);
    }

    // Handle navigation based on notification type
    _handleNotificationNavigation(notification);
  }

  void _onMarkAsRead(String notificationId) {
    if (_isDisposed || !mounted) return;
    
    context.read<NotificationBloc>().add(MarkNotificationAsRead(notificationId));
  }

  void _handleNotificationNavigation(NotificationEntity notification) {
    // TODO: Implement navigation based on notification type
    switch (notification.type) {
      case 'FlashSale':
        // Navigate to flash sale page
        break;
      case 'Order':
        // Navigate to order details
        break;
      case 'Product':
        // Navigate to product details
        break;
      default:
        // Default behavior
        break;
    }
  }
}

class _NotificationFilterDialog extends StatefulWidget {
  final String? selectedType;
  final Function(String?) onTypeChanged;

  const _NotificationFilterDialog({
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  State<_NotificationFilterDialog> createState() => _NotificationFilterDialogState();
}

class _NotificationFilterDialogState extends State<_NotificationFilterDialog> {
  String? _tempSelectedType;

  @override
  void initState() {
    super.initState();
    _tempSelectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Lọc thông báo',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFB0F847)),
        ),
      backgroundColor: const Color(0xFF202328),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Loại thông báo:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFB0F847)),
            ),
            const SizedBox(height: 16),
            _buildTypeRadio('Tất cả', null),
            _buildTypeRadio('Flash Sale', 'FlashSale'),
            _buildTypeRadio('Đơn hàng', 'Order'),
            _buildTypeRadio('Sản phẩm', 'Product'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFFB0F847),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onTypeChanged(_tempSelectedType);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB0F847),
            foregroundColor: Color(0xFF202328),
          ),
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }

  Widget _buildTypeRadio(String title, String? value) {
    return RadioListTile<String?>(
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFFB0F847)),
      ),
      value: value,
      groupValue: _tempSelectedType,
      activeColor: const Color(0xFFB0F847),
      onChanged: (newValue) {
        setState(() {
          _tempSelectedType = newValue;
        });
      },
    );
  }
}
