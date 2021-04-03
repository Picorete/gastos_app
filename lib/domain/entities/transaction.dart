class Transaction {
  Transaction({
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

  Transaction copyWith({
    int id,
    String description,
    double amount,
    String category,
    bool type,
    String date,
  }) =>
      new Transaction(
        id: id ?? this.id,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        type: type ?? this.type,
        date: date ?? this.date,
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
