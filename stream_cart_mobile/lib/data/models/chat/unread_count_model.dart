import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/chat/unread_count_entity.dart';

part 'unread_count_model.g.dart';

@JsonSerializable()
class UnreadCountModel {
  final Map<String, int> unreadCounts;

  const UnreadCountModel({
    required this.unreadCounts,
  });

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) {
    // Handle dynamic properties like additionalProp1, additionalProp2, etc.
    final Map<String, int> counts = {};
    for (final entry in json.entries) {
      if (entry.value is int) {
        counts[entry.key] = entry.value as int;
      } else if (entry.value is String) {
        // Try to parse string to int if possible
        final intValue = int.tryParse(entry.value);
        if (intValue != null) {
          counts[entry.key] = intValue;
        }
      }
    }
    return UnreadCountModel(unreadCounts: counts);
  }

  Map<String, dynamic> toJson() => _$UnreadCountModelToJson(this);

  UnreadCountEntity toEntity() {
    return UnreadCountEntity(
      unreadCounts: Map<String, int>.from(unreadCounts),
    );
  }

  factory UnreadCountModel.fromEntity(UnreadCountEntity entity) {
    return UnreadCountModel(
      unreadCounts: Map<String, int>.from(entity.unreadCounts),
    );
  }

  // Helper methods
  int getUnreadCountForRoom(String roomId) {
    return unreadCounts[roomId] ?? 0;
  }

  int get totalUnreadCount {
    return unreadCounts.values.fold(0, (sum, count) => sum + count);
  }

  bool get hasUnreadMessages => totalUnreadCount > 0;

  List<String> get roomsWithUnreadMessages {
    return unreadCounts.entries
        .where((entry) => entry.value > 0)
        .map((entry) => entry.key)
        .toList();
  }

  UnreadCountModel updateRoomCount(String roomId, int count) {
    final updatedCounts = Map<String, int>.from(unreadCounts);
    if (count > 0) {
      updatedCounts[roomId] = count;
    } else {
      updatedCounts.remove(roomId);
    }
    return copyWith(unreadCounts: updatedCounts);
  }

  UnreadCountModel markRoomAsRead(String roomId) {
    return updateRoomCount(roomId, 0);
  }

  UnreadCountModel copyWith({
    Map<String, int>? unreadCounts,
  }) {
    return UnreadCountModel(
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UnreadCountModel &&
        _mapEquals(other.unreadCounts, unreadCounts);
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode => unreadCounts.hashCode;

  @override
  String toString() {
    return 'UnreadCountModel(unreadCounts: $unreadCounts)';
  }
}