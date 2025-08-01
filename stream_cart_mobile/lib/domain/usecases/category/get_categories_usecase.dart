import 'package:dartz/dartz.dart';
import '../../entities/category/category_entity.dart';
import '../../repositories/home_repository.dart';
import '../../../core/error/failures.dart';

class GetCategoriesUseCase {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await repository.getCategories();
  }
}
