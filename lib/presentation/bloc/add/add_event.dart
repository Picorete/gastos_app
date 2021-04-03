part of 'add_bloc.dart';

@immutable
abstract class AddEvent {}

class OnAddTransaction extends AddEvent {}

class OnChangeisOpenDatePicker extends AddEvent {
  final bool isOpen;

  OnChangeisOpenDatePicker(this.isOpen);
}

class OnChangeTransactionDate extends AddEvent {
  final transactionDate;
  final pickerDate;

  OnChangeTransactionDate({this.transactionDate, this.pickerDate});
}

class OnChangeTransactionType extends AddEvent {
  final type;

  OnChangeTransactionType(this.type);
}

class OnChangeTransactionDescription extends AddEvent {
  final String description;

  OnChangeTransactionDescription(this.description);
}

class OnChangeTransactionAmount extends AddEvent {
  final double amount;

  OnChangeTransactionAmount(this.amount);
}

class OnChangeTransactionCategory extends AddEvent {
  final String category;

  OnChangeTransactionCategory(this.category);
}

class OnResetState extends AddEvent {}
