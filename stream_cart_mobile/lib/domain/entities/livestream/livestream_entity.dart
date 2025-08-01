import 'package:equatable/equatable.dart';

class LiveStreamEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String streamUrl;
  final String hostId;
  final String hostName;
  final String? hostAvatarUrl;
  final bool isLive;
  final int viewerCount;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String> productIds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LiveStreamEntity({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.streamUrl,
    required this.hostId,
    required this.hostName,
    this.hostAvatarUrl,
    required this.isLive,
    required this.viewerCount,
    this.startTime,
    this.endTime,
    required this.productIds,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnailUrl,
        streamUrl,
        hostId,
        hostName,
        hostAvatarUrl,
        isLive,
        viewerCount,
        startTime,
        endTime,
        productIds,
        createdAt,
        updatedAt,
      ];
}
