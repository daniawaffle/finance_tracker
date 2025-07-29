import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/dependency_injection.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/get_all_categories.dart';

final getAllCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final getAllCategories = sl<GetAllCategories>();
  final result = await getAllCategories(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure),
    (categories) => categories,
  );
});

final addCategoryProvider = Provider<AddCategory>((ref) => sl<AddCategory>());

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final GetAllCategories _getAllCategories;
  final AddCategory _addCategory;

  CategoryNotifier(this._getAllCategories, this._addCategory)
      : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    final result = await _getAllCategories(const NoParams());
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (categories) => AsyncValue.data(categories),
    );
  }

  Future<void> addCategory(Category category) async {
    final result = await _addCategory(category);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => loadCategories(),
    );
  }
}

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>((ref) {
  return CategoryNotifier(sl<GetAllCategories>(), sl<AddCategory>());
});
