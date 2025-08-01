import '../../models/flash-sale/flash_sale_model.dart';
import '../../models/products/product_model.dart';

abstract class FlashSaleRemoteDataSource {
  Future<List<FlashSaleModel>> getFlashSales();
  Future<ProductModel> getFlashSaleProduct(String productId);
  Future<List<ProductModel>> getFlashSaleProducts(List<String> productIds);
}
