import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/data/datasource/local_database.dart';
import 'package:gastos_app/data/datasource/local_storage.dart';
import 'package:gastos_app/domain/entities/transaction.dart';
import 'package:gastos_app/domain/entities/transactionsObject.dart';
import 'package:gastos_app/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionsRepository {
  final DatabaseService database;
  final LocalStorageDataSource localStorageDataSource;

  TransactionRepositoryImpl({this.database, this.localStorageDataSource});

  @override
  Future<Either<Failure, bool>> addTransaction(Transaction transaction) async {
    return await database.insertTransaction(transaction);
  }

  @override
  Future<Either<Failure, TransactionsObject>> getTransactions(int month,
      {String category}) async {
    return await database.getAllByMonth(month, category: category);
  }

  @override
  Future<Either<Failure, List<String>>> getCategories(int month) async {
    return await database.getCategories(month);
  }

  @override
  Future<Either<Failure, String>> cachedCurrency({String currency}) async {
    return Right(
        await localStorageDataSource.cachedCurrency(currency: currency));
  }

  @override
  Future<Either<Failure, bool>> deleteTransaction(int id) async {
    return Right(await database.deleteById(id));
  }
}
