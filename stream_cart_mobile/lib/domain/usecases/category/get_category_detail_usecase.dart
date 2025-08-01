import 'package:dartz/dartz.dart';
import '../entities/category_entity.dart';
import '../repositories/home_repository.dart';
import '../../core/error/failures.dart';

class GetCategoryDetailUseCase {
  final HomeRepository repository;

  GetCategoryDetailUseCase(this.repository);

  Future<Either<Failure, CategoryEntity>> call(String categoryId) async {
    return await repository.getCategoryDetail(categoryId);
  }
}
