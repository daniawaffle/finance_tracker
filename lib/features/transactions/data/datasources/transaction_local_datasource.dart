import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> getTransactionById(String id);
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId);
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box<TransactionModel> transactionBox;

  TransactionLocalDataSourceImpl({required this.transactionBox});

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final transactions = transactionBox.values.toList();
      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions;
    } catch (e) {
      throw DatabaseFailure('Failed to get transactions: ${e.toString()}');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final transaction = transactionBox.get(id);
      if (transaction == null) {
        throw DatabaseFailure('Transaction with id $id not found');
      }
      return transaction;
    } catch (e) {
      throw DatabaseFailure('Failed to get transaction: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId) async {
    try {
      final transactions = transactionBox.values
          .where((transaction) => transaction.categoryModel.id == categoryId)
          .toList();
      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions;
    } catch (e) {
      throw DatabaseFailure('Failed to get transactions by category: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    try {
      final transactions = transactionBox.values
          .where((transaction) => 
              transaction.date.isAfter(start.subtract(const Duration(days: 1))) &&
              transaction.date.isBefore(end.add(const Duration(days: 1))))
          .toList();
      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions;
    } catch (e) {
      throw DatabaseFailure('Failed to get transactions by date range: ${e.toString()}');
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await transactionBox.put(transaction.id, transaction);
    } catch (e) {
      throw DatabaseFailure('Failed to add transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await transactionBox.put(transaction.id, transaction);
    } catch (e) {
      throw DatabaseFailure('Failed to update transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await transactionBox.delete(id);
    } catch (e) {
      throw DatabaseFailure('Failed to delete transaction: ${e.toString()}');
    }
  }
}
