import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/livestream/livestream_bloc.dart';
import '../../blocs/livestream/livestream_state.dart';

class PinnedProductFloating extends StatefulWidget {
  final VoidCallback onOpenSheet;
  const PinnedProductFloating({super.key, required this.onOpenSheet});

  @override
  State<PinnedProductFloating> createState() => _PinnedProductFloatingState();
}

class _PinnedProductFloatingState extends State<PinnedProductFloating> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamBloc, LiveStreamState>(
      buildWhen: (p, c) => c is LiveStreamLoaded,
      builder: (context, state) {
        if (state is! LiveStreamLoaded) return const SizedBox.shrink();
        if (state.pinnedProducts.isEmpty) return const SizedBox.shrink();
        final p = state.pinnedProducts.first;
        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = (screenWidth * 0.6).clamp(180.0, 260.0);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
          child: _collapsed
              ? _CollapsedButton(onExpand: () => setState(() => _collapsed = false))
              : Row(
                  key: const ValueKey('expanded'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ExpandedCard(
                      width: cardWidth,
                      title: (p.variantName ?? '').trim().isNotEmpty ? p.variantName!.trim() : p.productName,
                      price: p.price,
                      imageUrl: p.productImageUrl,
                      onTap: widget.onOpenSheet,
                    ),
                    const SizedBox(width: 8),
                    _TogglePill(
                      icon: Icons.chevron_right,
                      tooltip: 'Thu gọn',
                      onTap: () => setState(() => _collapsed = true),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ExpandedCard extends StatelessWidget {
  final double width;
  final String title;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;

  const _ExpandedCard({
    required this.width,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF202328),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2E33)),
          ),
          width: width,
          constraints: const BoxConstraints(minHeight: 64),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, size: 24),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, size: 24),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.push_pin, size: 12, color: Color(0xFFB0F847)),
                        SizedBox(width: 4),
                        Flexible(child: Text('Đang ghim', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white70, fontSize: 10))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.formatVND(price),
                      style: const TextStyle(color: Color(0xFFB0F847), fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _TogglePill({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF202328),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2A2E33)),
          ),
          child: Icon(icon, size: 22, color: const Color(0xFFB0F847)),
        ),
      ),
    );
  }
}

class _CollapsedButton extends StatelessWidget {
  final VoidCallback onExpand;
  const _CollapsedButton({required this.onExpand});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Mở sản phẩm đang ghim',
      child: InkWell(
        onTap: onExpand,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          key: const ValueKey('collapsed'),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF202328),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF2A2E33)),
          ),
          child: const Icon(Icons.push_pin, color: Color(0xFFB0F847)),
        ),
      ),
    );
  }
}
