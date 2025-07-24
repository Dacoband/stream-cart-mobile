import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/flash_sale_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_state.dart';
import '../../blocs/home/home_event.dart';
import 'flash_sale_item_card.dart';

class FlashSaleSection extends StatelessWidget {
  const FlashSaleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          if (state.isLoadingFlashSales) {
            return _buildLoadingSection();
          }
          if (state.flashSales.isNotEmpty) {
            return _buildFlashSaleSection(context, state);
          }
          return _buildDebugSection(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Header skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Product cards skeleton
          LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = MediaQuery.of(context).size.height;
              final screenWidth = MediaQuery.of(context).size.width;
              
              // Dynamic height calculation matching the actual flash sale list
              double cardHeight;
              if (screenHeight > 800) {
                cardHeight = 220.0;
              } else if (screenHeight > 700) {
                cardHeight = 200.0;
              } else if (screenHeight > 600) {
                cardHeight = 180.0;
              } else {
                cardHeight = 160.0;
              }
              
              final cardWidth = screenWidth * 0.42;
              final finalWidth = cardWidth.clamp(140.0, 180.0);
              
              return SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: finalWidth,
                      margin: EdgeInsets.only(
                        right: index < 2 ? screenWidth * 0.03 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDebugSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                'Flash Sale Debug',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('No flash sales found. This might be because:'),
          const Text('• Flash Sale API returned empty data'),
          const Text('• API error occurred'),
          const Text('• No active flash sales at this time'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(const RefreshFlashSalesEvent());
            },
            child: const Text('Refresh Flash Sales'),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleSection(BuildContext context, HomeLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, state.flashSales),
          const SizedBox(height: 16),
          _buildFlashSaleList(context, state.flashSales, state.flashSaleProducts, state.productImages),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, List<FlashSaleEntity> flashSales) {
    final activeFlashSales = flashSales.where((fs) => fs.isCurrentlyActive).toList();
    final earliestEndTime = activeFlashSales.isNotEmpty
        ? activeFlashSales
            .map((fs) => fs.endTime)
            .reduce((a, b) => a.isBefore(b) ? a : b)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: Colors.red[600],
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  'Flash Sale',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(width: 8),
                if (earliestEndTime != null) 
                  Flexible(child: _buildCountdownTimer(earliestEndTime)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF202328),
              border: Border.all(
                color: const Color(0xFF202328),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextButton(
              onPressed: () {
                // TODO: Navigate to flash sale page
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
              ),
              child: const Text(
                'Xem thêm',
                style: TextStyle(
                  color: Color(0xFFB0F847),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(DateTime endTime) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remaining = endTime.difference(now);

        if (remaining.isNegative) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Đã kết thúc',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        }

        final hours = remaining.inHours;
        final minutes = remaining.inMinutes % 60;
        final seconds = remaining.inSeconds % 60;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFlashSaleList(
    BuildContext context,
    List<FlashSaleEntity> flashSales,
    List<ProductEntity> products,
    Map<String, String> productImages,
  ) {
    // Filter only active flash sales
    final activeFlashSales = flashSales.where((fs) => fs.isCurrentlyActive).toList();

    if (activeFlashSales.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive height based on screen size
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Dynamic height calculation for better responsive design
        double cardHeight;
        if (screenHeight > 800) {
          cardHeight = 220.0; // Large screens - increased for better content display
        } else if (screenHeight > 700) {
          cardHeight = 200.0; // Medium screens
        } else if (screenHeight > 600) {
          cardHeight = 180.0; // Smaller screens
        } else {
          cardHeight = 160.0; // Very small screens
        }
        
        return SizedBox(
          height: cardHeight,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            scrollDirection: Axis.horizontal,
            itemCount: activeFlashSales.length,
            itemBuilder: (context, index) {
              final flashSale = activeFlashSales[index];
              final product = products.firstWhere(
                (p) => p.id == flashSale.productId,
                orElse: () => ProductEntity(
                  id: flashSale.productId,
                  productName: 'Đang tải...',
                  description: '',
                  sku: 'loading',
                  categoryId: '',
                  basePrice: flashSale.flashSalePrice,
                  discountPrice: 0,
                  stockQuantity: 0,
                  isActive: true,
                  weight: 0,
                  dimensions: '',
                  hasVariant: false,
                  quantitySold: 0,
                  shopId: '',
                  createdAt: DateTime.now(),
                  createdBy: '',
                ),
              );

              return Container(
                margin: EdgeInsets.only(
                  right: index < activeFlashSales.length - 1 ? screenWidth * 0.03 : 0,
                ),
                child: FlashSaleItemCard(
                  flashSale: flashSale,
                  product: product,
                  imageUrl: productImages[product.id], // Pass image URL from productImages map
                ),
              );
            },
          ),
        );
      },
    );
  }
}
