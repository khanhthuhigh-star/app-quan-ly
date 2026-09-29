class Summary {
  const Summary(this.income, this.expense);

  final int income;
  final int expense;
  int get balance => income - expense;
}
