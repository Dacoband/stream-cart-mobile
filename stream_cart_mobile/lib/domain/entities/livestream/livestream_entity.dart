import 'package:equatable/equatable.dart';

import 'livestream_product_entity.dart';
import 'livestream_message_entity.dart';

/// Viewer-focused livestream entity (customer side).
/// Contains only data needed to watch, view products, and interact via chat.
class LiveStreamEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String sellerId;
  final String sellerName;
  final String shopId;
  final String shopName;
  final DateTime? scheduledStartTime;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final bool isLive;
  final String playbackUrl;
  final String? livekitRoomId;
  final String? joinToken;
  final String? thumbnailUrl;
  final int currentViewerCount;
  final int? maxViewer;
  final bool isPromoted;
  final String tagsRaw;
  final List<LiveStreamProductEntity> products;
  final DateTime createdAt;
  final DateTime? lastModifiedAt;
  final List<LiveStreamChatMessageEntity> recentMessages;

  const LiveStreamEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.sellerId,
    required this.sellerName,
    required this.shopId,
    required this.shopName,
    this.scheduledStartTime,
    this.actualStartTime,
    this.actualEndTime,
    required this.isLive,
    required this.playbackUrl,
    this.livekitRoomId,
    this.joinToken,
    this.thumbnailUrl,
    required this.currentViewerCount,
    this.maxViewer,
    required this.isPromoted,
    required this.tagsRaw,
    required this.products,
    required this.createdAt,
    this.lastModifiedAt,
    this.recentMessages = const [],
  });

  bool get isUpcoming => !isLive && actualStartTime == null;
  bool get isLiveNow => isLive && actualStartTime != null && actualEndTime == null;
  bool get isEnded => actualEndTime != null;
  Duration? get elapsed => actualStartTime == null
      ? null
      : (actualEndTime ?? DateTime.now()).difference(actualStartTime!);
  Duration? get timeUntilStart => (scheduledStartTime != null && DateTime.now().isBefore(scheduledStartTime!))
      ? scheduledStartTime!.difference(DateTime.now())
      : null;
  List<String> get tags => tagsRaw.isEmpty
      ? const []
      : tagsRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  LiveStreamEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? sellerId,
    String? sellerName,
    String? shopId,
    String? shopName,
    DateTime? scheduledStartTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    bool? isLive,
    String? playbackUrl,
    String? livekitRoomId,
    String? joinToken,
    String? thumbnailUrl,
    int? currentViewerCount,
    int? maxViewer,
    bool? isPromoted,
    String? tagsRaw,
    List<LiveStreamProductEntity>? products,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
    List<LiveStreamChatMessageEntity>? recentMessages,
  }) {
    return LiveStreamEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      isLive: isLive ?? this.isLive,
      playbackUrl: playbackUrl ?? this.playbackUrl,
      livekitRoomId: livekitRoomId ?? this.livekitRoomId,
      joinToken: joinToken ?? this.joinToken,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      currentViewerCount: currentViewerCount ?? this.currentViewerCount,
      maxViewer: maxViewer ?? this.maxViewer,
      isPromoted: isPromoted ?? this.isPromoted,
      tagsRaw: tagsRaw ?? this.tagsRaw,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      recentMessages: recentMessages ?? this.recentMessages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        sellerId,
        sellerName,
        shopId,
        shopName,
        scheduledStartTime,
        actualStartTime,
        actualEndTime,
        isLive,
        playbackUrl,
        livekitRoomId,
        joinToken,
        thumbnailUrl,
        currentViewerCount,
        maxViewer,
        isPromoted,
        tagsRaw,
        products,
        createdAt,
        lastModifiedAt,
        recentMessages,
      ];
}
