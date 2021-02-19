import 'dart:async';

import 'package:gastos_app/providers/db.dart';

class TransactionsBloc {
  static final TransactionsBloc _singleton = new TransactionsBloc._internal();

  factory TransactionsBloc() {
    return _singleton;
  }

  TransactionsBloc._internal() {
    // Get inital Transactions of DB
    getTransactions(DateTime.now().month);
    getEntradasByMonth(DateTime.now().month, 1);
    getEntradasByMonth(DateTime.now().month, 0);
    getTotalByMonth(DateTime.now().month);
    getCategories(DateTime.now().month);
  }

  final _transactionsController =
      StreamController<List<TransactionModel>>.broadcast();

  Stream<List<TransactionModel>> get transactionStream =>
      _transactionsController.stream;

  // Stream de Entradas
  final _entradasController = StreamController<double>.broadcast();
  Stream<double> get entradasStream => _entradasController.stream;
  // Stream de Salidas
  final _salidasController = StreamController<double>.broadcast();
  Stream<double> get salidasStream => _salidasController.stream;
  // Stream de Total
  final _totalController = StreamController<double>.broadcast();
  Stream<double> get totalStream => _totalController.stream;
  // Stram de Categorias
  final _categoriesController = StreamController<List>.broadcast();
  Stream<List> get categoriesStream => _categoriesController.stream;

  dispose() {
    _transactionsController?.close();
    _entradasController?.close();
    _salidasController?.close();
    _totalController?.close();
    _categoriesController?.close();
  }

  getTransactions(month) async {
    _transactionsController.sink
        .add(await DBProvider.db.getAllByMonth(month: month));
  }

  getEntradasByMonth(month, type) async {
    switch (type) {
      case 1:
        _entradasController.sink.add(
            await DBProvider.db.getEntradasByMonth(month: month, type: type));
        break;
      case 0:
        _salidasController.sink.add(
            await DBProvider.db.getEntradasByMonth(month: month, type: type));
        break;
    }
  }

  getTotalByMonth(month) async {
    _totalController.sink
        .add(await DBProvider.db.getTotalByMonth(month: month));
  }

  deleteTransactionByID(id) async {
    await DBProvider.db.deleteById(id);
  }

  getCategories(month) async {
    _categoriesController.sink.add(await DBProvider.db.getCategories(month));
  }

  getTransactionsByCategory(month, cat) async {
    _transactionsController.sink
        .add(await DBProvider.db.getAllByMonthAndCategory(month, cat));
  }
}
