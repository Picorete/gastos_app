import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/usecases/delete_transaction.dart';
import 'package:gastos_app/domain/usecases/get_categories.dart';
import 'package:gastos_app/domain/usecases/get_currency.dart';
import 'package:gastos_app/domain/usecases/get_transactions.dart';
import 'package:meta/meta.dart';
import '../../../domain/entities/transaction.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTransactionsByMonthUseCase getTransactionsByMonth;
  final GetCategoriesOfMonthUseCase getCategoriesOfMonth;
  final CachedCurrencyUseCase cachedCurrency;
  final DeleteTransactionUseCase deleteTransaction;

  HomeBloc(this.getTransactionsByMonth, this.getCategoriesOfMonth,
      this.cachedCurrency, this.deleteTransaction)
      : super(HomeState());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is InitTransactions) {
      yield* this.getTransactions(DateTime.now().month);
      final currency = await this.cachedCurrency();
      yield* currency.fold((l) => null, (currency) async* {
        yield state.copyWith(currency: currency);
      });
    } else if (event is OnGetTransactions) {
      yield* this.getTransactions(event.month, category: event.category);
    } else if (event is OnSetCurrency) {
      await this.cachedCurrency(currency: event.currency);
      yield state.copyWith(currency: event.currency);
    } else if (event is OnDeleteTransaction) {
      var transactions = state.transactions;
      transactions.remove(event.transaction);
      yield state.copyWith(transactions: transactions);
      await this.deleteTransaction(event.transaction.id);
    }
  }

  Stream<HomeState> getTransactions(int month, {String category}) async* {
    var resp;
    if (category != null && category != 'todos') {
      yield state.copyWith(
          busy: true, activeMonth: month, activeCategory: category);
      resp = await getTransactionsByMonth(month, category: category);
    } else {
      yield state.copyWith(
          busy: true, activeMonth: month, activeCategory: 'todos');
      resp = await getTransactionsByMonth(month);
    }
    final categoriesResp = await this.getCategoriesOfMonth(month);

    yield* categoriesResp.fold((Failure l) => null,
        (List<String> categories) async* {
      yield state.copyWith(categories: categories);
    });

    yield* resp.fold((l) => null, (transactionsObject) async* {
      yield state.copyWith(
          transactions: transactionsObject.transactions,
          totalAmount: transactionsObject.totalAmount,
          totalInput: transactionsObject.input,
          totalOutput: transactionsObject.output,
          busy: false);
    });
  }
}
