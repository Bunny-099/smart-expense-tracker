import 'package:hive/hive.dart';
import '../../core/services/hive_service.dart';
import '../models/transaction_model.dart';

class TransactionLocalSource {
  Box<TransactionModel> get _box => HiveService.getBox<TransactionModel>(HiveService.transactionBox);

  Future<List<TransactionModel>> getAllTransactions() async {
    final transactions = _box.values.toList();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      return _box.values.firstWhere((transaction) => transaction.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAllTransactions() async {
    await _box.clear();
  }
}