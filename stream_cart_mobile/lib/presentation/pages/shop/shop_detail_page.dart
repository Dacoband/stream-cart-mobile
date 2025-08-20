import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart' as di;
import '../../blocs/shop/shop_bloc.dart';
import '../../blocs/shop/shop_event.dart';
import '../../blocs/shop/shop_state.dart';
import '../../../domain/entities/shop/shop.dart';
import '../../../core/routing/app_router.dart';

class ShopDetailPage extends StatefulWidget {
  final String shopId;

  const ShopDetailPage({
    super.key,
    required this.shopId,
  });

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  late final ShopBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = di.getIt<ShopBloc>();
    _bloc.add(LoadShopDetail(widget.shopId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocBuilder<ShopBloc, ShopState>(
          builder: (context, state) {

            if (state is ShopDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ShopError) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Chi tiết cửa hàng'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _bloc.add(LoadShopDetail(widget.shopId));
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ShopDetailLoaded) {
              return _buildShopDetail(context, state.shop, state.products, state.isLoadingProducts);
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Chi tiết cửa hàng'),
              ),
              body: const Center(
                child: Text('Đã có lỗi xảy ra'),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShopDetail(BuildContext context, Shop shop, List products, bool isLoadingProducts) {
    return RefreshIndicator(
      onRefresh: () async {
        final completer = Completer<void>();
        final bloc = context.read<ShopBloc>();
        late final StreamSubscription sub;
        sub = bloc.stream.listen((st) {
          if (st is ShopDetailLoaded && !st.isLoadingProducts) {
            sub.cancel();
            completer.complete();
          }
          if (st is ShopError) {
            sub.cancel();
            completer.complete();
          }
        });
        bloc.add(RefreshShopProducts(shop.id));
        return completer.future;
      },
      child: CustomScrollView(
      slivers: [
        // Shop Header
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Cover Image
                shop.coverImageURL.isNotEmpty
                    ? Image.network(
                        shop.coverImageURL,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.store,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                
                // Shop Info
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                      // Shop Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white, width: 1.6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: shop.logoURL.isNotEmpty
                              ? Image.network(
                                  shop.logoURL,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.store,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.white,
                                  child: const Icon(
                                    Icons.store,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Shop Name and Stats
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop.shopName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Quick Stats - chips
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star, color: Colors.orange, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        shop.ratingAverage.toStringAsFixed(1),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.inventory, color: Colors.lightBlueAccent, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        shop.totalProduct.toString(),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Shop Stats
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About Shop Section in green border
                if (shop.description.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0F847).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB0F847).withOpacity(0.45), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Về cửa hàng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202328),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          shop.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Shop Info
                const Text(
                  'Thông tin cửa hàng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRowWithIcon('Ngân hàng', '${shop.bankName} - ${shop.bankAccountNumber}', Icons.account_balance),
                _buildInfoRowWithIcon('Mã số thuế', shop.taxNumber, Icons.receipt_long),
                _buildInfoRowWithIcon('Trạng thái', shop.status ? 'Hoạt động' : 'Ngừng hoạt động', Icons.verified),
                _buildInfoRowWithIcon('Đánh giá', shop.totalReview.toString(), Icons.reviews),
                _buildInfoRowWithIcon('Ngày đăng ký', _formatDate(shop.registrationDate), Icons.calendar_today),
                if (shop.approvalDate != null)
                  _buildInfoRowWithIcon('Ngày phê duyệt', _formatDate(shop.approvalDate!), Icons.check_circle),
              ],
            ),
          ),
        ),

        // Products Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Sản phẩm của cửa hàng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF202328),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${products.length}',
                      style: const TextStyle(
                        color: Color(0xFFB0F847),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                if (isLoadingProducts)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),

        // Products Grid
        if (products.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.productDetails,
                          arguments: product.id,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: (product.primaryImageUrl != null &&
                                            product.primaryImageUrl.isNotEmpty &&
                                            product.primaryImageUrl.startsWith('http'))
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              product.primaryImageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Center(
                                                  child: Icon(Icons.shopping_bag, size: 40),
                                                );
                                              },
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(Icons.shopping_bag, size: 40),
                                          ),
                                  ),
                                  if (product.discountPrice > 0 && product.discountPrice < product.basePrice)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'SALE',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.productName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    _formatPrice(
                                      (product.discountPrice > 0 && product.discountPrice < product.basePrice)
                                          ? product.finalPrice
                                          : product.basePrice,
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (product.discountPrice > 0 && product.discountPrice < product.basePrice) ...[
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      _formatPrice(product.basePrice),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Còn lại: ${product.stockQuantity}',
                              style: TextStyle(
                                fontSize: 11,
                                color: product.stockQuantity > 10
                                    ? Colors.green
                                    : product.stockQuantity > 0
                                        ? Colors.orange
                                        : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          )
        else if (!isLoadingProducts)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No products available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
      ),
    );
  }

  Widget _buildInfoRowWithIcon(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFB0F847).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF202328)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatPrice(double price) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String priceStr = price.toInt().toString();
    priceStr = priceStr.replaceAllMapped(formatter, (Match m) => '${m[1]},');
    return '${priceStr}₫';
  }
}
