import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class AddCategory implements UseCase<void, Category> {
  final CategoryRepository repository;

  AddCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(Category params) async {
    return await repository.addCategory(params);
  }
}
