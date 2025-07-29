import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Box<CategoryModel> categoryBox;

  CategoryLocalDataSourceImpl({required this.categoryBox});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      return categoryBox.values.toList();
    } catch (e) {
      throw DatabaseFailure('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final category = categoryBox.get(id);
      if (category == null) {
        throw DatabaseFailure('Category with id $id not found');
      }
      return category;
    } catch (e) {
      throw DatabaseFailure('Failed to get category: ${e.toString()}');
    }
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    try {
      await categoryBox.put(category.id, category);
    } catch (e) {
      throw DatabaseFailure('Failed to add category: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await categoryBox.put(category.id, category);
    } catch (e) {
      throw DatabaseFailure('Failed to update category: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await categoryBox.delete(id);
    } catch (e) {
      throw DatabaseFailure('Failed to delete category: ${e.toString()}');
    }
  }
}
