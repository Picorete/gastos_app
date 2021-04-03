import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:gastos_app/core/errors/exceptions.dart';
import 'package:gastos_app/data/models/transaction_model.dart';
import 'package:gastos_app/domain/entities/transaction.dart';
import 'package:gastos_app/domain/entities/transactionsObject.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseService {
  static sql.Database _database;
  static final DatabaseService db = DatabaseService();
  final date = DateTime.now();

  DatabaseService();

  Future<sql.Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'MoneyMS.db');

    return await sql.openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (sql.Database db, int version) async {
      await db.execute('CREATE TABLE Transactions ('
          ' id INTEGER PRIMARY KEY,'
          ' description TEXT,'
          ' amount DOUBLE,'
          ' category TEXT,'
          ' type BOOLEAN,'
          ' date DATE'
          ')');
    });
  }

  // Insert
  Future<Either<Failure, bool>> insertTransaction(
      Transaction transaction) async {
    final db = await database;

    final res = await db.insert('Transactions', transaction.toJson());

    if (res is int) {
      return Right(true);
    } else {
      return Left(new ServerFail('No se a podido guardar la transaction'));
    }
  }

  // Get
  Future<TransactionModel> getTById(int id) async {
    final db = await database;

    final res =
        await db.query('Transactions', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? TransactionModel.fromJson(res.first) : null;
  }

  // Delete
  Future<bool> deleteById(int id) async {
    final db = await database;

    await db.delete('Transactions', where: 'id = ?', whereArgs: [id]);

    return true;
  }

  Future<List<TransactionModel>> getAllT() async {
    final db = await database;
    final res = await db.query('Transactions', orderBy: 'date DESC');

    List<TransactionModel> list = res.isNotEmpty
        ? res.map((t) => TransactionModel.fromJson(t)).toList()
        : [];

    return list;
  }

  // Get incomes by month
  Future<Either<Failure, TransactionsObject>> getAllByMonth(int month,
      {String category}) async {
    var monthString;
    (month < 10) ? monthString = "0$month" : monthString = month;

    final db = await database;
    List<TransactionModel> list;
    if (category != null) {
      list = await this.getAllByMonthAndCategory(month, category);
    } else {
      final res = await db.query('Transactions',
          where: "strftime('%m', date) = ?",
          whereArgs: ['$monthString'],
          orderBy: 'date DESC');
      list = res.isNotEmpty
          ? res.map((t) => TransactionModel.fromJson(t)).toList()
          : [];
    }

    double entradasDbl;
    double salidasDbl;

    final entradas = await db.rawQuery(
        "SELECT SUM(amount) FROM Transactions WHERE strftime('%m', date) = '$monthString' AND type = 1");
    final salidas = await db.rawQuery(
        "SELECT SUM(amount) FROM Transactions WHERE strftime('%m', date) = '$monthString' AND type = 0");

    if (entradas.first["SUM(amount)"] == null) {
      entradasDbl = 0.0;
    } else {
      entradasDbl = entradas.first["SUM(amount)"];
    }
    if (salidas.first["SUM(amount)"] == null) {
      salidasDbl = 0.0;
    } else {
      salidasDbl = salidas.first["SUM(amount)"];
    }

    double salidaTotal = entradasDbl - salidasDbl;

    return Right(new TransactionsObject(
        transactions: list,
        totalAmount: salidaTotal,
        input: entradasDbl,
        output: salidasDbl));
  }

  // Get incomes per type
  Future<double> getEntradasByMonth({month: int, type = 0}) async {
    (month < 10) ? month = "0$month" : month = month;

    final db = await database;
    final res = await db.rawQuery(
        "SELECT SUM(amount) FROM Transactions WHERE strftime('%m', date) = '$month' AND type = $type");

    return (res.first["SUM(amount)"] == null) ? 0.0 : res.first["SUM(amount)"];
  }

  // Get DISTINCT of categories
  Future<Either<Failure, List<String>>> getCategories(month) async {
    (month < 10) ? month = "0$month" : month = month;

    final db = await database;

    final res = await db.rawQuery(
        "SELECT DISTINCT(category) FROM Transactions WHERE strftime('%m', date) = '$month'");

    return Right(res.map((e) => e['category'] as String).toList());
  }

  // Get transactions by categorie
  Future<List<Transaction>> getAllByMonthAndCategory(month, cat) async {
    (month < 10) ? month = "0$month" : month = month;

    final db = await database;

    final res = await db.query('Transactions',
        where: "strftime('%m', date) = ? AND category = ?",
        whereArgs: ['$month', cat],
        orderBy: 'id DESC');

    List<TransactionModel> list = res.isNotEmpty
        ? res.map((t) => TransactionModel.fromJson(t)).toList()
        : [];

    return list;
  }
}
