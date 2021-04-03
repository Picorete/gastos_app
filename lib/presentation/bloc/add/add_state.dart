part of 'add_bloc.dart';

class DatePickerPanel {
  final bool isOpen;
  final DateTime date;

  DatePickerPanel({this.isOpen = false, date})
      : this.date = (date == null) ? new DateTime.now() : date;

  DatePickerPanel copyWith({bool isOpen, DateTime date}) => new DatePickerPanel(
      date: date ?? this.date, isOpen: isOpen ?? this.isOpen);
}

@immutable
class AddState {
  final DatePickerPanel datePickerPanel;
  final Transaction transaction;
  final Either<Failure, bool> error;
  final bool success;
  AddState(
      {this.error,
      this.success = false,
      DatePickerPanel datePickerPanel,
      Transaction transaction})
      : this.transaction = (transaction == null)
            ? new Transaction(type: false, date: new DateTime.now().toString())
            : transaction,
        this.datePickerPanel =
            (datePickerPanel == null) ? new DatePickerPanel() : datePickerPanel;

  AddState copyWith(
          {Transaction transaction,
          Either<Failure, bool> error,
          DatePickerPanel datePickerPanel,
          bool success}) =>
      new AddState(
          success: success ?? this.success,
          transaction: transaction ?? this.transaction,
          error: error ?? this.error,
          datePickerPanel: datePickerPanel ?? this.datePickerPanel);
}
