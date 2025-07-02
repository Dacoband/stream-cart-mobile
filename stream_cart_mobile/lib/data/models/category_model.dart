import '../../domain/entities/category_entity.dart';

class CategoryResponseModel {
  final bool success;
  final String message;
  final List<CategoryModel> data;
  final List<String> errors;

  const CategoryResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => CategoryModel.fromJson(item))
              .toList()
          : [],
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : [],
    );
  }
}

class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String description;
  final String? iconURL;
  final String slug;
  final List<SubCategoryModel> subCategories;

  const CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    this.iconURL,
    required this.slug,
    required this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      iconURL: json['iconURL'],
      slug: json['slug'] ?? '',
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

class SubCategoryModel {
  final String categoryId;
  final String categoryName;
  final String description;
  final String? iconURL;
  final String slug;
  final List<SubCategoryModel> subCategories;

  const SubCategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    this.iconURL,
    required this.slug,
    required this.subCategories,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      iconURL: json['iconURL'],
      slug: json['slug'] ?? '',
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
      'subCategories': subCategories.map((item) => item.toJson()).toList(),
    };
  }

  SubCategoryEntity toEntity() {
    return SubCategoryEntity(
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      iconURL: iconURL,
      slug: slug,
      subCategories: subCategories.map((item) => item.toEntity()).toList(),
    );
  }
}
