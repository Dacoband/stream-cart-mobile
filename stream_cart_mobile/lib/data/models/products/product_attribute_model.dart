import '../../../domain/entities/products/product_attribute_entity.dart';

class ProductAttributeModel extends ProductAttributeEntity {
  const ProductAttributeModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.createdBy,
    super.lastModifiedAt,
    super.lastModifiedBy,
  });

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parse attribute JSON: $json');
      
      return ProductAttributeModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
        createdBy: json['createdBy']?.toString() ?? '',
        lastModifiedAt: json['lastModifiedAt'] != null 
            ? DateTime.tryParse(json['lastModifiedAt'].toString())
            : null,
        lastModifiedBy: json['lastModifiedBy']?.toString(),
      );
    } catch (e, stackTrace) {
      print('❌ Lỗi parse ProductAttributeModel: $e');
      print('📍 StackTrace: $stackTrace');
      print('📄 Attribute JSON: $json');

      return ProductAttributeModel(
        id: '',
        name: '',
        createdAt: DateTime.now(),
        createdBy: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
    };
  }

  factory ProductAttributeModel.fromEntity(ProductAttributeEntity entity) {
    return ProductAttributeModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      lastModifiedAt: entity.lastModifiedAt,
      lastModifiedBy: entity.lastModifiedBy,
    );
  }
}