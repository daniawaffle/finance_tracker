import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final categoryModels = await localDataSource.getAllCategories();
      final categories = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categories);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    try {
      final categoryModel = await localDataSource.getCategoryById(id);
      return Right(categoryModel.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(Category category) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);
      await localDataSource.addCategory(categoryModel);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(Category category) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);
      await localDataSource.updateCategory(categoryModel);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await localDataSource.deleteCategory(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }
}
