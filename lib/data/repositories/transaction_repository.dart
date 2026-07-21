import '../local/transaction_local_source.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final TransactionLocalSource _localSource;

  TransactionRepository({TransactionLocalSource? localSource})
      : _localSource = localSource ?? TransactionLocalSource();

  Future<List<TransactionModel>> getTransactions() async {
    return await _localSource.getAllTransactions();
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    return await _localSource.getTransactionById(id);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _localSource.addTransaction(transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _localSource.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _localSource.deleteTransaction(id);
  }

  Future<void> clearAll() async {
    await _localSource.clearAllTransactions();
  }
}