import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransaction implements UseCase<void, Transaction> {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  @override
  Future<Either<Failure, void>> call(Transaction params) async {
    return await repository.updateTransaction(params);
  }
}
