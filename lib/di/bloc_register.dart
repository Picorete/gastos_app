import 'package:gastos_app/domain/usecases/add_transaction.dart';
import 'package:gastos_app/domain/usecases/delete_transaction.dart';
import 'package:gastos_app/domain/usecases/get_categories.dart';
import 'package:gastos_app/domain/usecases/get_currency.dart';
import 'package:gastos_app/domain/usecases/get_transactions.dart';
import 'package:gastos_app/presentation/bloc/add/add_bloc.dart';
import 'package:gastos_app/presentation/bloc/home/home_bloc.dart';
import 'package:injector/injector.dart';

class BlocRegister {
  final injector = Injector.appInstance;

  BlocRegister() {
    injector.registerSingleton<AddBloc>(() {
      return AddBloc(injector.get<AddTransactionUseCase>());
    });
    injector.registerSingleton<HomeBloc>(() {
      return HomeBloc(
        injector.get<GetTransactionsByMonthUseCase>(),
        injector.get<GetCategoriesOfMonthUseCase>(),
        injector.get<CachedCurrencyUseCase>(),
        injector.get<DeleteTransactionUseCase>(),
      );
    });
  }
}
