import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/dependency_injection.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_all_transactions.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';

final getAllTransactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final getAllTransactions = sl<GetAllTransactions>();
  final result = await getAllTransactions(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure),
    (transactions) => transactions,
  );
});

final addTransactionProvider = Provider<AddTransaction>((ref) => sl<AddTransaction>());
final updateTransactionProvider = Provider<UpdateTransaction>((ref) => sl<UpdateTransaction>());
final deleteTransactionProvider = Provider<DeleteTransaction>((ref) => sl<DeleteTransaction>());

class TransactionNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final GetAllTransactions _getAllTransactions;
  final AddTransaction _addTransaction;
  final UpdateTransaction _updateTransaction;
  final DeleteTransaction _deleteTransaction;

  TransactionNotifier(
    this._getAllTransactions,
    this._addTransaction,
    this._updateTransaction,
    this._deleteTransaction,
  ) : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    state = const AsyncValue.loading();
    final result = await _getAllTransactions(const NoParams());
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (transactions) => AsyncValue.data(transactions),
    );
  }

  Future<void> addTransaction(Transaction transaction) async {
    final result = await _addTransaction(transaction);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => loadTransactions(),
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final result = await _updateTransaction(transaction);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => loadTransactions(),
    );
  }

  Future<void> deleteTransaction(String transactionId) async {
    final result = await _deleteTransaction(transactionId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => loadTransactions(),
    );
  }
}

final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, AsyncValue<List<Transaction>>>((ref) {
  return TransactionNotifier(
    sl<GetAllTransactions>(),
    sl<AddTransaction>(),
    sl<UpdateTransaction>(),
    sl<DeleteTransaction>(),
  );
});
