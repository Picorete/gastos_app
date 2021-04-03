import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionsRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<Either<Failure, bool>> call(int id) async {
    return await repository.deleteTransaction(id);
  }
}
