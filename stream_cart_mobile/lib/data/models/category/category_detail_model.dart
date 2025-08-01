import '../../../domain/entities/category/category_entity.dart';
import 'category_model.dart';

class CategoryDetailResponseModel {
  final bool success;
  final String message;
  final CategoryDetailModel data;
  final List<String> errors;

  const CategoryDetailResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory CategoryDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CategoryDetailModel.fromJson(json['data'] ?? {}),
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : [],
    );
  }
}

class CategoryDetailModel {
  final String categoryId;
  final String categoryName;
  final String description;
  final String? iconURL;
  final String slug;
  final List<SubCategoryModel> subCategories;
  final bool isDeleted;

  const CategoryDetailModel({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    this.iconURL,
    required this.slug,
    required this.subCategories,
    required this.isDeleted,
  });

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailModel(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      iconURL: json['iconURL'],
      slug: json['slug'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      subCategories: json['subCategories'] != null
          ? (json['subCategories'] as List)
              .map((item) => SubCategoryModel.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'iconURL': iconURL,
      'slug': slug,
      'isDeleted': isDeleted,
      'subCategories': subCategories.map((item) => item.toJson()).toList(),
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      iconURL: iconURL,
      slug: slug,
      subCategories: subCategories.map((item) => item.toEntity()).toList(),
    );
  }
}
