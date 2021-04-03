part of 'home_bloc.dart';

@immutable
class HomeState {
  final List<Transaction> transactions;
  final List<String> categories;
  final int activeMonth;
  final String activeCategory;
  final bool busy;
  final double totalAmount;
  final double totalInput;
  final double totalOutput;
  final String currency;

  HomeState(
      {this.activeMonth,
      this.categories,
      this.activeCategory = 'todos',
      this.totalAmount,
      this.totalInput,
      this.totalOutput,
      this.currency = '\$',
      this.busy = false,
      List<Transaction> transactions})
      : this.transactions = (transactions == null) ? [] : transactions;

  HomeState copyWith({
    List<Transaction> transactions,
    List<String> categories,
    String activeCategory,
    bool busy,
    int activeMonth,
    double totalAmount,
    double totalInput,
    double totalOutput,
    String currency,
  }) =>
      new HomeState(
          totalAmount: totalAmount ?? this.totalAmount,
          currency: currency ?? this.currency,
          totalInput: totalInput ?? this.totalInput,
          totalOutput: totalOutput ?? this.totalOutput,
          activeMonth: activeMonth ?? this.activeMonth,
          busy: busy ?? this.busy,
          transactions: transactions ?? this.transactions,
          categories: categories ?? this.categories,
          activeCategory: activeCategory ?? this.activeCategory);
}
