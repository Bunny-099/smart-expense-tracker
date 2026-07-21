import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../transaction/providers/transaction_provider.dart';

class DashboardSummary {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<TransactionModel> recentTransactions;
  final Map<CategoryModel, double> expenseByCategory;

  const DashboardSummary({
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.recentTransactions = const [],
    this.expenseByCategory = const {},
  });
}

final dashboardProvider = Provider<DashboardSummary>((ref) {
  final transactionState = ref.watch(transactionProvider);
  final transactions = transactionState.transactions;

  double income = 0.0;
  double expense = 0.0;
  final Map<CategoryModel, double> categoryMap = {};

  for (final tx in transactions) {
    if (tx.transactionType == TransactionType.income) {
      income += tx.amount;
    } else {
      expense += tx.amount;
      final category = tx.category;
      categoryMap[category] = (categoryMap[category] ?? 0.0) + tx.amount;
    }
  }

  final balance = income - expense;

  final sortedRecent = List<TransactionModel>.from(transactions)
    ..sort((a, b) => b.date.compareTo(a.date));

  final recent = sortedRecent.take(5).toList();

  return DashboardSummary(
    totalBalance: balance,
    totalIncome: income,
    totalExpense: expense,
    recentTransactions: recent,
    expenseByCategory: categoryMap,
  );
});