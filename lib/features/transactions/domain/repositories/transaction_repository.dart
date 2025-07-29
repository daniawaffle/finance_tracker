import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getAllTransactions();
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(String categoryId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<Either<Failure, void>> addTransaction(Transaction transaction);
  Future<Either<Failure, void>> updateTransaction(Transaction transaction);
  Future<Either<Failure, void>> deleteTransaction(String id);
}
