import 'package:gastos_app/models/transaction.dart';
import 'package:observable_ish/value/value.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseService {
  static Database _database;
  static final DatabaseService db = DatabaseService();
  final date = DateTime.now();

  DatabaseService();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  RxValue<List<TransactionModel>> _transacciones =
      RxValue<List<TransactionModel>>(initial: []);
  List<TransactionModel> get transacciones => _transacciones.value;

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'MoneyMS.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
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
  insertTransaction(TransactionModel transaction) async {
    final db = await database;

    final res = await db.insert('Transactions', transaction.toJson());

    _transacciones.value.insert(0, transaction);
    return res;
  }

  // Get
  Future<TransactionModel> getTById(int id) async {
    final db = await database;

    final res =
        await db.query('Transactions', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? TransactionModel.fromJson(res.first) : null;
  }

  // Delete
  Future<int> deleteById(int id) async {
    final db = await database;

    final res =
        await db.delete('Transactions', where: 'id = ?', whereArgs: [id]);

    return res;
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
  Future<List<TransactionModel>> getAllByMonth({month: int}) async {
    (month < 10) ? month = "0$month" : month = month;

    final db = await database;
    final res = await db.query('Transactions',
        where: "strftime('%m', date) = ?",
        whereArgs: ['$month'],
        orderBy: 'date DESC');

    List<TransactionModel> list = res.isNotEmpty
        ? res.map((t) => TransactionModel.fromJson(t)).toList()
        : [];

    _transacciones.value = list;
    return list;
  }

  // Get incomes per type
  Future<double> getEntradasByMonth({month: int, type = 0}) async {
    (month < 10) ? month = "0$month" : month = month;

    final db = await database;
    final res = await db.rawQuery(
        "SELECT SUM(amount) FROM Transactions WHERE strftime('%m', date) = '$month' AND type = $type");

    return (res.first["SUM(amount)"] == null) ? 0.0 : res.first["SUM(amount)"];
  }

  // Get total amount of incomes
  Future<double> getTotalByMonth({month}) async {
    (month < 10) ? month = "0$month" : month = month;
    double entradasDbl;
    double salidasDbl;

    final db = await database;
    final entradas = await db.rawQuery(
        "SELECT SUM(amount) FROM Transactions WHERE strftime('%m', date) = '$month' AND type = 1");
    final salidas = await db.rawQuery(
        "SELECT SUM(amount) FROM Transactions WHERE strftime('%m', date) = '$month' AND type = 0");

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

    return salidaTotal;
  }

  // Get DISTINCT of categories
  Future<List> getCategories(month) async {
    (month < 10) ? month = "0$month" : month = month;

    final db = await database;

    final res = await db.rawQuery(
        "SELECT DISTINCT(category) FROM Transactions WHERE strftime('%m', date) = '$month'");

    return res;
  }

  // Get transactions by categorie
  Future<List<TransactionModel>> getAllByMonthAndCategory(month, cat) async {
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
