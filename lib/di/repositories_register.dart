import 'package:gastos_app/data/datasource/local_database.dart';
import 'package:gastos_app/data/datasource/local_storage.dart';
import 'package:gastos_app/data/repositories/transaction_repository_impl.dart';
import 'package:gastos_app/domain/repositories/transaction_repository.dart';
import 'package:gastos_app/domain/usecases/add_transaction.dart';
import 'package:gastos_app/domain/usecases/delete_transaction.dart';
import 'package:gastos_app/domain/usecases/get_categories.dart';
import 'package:gastos_app/domain/usecases/get_currency.dart';
import 'package:gastos_app/domain/usecases/get_transactions.dart';
import 'package:injector/injector.dart';

class RepositoriesRegister {
  final injector = Injector.appInstance;

  RepositoriesRegister() {
    // Repository
    injector.registerDependency<TransactionsRepository>(() {
      return TransactionRepositoryImpl(
          database: injector.get<DatabaseService>(),
          localStorageDataSource: injector.get<LocalStorageDataSource>());
    });

    // Data source
    injector.registerDependency<DatabaseService>(() {
      return DatabaseService();
    });
    injector.registerDependency<LocalStorageDataSource>(() {
      return LocalStorageDataSourceImpl();
    });

    // Use cases
    injector.registerDependency<AddTransactionUseCase>(() {
      return AddTransactionUseCase(injector.get<TransactionsRepository>());
    });
    injector.registerDependency<GetTransactionsByMonthUseCase>(() {
      return GetTransactionsByMonthUseCase(
          injector.get<TransactionsRepository>());
    });
    injector.registerDependency<GetCategoriesOfMonthUseCase>(() {
      return GetCategoriesOfMonthUseCase(
          injector.get<TransactionsRepository>());
    });
    injector.registerDependency<CachedCurrencyUseCase>(() {
      return CachedCurrencyUseCase(injector.get<TransactionsRepository>());
    });
    injector.registerDependency<DeleteTransactionUseCase>(() {
      return DeleteTransactionUseCase(injector.get<TransactionsRepository>());
    });
  }
}
