import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

class TransactionState {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final bool isOperationInProgress;
  final String? error;
  final String? successMessage;

  const TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.isOperationInProgress = false,
    this.error,
    this.successMessage,
  });

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    bool? isLoading,
    bool? isOperationInProgress,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      isOperationInProgress: isOperationInProgress ?? this.isOperationInProgress,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository _repository;

  TransactionNotifier(this._repository) : super(const TransactionState()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final transactions = await _repository.getTransactions();
      state = state.copyWith(
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load transactions: ${e.toString()}',
      );
    }
  }

  Future<bool> addTransaction(TransactionModel transaction) async {
    state = state.copyWith(isOperationInProgress: true, clearError: true, clearSuccess: true);
    try {
      await _repository.addTransaction(transaction);
      final updatedList = await _repository.getTransactions();
      state = state.copyWith(
        transactions: updatedList,
        isOperationInProgress: false,
        successMessage: 'Transaction added successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isOperationInProgress: false,
        error: 'Failed to add transaction: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> updateTransaction(TransactionModel transaction) async {
    state = state.copyWith(isOperationInProgress: true, clearError: true, clearSuccess: true);
    try {
      await _repository.updateTransaction(transaction);
      final updatedList = await _repository.getTransactions();
      state = state.copyWith(
        transactions: updatedList,
        isOperationInProgress: false,
        successMessage: 'Transaction updated successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isOperationInProgress: false,
        error: 'Failed to update transaction: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    state = state.copyWith(isOperationInProgress: true, clearError: true, clearSuccess: true);
    try {
      await _repository.deleteTransaction(id);
      final updatedList = await _repository.getTransactions();
      state = state.copyWith(
        transactions: updatedList,
        isOperationInProgress: false,
        successMessage: 'Transaction deleted successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isOperationInProgress: false,
        error: 'Failed to delete transaction: ${e.toString()}',
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final transactionProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});