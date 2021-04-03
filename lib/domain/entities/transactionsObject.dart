import 'package:gastos_app/domain/entities/transaction.dart';

class TransactionsObject {
  TransactionsObject({
    this.totalAmount,
    this.input,
    this.output,
    this.transactions,
  });

  double totalAmount;
  double input;
  double output;
  List<Transaction> transactions;
}
