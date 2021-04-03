part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class InitTransactions extends HomeEvent {}

class OnGetTransactions extends HomeEvent {
  final month;
  final category;

  OnGetTransactions(this.month, {this.category});
}

class OnChangeActiveMonth extends HomeEvent {
  final month;

  OnChangeActiveMonth(this.month);
}

class OnSetCurrency extends HomeEvent {
  final currency;

  OnSetCurrency(this.currency);
}

class OnDeleteTransaction extends HomeEvent {
  final Transaction transaction;

  OnDeleteTransaction(this.transaction);
}
