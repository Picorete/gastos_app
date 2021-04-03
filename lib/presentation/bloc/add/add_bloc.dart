import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/entities/transaction.dart';
import 'package:gastos_app/domain/usecases/add_transaction.dart';
import 'package:meta/meta.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final AddTransactionUseCase addTransaction;

  AddBloc(this.addTransaction) : super(AddState());

  @override
  Stream<AddState> mapEventToState(
    AddEvent event,
  ) async* {
    if (event is OnAddTransaction) {
      final resp = await addTransaction(state.transaction);

      yield* resp.fold((failure) async* {
        yield state.copyWith(error: Left(failure));
      }, (ok) async* {
        yield state.copyWith(error: Right(false), success: true);
      });
    } else if (event is OnChangeisOpenDatePicker) {
      yield state.copyWith(
          datePickerPanel:
              state.datePickerPanel.copyWith(isOpen: event.isOpen));
    } else if (event is OnChangeTransactionDate) {
      yield state.copyWith(
          datePickerPanel: state.datePickerPanel
              .copyWith(date: event.pickerDate, isOpen: false),
          transaction: state.transaction.copyWith(date: event.transactionDate));
    } else if (event is OnChangeTransactionType) {
      yield state.copyWith(
          transaction: state.transaction.copyWith(type: event.type));
    } else if (event is OnChangeTransactionCategory) {
      yield state.copyWith(
          transaction: state.transaction.copyWith(category: event.category));
    } else if (event is OnChangeTransactionAmount) {
      yield state.copyWith(
          transaction: state.transaction.copyWith(amount: event.amount));
    } else if (event is OnChangeTransactionDescription) {
      yield state.copyWith(
          transaction:
              state.transaction.copyWith(description: event.description));
    } else if (event is OnResetState) {
      yield state.copyWith(
          transaction:
              new Transaction(type: false, date: new DateTime.now().toString()),
          error: Right(false),
          success: false);
    }
  }
}
