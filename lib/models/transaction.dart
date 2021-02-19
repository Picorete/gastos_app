class TransactionModel {
  TransactionModel({
    this.id,
    this.description,
    this.amount,
    this.category,
    this.type,
    this.date,
  });

  int id;
  String description;
  double amount;
  String category;
  bool type;
  String date;

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
