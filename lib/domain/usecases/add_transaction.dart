import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/entities/transaction.dart';
import 'package:gastos_app/domain/repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionsRepository repository;

  AddTransactionUseCase(this.repository);

  Future<Either<Failure, bool>> call(Transaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
