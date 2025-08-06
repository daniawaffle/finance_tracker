import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/database/database_helper.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  CategoryLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.categoriesTable,
        orderBy: '${AppConstants.categoryCreatedAtColumn} DESC',
      );

      return List.generate(maps.length, (i) {
        return CategoryModel.fromMap(maps[i]);
      });
    } catch (e) {
      throw DatabaseFailure('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.categoriesTable,
        where: '${AppConstants.categoryIdColumn} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        throw DatabaseFailure('Category with id $id not found');
      }

      return CategoryModel.fromMap(maps.first);
    } catch (e) {
      throw DatabaseFailure('Failed to get category: ${e.toString()}');
    }
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(
        AppConstants.categoriesTable,
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw DatabaseFailure('Failed to add category: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      final db = await databaseHelper.database;
      final count = await db.update(
        AppConstants.categoriesTable,
        category.toMap(),
        where: '${AppConstants.categoryIdColumn} = ?',
        whereArgs: [category.id],
      );

      if (count == 0) {
        throw DatabaseFailure('Category with id ${category.id} not found');
      }
    } catch (e) {
      throw DatabaseFailure('Failed to update category: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      final db = await databaseHelper.database;
      final count = await db.delete(
        AppConstants.categoriesTable,
        where: '${AppConstants.categoryIdColumn} = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw DatabaseFailure('Category with id $id not found');
      }
    } catch (e) {
      throw DatabaseFailure('Failed to delete category: ${e.toString()}');
    }
  }
}
