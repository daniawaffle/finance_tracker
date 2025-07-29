import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();
  Future<Either<Failure, Category>> getCategoryById(String id);
  Future<Either<Failure, void>> addCategory(Category category);
  Future<Either<Failure, void>> updateCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(String id);
}
