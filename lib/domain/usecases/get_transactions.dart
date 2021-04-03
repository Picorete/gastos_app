import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/entities/transactionsObject.dart';
import 'package:gastos_app/domain/repositories/transaction_repository.dart';

class GetTransactionsByMonthUseCase {
  final TransactionsRepository repository;

  GetTransactionsByMonthUseCase(this.repository);

  Future<Either<Failure, TransactionsObject>> call(int month,
      {String category}) async {
    return await repository.getTransactions(month, category: category);
  }
}
