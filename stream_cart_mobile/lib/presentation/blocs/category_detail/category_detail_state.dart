import 'package:equatable/equatable.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';

abstract class CategoryDetailState extends Equatable {
  const CategoryDetailState();

  @override
  List<Object?> get props => [];
}

class CategoryDetailInitial extends CategoryDetailState {}

class CategoryDetailLoading extends CategoryDetailState {}

class CategoryDetailLoaded extends CategoryDetailState {
  final CategoryEntity category;
  final List<ProductEntity> products;
  final Map<String, String> productImages; 

  const CategoryDetailLoaded({
    required this.category,
    required this.products,
    this.productImages = const {},
  });

  @override
  List<Object?> get props => [category, products, productImages];
}

class CategoryDetailError extends CategoryDetailState {
  final String message;

  const CategoryDetailError(this.message);

  @override
  List<Object> get props => [message];
}
