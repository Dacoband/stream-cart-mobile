import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/app_router.dart';
import '../../../domain/entities/flash-sale/flash_sale_entity.dart';
import '../../../domain/entities/products/product_entity.dart';

class FlashSaleItemCard extends StatelessWidget {
  final FlashSaleEntity flashSale;
  final ProductEntity product;
  final String? imageUrl;

  const FlashSaleItemCard({
    super.key,
    required this.flashSale,
    required this.product,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final cardWidth = screenWidth * 0.42; 
        final minWidth = 140.0; 
        final maxWidth = 180.0;
        final finalWidth = cardWidth.clamp(minWidth, maxWidth);
        double cardHeight;
        if (screenHeight > 800) {
          cardHeight = 200.0;
        } else if (screenHeight > 700) {
          cardHeight = 180.0;
        } else if (screenHeight > 600) {
          cardHeight = 160.0;
        } else {
          cardHeight = 140.0;
        }
        
        return SizedBox(
          width: finalWidth,
          height: cardHeight,
          child: Card(
            elevation: 2.5,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(context, cardHeight),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4FAF2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductName(),
                        const SizedBox(height: 6),
                        _buildSoldBarCapsule(),
                        const Spacer(),
                        _buildPriceRow(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(BuildContext context, double cardHeight) {
    final imageHeight = (cardHeight * 0.50).clamp(80.0, 110.0);
    final heroTag = 'flash_sale_${product.id}';
    final displayImage = imageUrl?.isNotEmpty == true
        ? imageUrl!
        : (flashSale.productImageUrl ?? '');
    
    return GestureDetector(
      onTap: () {
        if (imageUrl != null && imageUrl!.isNotEmpty) {
          precacheImage(CachedNetworkImageProvider(imageUrl!), context);
        }
        Navigator.pushNamed(
          context,
          AppRouter.productDetails,
          arguments: {
            'productId': product.id,
            'heroTag': heroTag,
            'imageUrl': imageUrl,
            'name': product.productName,
            'price': flashSale.flashSalePrice,
          },
        );
      },
      child: SizedBox(
        height: imageHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child: displayImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: displayImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 24, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 24, color: Colors.grey),
                    ),
            ),
            // Top gradient overlay for readability
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),
            // Discount badge
            Positioned(
              top: 6,
              left: 6,
              child: _buildDiscountBadge(),
            ),
            // Countdown top-right
            Positioned(
              top: 6,
              right: 6,
              child: _buildMiniCountdown(),
            ),
            if (flashSale.slot > 0)
              Positioned(
                bottom: 6,
                left: 6,
                child: _buildSlotBadge(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductName() {
    final variant = (flashSale.variantName ?? '').trim();
    final name = variant.isNotEmpty
        ? variant
        : (flashSale.productName?.trim().isNotEmpty == true
            ? flashSale.productName!.trim()
            : product.productName);
    return Flexible(
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: Colors.black87,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriceRow() {
    final formatter = NumberFormat.decimalPattern('vi_VN');
    String f(num v) => formatter.format(v.round());
    final hasDiscount = product.basePrice > flashSale.flashSalePrice && product.basePrice > 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${f(flashSale.flashSalePrice)}đ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.red[600],
                  height: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (hasDiscount)
                Text(
                  '${f(product.basePrice)}đ',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoldBarCapsule() {
    final soldPct = flashSale.soldPercentage.clamp(0, 100);
    final remaining = flashSale.quantityAvailable;
    final total = flashSale.quantityAvailable + flashSale.quantitySold;
    return Container(
      height: 22,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (soldPct / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[400]!, Colors.red[500]!],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                soldPct > 0
                    ? 'Đã bán ${soldPct.toInt()}% · Còn $remaining'
                    : 'Còn $remaining / $total',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: soldPct > 0 ? Colors.white : Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSlotBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Slot ${flashSale.slot}',
        style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDiscountBadge() {
    double original = product.basePrice;
    if (product.finalPrice > original) original = product.finalPrice;
    final diff = original - flashSale.flashSalePrice;
    String label;
    if (original > 0 && diff > 0) {
      final pct = (diff / original * 100).clamp(0, 99.9);
      label = '-${pct.toInt()}%';
    } else {
      label = 'Flash';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6240), Color(0xFFFF3D3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMiniCountdown() {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remaining = flashSale.endTime.difference(now);
        if (remaining.isNegative) {
          return const Text(
            'Hết giờ',
            style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
          );
        }
        final h = remaining.inHours;
        final m = remaining.inMinutes % 60;
        final s = remaining.inSeconds % 60;
        final text = h > 0
            ? '${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}'
            : '${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}' ;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
