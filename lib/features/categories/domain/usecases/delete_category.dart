import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/category_repository.dart';

class DeleteCategory implements UseCase<void, String> {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteCategory(id);
  }
}
