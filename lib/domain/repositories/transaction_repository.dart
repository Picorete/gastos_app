import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/domain/entities/transaction.dart';
import 'package:dartz/dartz.dart';
import 'package:gastos_app/domain/entities/transactionsObject.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, TransactionsObject>> getTransactions(int month,
      {String category});
  Future<Either<Failure, bool>> addTransaction(Transaction transaction);
  Future<Either<Failure, List<String>>> getCategories(int month);
  Future<Either<Failure, String>> cachedCurrency({String currency});
  Future<Either<Failure, bool>> deleteTransaction(int id);
}
