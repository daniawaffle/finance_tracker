import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final transactionModels = await localDataSource.getAllTransactions();
      final transactions = transactionModels.map((model) => model.toEntity()).toList();
      return Right(transactions);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final transactionModel = await localDataSource.getTransactionById(id);
      return Right(transactionModel.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(String categoryId) async {
    try {
      final transactionModels = await localDataSource.getTransactionsByCategory(categoryId);
      final transactions = transactionModels.map((model) => model.toEntity()).toList();
      return Right(transactions);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    try {
      final transactionModels = await localDataSource.getTransactionsByDateRange(start, end);
      final transactions = transactionModels.map((model) => model.toEntity()).toList();
      return Right(transactions);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      await localDataSource.addTransaction(transactionModel);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      await localDataSource.updateTransaction(transactionModel);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GeneralFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }
}
