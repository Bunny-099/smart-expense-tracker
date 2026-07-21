import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/transaction_model.dart';
import 'search_provider.dart';
import 'transaction_provider.dart';

enum SortOption {
  newestFirst,
  oldestFirst,
  highestAmount,
  lowestAmount,
}

class FilterState {
  final TransactionType? selectedType;
  final String? selectedCategoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final SortOption sortOption;

  const FilterState({
    this.selectedType,
    this.selectedCategoryId,
    this.startDate,
    this.endDate,
    this.sortOption = SortOption.newestFirst,
  });

  FilterState copyWith({
    TransactionType? selectedType,
    String? selectedCategoryId,
    DateTime? startDate,
    DateTime? endDate,
    SortOption? sortOption,
    bool clearType = false,
    bool clearCategory = false,
    bool clearDates = false,
  }) {
    return FilterState(
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      sortOption: sortOption ?? this.sortOption,
    );
  }

  bool get hasActiveFilters =>
      selectedType != null ||
          selectedCategoryId != null ||
          startDate != null ||
          endDate != null ||
          sortOption != SortOption.newestFirst;
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void setType(TransactionType? type) {
    state = state.copyWith(selectedType: type, clearType: type == null);
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId, clearCategory: categoryId == null);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) {
      state = state.copyWith(clearDates: true);
    } else {
      state = state.copyWith(startDate: start, endDate: end);
    }
  }

  void setSortOption(SortOption sortOption) {
    state = state.copyWith(sortOption: sortOption);
  }

  void resetFilters() {
    state = const FilterState();
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

final filteredTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionProvider).transactions;
  final filter = ref.watch(filterProvider);

  List<TransactionModel> filteredList = transactions.where((tx) {
    if (filter.selectedType != null && tx.transactionType != filter.selectedType) {
      return false;
    }
    if (filter.selectedCategoryId != null && tx.categoryId != filter.selectedCategoryId) {
      return false;
    }
    if (filter.startDate != null) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      final start = DateTime(filter.startDate!.year, filter.startDate!.month, filter.startDate!.day);
      if (txDate.isBefore(start)) return false;
    }
    if (filter.endDate != null) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      final end = DateTime(filter.endDate!.year, filter.endDate!.month, filter.endDate!.day);
      if (txDate.isAfter(end)) return false;
    }
    return true;
  }).toList();

  switch (filter.sortOption) {
    case SortOption.newestFirst:
      filteredList.sort((a, b) => b.date.compareTo(a.date));
      break;
    case SortOption.oldestFirst:
      filteredList.sort((a, b) => a.date.compareTo(b.date));
      break;
    case SortOption.highestAmount:
      filteredList.sort((a, b) => b.amount.compareTo(a.amount));
      break;
    case SortOption.lowestAmount:
      filteredList.sort((a, b) => a.amount.compareTo(b.amount));
      break;
  }

  return filteredList;
});