import '../../../domain/entities/livestream/livestream_entity.dart';
import 'livestream_message_model.dart';
import 'livestream_product_model.dart';

class LiveStreamModel {
  final String id;
  final String title;
  final String description;
  final String sellerId;
  final String sellerName;
  final String shopId;
  final String shopName;
  final String? scheduledStartTime;
  final String? actualStartTime;
  final String? actualEndTime;
  final bool isLive;
  final String playbackUrl;
  final String? livekitRoomId;
  final String? joinToken;
  final String? thumbnailUrl;
  final int currentViewerCount;
  final int? maxViewer;
  final bool isPromoted;
  final String tags; // raw tags
  final List<LiveStreamProductModel> products;
  final String createdAt;
  final String? lastModifiedAt;
  final List<LiveStreamChatMessageModel> recentMessages;

  const LiveStreamModel({
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
    required this.tags,
    required this.products,
    required this.createdAt,
    this.lastModifiedAt,
    this.recentMessages = const [],
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    final bool isLive = json.containsKey('isLive')
        ? (json['isLive'] ?? false)
        : (json['status'] ?? false);
    return LiveStreamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      scheduledStartTime: json['scheduledStartTime'],
      actualStartTime: json['actualStartTime'],
      actualEndTime: json['actualEndTime'],
      isLive: isLive,
      playbackUrl: json['playbackUrl'] ?? '',
      livekitRoomId: json['livekitRoomId'],
      joinToken: json['joinToken'],
      thumbnailUrl: json['thumbnailUrl'],
      currentViewerCount: json['currentViewerCount'] ?? 0,
      maxViewer: json['maxViewer'],
      isPromoted: json['isPromoted'] ?? false,
      tags: json['tags'] ?? '',
      products: (json['products'] as List? ?? [])
          .map((e) => LiveStreamProductModel.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] ?? '',
      lastModifiedAt: json['lastModifiedAt'],
      recentMessages: (json['recentMessages'] as List? ?? [])
          .map((e) => LiveStreamChatMessageModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'sellerId': sellerId,
        'sellerName': sellerName,
        'shopId': shopId,
        'shopName': shopName,
        'scheduledStartTime': scheduledStartTime,
        'actualStartTime': actualStartTime,
        'actualEndTime': actualEndTime,
        'isLive': isLive,
        'playbackUrl': playbackUrl,
        'livekitRoomId': livekitRoomId,
        'joinToken': joinToken,
        'thumbnailUrl': thumbnailUrl,
        'currentViewerCount': currentViewerCount,
        'maxViewer': maxViewer,
        'isPromoted': isPromoted,
        'tags': tags,
        'products': products.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
        'lastModifiedAt': lastModifiedAt,
        'recentMessages': recentMessages.map((e) => e.toJson()).toList(),
      };

  LiveStreamEntity toEntity() => LiveStreamEntity(
        id: id,
        title: title,
        description: description,
        sellerId: sellerId,
        sellerName: sellerName,
        shopId: shopId,
        shopName: shopName,
        scheduledStartTime: scheduledStartTime != null ? DateTime.tryParse(scheduledStartTime!) : null,
        actualStartTime: actualStartTime != null ? DateTime.tryParse(actualStartTime!) : null,
        actualEndTime: actualEndTime != null ? DateTime.tryParse(actualEndTime!) : null,
        isLive: isLive,
        playbackUrl: playbackUrl,
        livekitRoomId: livekitRoomId,
        joinToken: joinToken,
        thumbnailUrl: thumbnailUrl,
        currentViewerCount: currentViewerCount,
        maxViewer: maxViewer,
        isPromoted: isPromoted,
        tagsRaw: tags,
        products: products.map((e) => e.toEntity()).toList(),
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        lastModifiedAt: lastModifiedAt != null ? DateTime.tryParse(lastModifiedAt!) : null,
        recentMessages: recentMessages.map((e) => e.toEntity()).toList(),
      );
}
