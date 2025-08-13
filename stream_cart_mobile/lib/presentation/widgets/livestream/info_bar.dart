import 'package:flutter/material.dart';
import '../../blocs/livestream/livestream_state.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../domain/usecases/shop/get_shops_usecase.dart';

class InfoBar extends StatefulWidget {
  final LiveStreamLoaded state;
  const InfoBar({super.key, required this.state});

  @override
  State<InfoBar> createState() => _InfoBarState();
}

class _InfoBarState extends State<InfoBar> {
  String? _logoUrl;
  String? _lastShopId;

  @override
  void initState() {
    super.initState();
    _tryLoadLogo();
  }

  @override
  void didUpdateWidget(covariant InfoBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.liveStream.shopId != widget.state.liveStream.shopId) {
      _logoUrl = null;
      _tryLoadLogo();
    }
  }

  Future<void> _tryLoadLogo() async {
    final shopId = widget.state.liveStream.shopId;
    if (_lastShopId == shopId) return;
    _lastShopId = shopId;
    try {
      final usecase = getIt<GetShopByIdUseCase>();
      final res = await usecase(shopId);
      res.fold((_) {}, (shop) {
        if (!mounted) return;
        if (shop.logoURL.isNotEmpty) {
          setState(() => _logoUrl = shop.logoURL);
        }
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final ls = widget.state.liveStream;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF15181C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2E33), width: 1),
      ),
      child: Row(
        children: [
          _ShopAvatar(url: _logoUrl),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ls.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ls.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF202328),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A2E33), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.remove_red_eye, size: 16, color: Color(0xFFB0F847)),
                const SizedBox(width: 4),
                Text(
                  '${widget.state.viewerCount ?? widget.state.participants.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopAvatar extends StatelessWidget {
  final String? url;
  const _ShopAvatar({required this.url});

  @override
  Widget build(BuildContext context) {
    final has = (url != null && url!.isNotEmpty);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF202328),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: has
          ? Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.store, color: Colors.white),
            )
          : const Icon(Icons.store, color: Colors.white),
    );
  }
}
