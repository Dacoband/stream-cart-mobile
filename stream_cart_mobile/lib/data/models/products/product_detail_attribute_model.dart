import '../../../domain/entities/products/product_detail_attribute_entity.dart';

class ProductDetailAttributeModel extends ProductDetailAttributeEntity {
  const ProductDetailAttributeModel({
    required super.attributeName,
    required super.valueImagePairs,
  });

  factory ProductDetailAttributeModel.fromJson(Map<String, dynamic> json) {
    try {
      String attributeName = json['attributeName']?.toString() ?? '';

      List<ValueImagePair> valueImagePairs = [];
      final valueImageData = json['valueImagePairs'];
      if (valueImageData != null && valueImageData is List) {
        for (int i = 0; i < valueImageData.length; i++) {
          final pair = valueImageData[i];
          if (pair != null && pair is Map<String, dynamic>) {
            try {
              final value = pair['value']?.toString() ?? '';
              final imageUrl = pair['imageUrl']?.toString();
              
              valueImagePairs.add(ValueImagePair(
                value: value,
                imageUrl: imageUrl,
              ));
            } catch (e) {
              continue;
            }
          }
        }
      }

      return ProductDetailAttributeModel(
        attributeName: attributeName,
        valueImagePairs: valueImagePairs,
      );
    } catch (e, stackTrace) {
      return const ProductDetailAttributeModel(
        attributeName: '',
        valueImagePairs: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'attributeName': attributeName,
      'valueImagePairs': valueImagePairs.map((pair) => {
        'value': pair.value,
        'imageUrl': pair.imageUrl,
      }).toList(),
    };
  }

  factory ProductDetailAttributeModel.fromEntity(ProductDetailAttributeEntity entity) {
    return ProductDetailAttributeModel(
      attributeName: entity.attributeName,
      valueImagePairs: entity.valueImagePairs,
    );
  }
}