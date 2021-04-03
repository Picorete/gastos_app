import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/repositories/transaction_repository.dart';

class CachedCurrencyUseCase {
  final TransactionsRepository repository;

  CachedCurrencyUseCase(this.repository);

  Future<Either<Failure, String>> call({String currency}) async {
    return await repository.cachedCurrency(currency: currency);
  }
}
