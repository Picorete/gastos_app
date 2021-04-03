import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/repositories/transaction_repository.dart';

class GetCategoriesOfMonthUseCase {
  final TransactionsRepository repository;

  GetCategoriesOfMonthUseCase(this.repository);

  Future<Either<Failure, List<String>>> call(int month) async {
    return await repository.getCategories(month);
  }
}
