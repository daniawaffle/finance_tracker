import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';
import '../../features/categories/data/datasources/category_local_datasource.dart';
import '../../features/categories/data/models/category_model.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category.dart';
import '../../features/categories/domain/usecases/delete_category.dart';
import '../../features/categories/domain/usecases/get_all_categories.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/add_transaction.dart';
import '../../features/transactions/domain/usecases/get_all_transactions.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final categoryBox = await Hive.openBox<CategoryModel>(AppConstants.categoriesBox);
  final transactionBox = await Hive.openBox<TransactionModel>(AppConstants.transactionsBox);
  
  sl.registerLazySingleton(() => categoryBox);
  sl.registerLazySingleton(() => transactionBox);

  // Data sources
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(categoryBox: sl()),
  );
  
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(transactionBox: sl()),
  );

  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(localDataSource: sl()),
  );
  
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));
  sl.registerLazySingleton(() => GetAllTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
}
