import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String categoryId;
  final String categoryName;
  final String description;
  final String? iconURL;
  final String slug;
  final List<SubCategoryEntity> subCategories;

  const CategoryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    this.iconURL,
    required this.slug,
    required this.subCategories,
  });

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        description,
        iconURL,
        slug,
        subCategories,
      ];
}

class SubCategoryEntity extends Equatable {
  final String categoryId;
  final String categoryName;
  final String description;
  final String? iconURL;
  final String slug;
  final List<SubCategoryEntity> subCategories;

  const SubCategoryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    this.iconURL,
    required this.slug,
    required this.subCategories,
  });

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        description,
        iconURL,
        slug,
        subCategories,
      ];
}
