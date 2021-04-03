import 'package:flutter/cupertino.dart';
import 'package:gastos_app/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    @required int id,
    @required String description,
    @required double amount,
    @required String category,
    @required bool type,
    @required String date,
  }) : super(
            id: id,
            description: description,
            amount: amount,
            category: category,
            type: type,
            date: date);

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        description: json["description"],
        amount: json["amount"].toDouble(),
        category: json["category"],
        type: json["type"] == 1 ? true : false,
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "amount": amount,
        "category": category,
        "type": type,
        "date": date,
      };
}
