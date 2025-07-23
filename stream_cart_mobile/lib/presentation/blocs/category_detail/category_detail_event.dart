import 'package:equatable/equatable.dart';

abstract class CategoryDetailEvent extends Equatable {
  const CategoryDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoryDetailEvent extends CategoryDetailEvent {
  final String categoryId;

  const LoadCategoryDetailEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class LoadProductsByCategoryEvent extends CategoryDetailEvent {
  final String categoryId;

  const LoadProductsByCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
