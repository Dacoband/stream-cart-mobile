import 'package:equatable/equatable.dart';

class UnreadCountEntity extends Equatable {
  final Map<String, int> unreadCounts;

  const UnreadCountEntity({
    required this.unreadCounts,
  });

  // Lấy số tin nhắn chưa đọc cho một chat room cụ thể
  int getUnreadCountForRoom(String roomId) {
    return unreadCounts[roomId] ?? 0;
  }

  // Tổng số tin nhắn chưa đọc từ tất cả chat rooms
  int get totalUnreadCount {
    return unreadCounts.values.fold(0, (sum, count) => sum + count);
  }

  // Kiểm tra có tin nhắn chưa đọc không
  bool get hasUnreadMessages => totalUnreadCount > 0;

  // Danh sách room IDs có tin nhắn chưa đọc
  List<String> get roomsWithUnreadMessages {
    return unreadCounts.entries
        .where((entry) => entry.value > 0)
        .map((entry) => entry.key)
        .toList();
  }

  UnreadCountEntity copyWith({
    Map<String, int>? unreadCounts,
  }) {
    return UnreadCountEntity(
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  // Cập nhật số tin nhắn chưa đọc cho một room
  UnreadCountEntity updateRoomCount(String roomId, int count) {
    final updatedCounts = Map<String, int>.from(unreadCounts);
    if (count > 0) {
      updatedCounts[roomId] = count;
    } else {
      updatedCounts.remove(roomId);
    }
    return copyWith(unreadCounts: updatedCounts);
  }

  // Reset số tin nhắn chưa đọc cho một room
  UnreadCountEntity markRoomAsRead(String roomId) {
    return updateRoomCount(roomId, 0);
  }

  @override
  List<Object?> get props => [unreadCounts];
}