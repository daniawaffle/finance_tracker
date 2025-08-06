import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/database/database_helper.dart';
import '../models/transaction_model.dart';
import '../../../categories/data/models/category_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> getTransactionById(String id);
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId);
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseHelper databaseHelper;

  TransactionLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT 
          t.${AppConstants.transactionIdColumn},
          t.${AppConstants.transactionTitleColumn},
          t.${AppConstants.transactionAmountColumn},
          t.${AppConstants.transactionTypeColumn},
          t.${AppConstants.transactionDescriptionColumn},
          t.${AppConstants.transactionDateColumn},
          t.${AppConstants.transactionCreatedAtColumn},
          c.${AppConstants.categoryIdColumn} as category_id,
          c.${AppConstants.categoryNameColumn} as category_name,
          c.${AppConstants.categoryColorColumn} as category_color,
          c.${AppConstants.categoryDescriptionColumn} as category_description,
          c.${AppConstants.categoryCreatedAtColumn} as category_created_at
        FROM ${AppConstants.transactionsTable} t
        INNER JOIN ${AppConstants.categoriesTable} c 
          ON t.${AppConstants.transactionCategoryIdColumn} = c.${AppConstants.categoryIdColumn}
        ORDER BY t.${AppConstants.transactionDateColumn} DESC
      ''');

      return _mapToTransactionModels(maps);
    } catch (e) {
      throw DatabaseFailure('Failed to get transactions: ${e.toString()}');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT 
          t.${AppConstants.transactionIdColumn},
          t.${AppConstants.transactionTitleColumn},
          t.${AppConstants.transactionAmountColumn},
          t.${AppConstants.transactionTypeColumn},
          t.${AppConstants.transactionDescriptionColumn},
          t.${AppConstants.transactionDateColumn},
          t.${AppConstants.transactionCreatedAtColumn},
          c.${AppConstants.categoryIdColumn} as category_id,
          c.${AppConstants.categoryNameColumn} as category_name,
          c.${AppConstants.categoryColorColumn} as category_color,
          c.${AppConstants.categoryDescriptionColumn} as category_description,
          c.${AppConstants.categoryCreatedAtColumn} as category_created_at
        FROM ${AppConstants.transactionsTable} t
        INNER JOIN ${AppConstants.categoriesTable} c 
          ON t.${AppConstants.transactionCategoryIdColumn} = c.${AppConstants.categoryIdColumn}
        WHERE t.${AppConstants.transactionIdColumn} = ?
      ''',
        [id],
      );

      if (maps.isEmpty) {
        throw DatabaseFailure('Transaction with id $id not found');
      }

      return _mapToTransactionModels(maps).first;
    } catch (e) {
      throw DatabaseFailure('Failed to get transaction: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(
    String categoryId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT 
          t.${AppConstants.transactionIdColumn},
          t.${AppConstants.transactionTitleColumn},
          t.${AppConstants.transactionAmountColumn},
          t.${AppConstants.transactionTypeColumn},
          t.${AppConstants.transactionDescriptionColumn},
          t.${AppConstants.transactionDateColumn},
          t.${AppConstants.transactionCreatedAtColumn},
          c.${AppConstants.categoryIdColumn} as category_id,
          c.${AppConstants.categoryNameColumn} as category_name,
          c.${AppConstants.categoryColorColumn} as category_color,
          c.${AppConstants.categoryDescriptionColumn} as category_description,
          c.${AppConstants.categoryCreatedAtColumn} as category_created_at
        FROM ${AppConstants.transactionsTable} t
        INNER JOIN ${AppConstants.categoriesTable} c 
          ON t.${AppConstants.transactionCategoryIdColumn} = c.${AppConstants.categoryIdColumn}
        WHERE t.${AppConstants.transactionCategoryIdColumn} = ?
        ORDER BY t.${AppConstants.transactionDateColumn} DESC
      ''',
        [categoryId],
      );

      return _mapToTransactionModels(maps);
    } catch (e) {
      throw DatabaseFailure(
        'Failed to get transactions by category: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final db = await databaseHelper.database;
      final startMillis = start.millisecondsSinceEpoch;
      final endMillis = end.millisecondsSinceEpoch;

      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT 
          t.${AppConstants.transactionIdColumn},
          t.${AppConstants.transactionTitleColumn},
          t.${AppConstants.transactionAmountColumn},
          t.${AppConstants.transactionTypeColumn},
          t.${AppConstants.transactionDescriptionColumn},
          t.${AppConstants.transactionDateColumn},
          t.${AppConstants.transactionCreatedAtColumn},
          c.${AppConstants.categoryIdColumn} as category_id,
          c.${AppConstants.categoryNameColumn} as category_name,
          c.${AppConstants.categoryColorColumn} as category_color,
          c.${AppConstants.categoryDescriptionColumn} as category_description,
          c.${AppConstants.categoryCreatedAtColumn} as category_created_at
        FROM ${AppConstants.transactionsTable} t
        INNER JOIN ${AppConstants.categoriesTable} c 
          ON t.${AppConstants.transactionCategoryIdColumn} = c.${AppConstants.categoryIdColumn}
        WHERE t.${AppConstants.transactionDateColumn} >= ? AND t.${AppConstants.transactionDateColumn} <= ?
        ORDER BY t.${AppConstants.transactionDateColumn} DESC
      ''',
        [startMillis, endMillis],
      );

      return _mapToTransactionModels(maps);
    } catch (e) {
      throw DatabaseFailure(
        'Failed to get transactions by date range: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(
        AppConstants.transactionsTable,
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw DatabaseFailure('Failed to add transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final db = await databaseHelper.database;
      final count = await db.update(
        AppConstants.transactionsTable,
        transaction.toMap(),
        where: '${AppConstants.transactionIdColumn} = ?',
        whereArgs: [transaction.id],
      );

      if (count == 0) {
        throw DatabaseFailure(
          'Transaction with id ${transaction.id} not found',
        );
      }
    } catch (e) {
      throw DatabaseFailure('Failed to update transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final db = await databaseHelper.database;
      final count = await db.delete(
        AppConstants.transactionsTable,
        where: '${AppConstants.transactionIdColumn} = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw DatabaseFailure('Transaction with id $id not found');
      }
    } catch (e) {
      throw DatabaseFailure('Failed to delete transaction: ${e.toString()}');
    }
  }

  List<TransactionModel> _mapToTransactionModels(
    List<Map<String, dynamic>> maps,
  ) {
    return List.generate(maps.length, (i) {
      final map = maps[i];
      final categoryMap = {
        AppConstants.categoryIdColumn: map['category_id'],
        AppConstants.categoryNameColumn: map['category_name'],
        AppConstants.categoryColorColumn: map['category_color'],
        AppConstants.categoryDescriptionColumn: map['category_description'],
        AppConstants.categoryCreatedAtColumn: map['category_created_at'],
      };

      final category = CategoryModel.fromMap(categoryMap);
      return TransactionModel.fromMap(map, category);
    });
  }
}
