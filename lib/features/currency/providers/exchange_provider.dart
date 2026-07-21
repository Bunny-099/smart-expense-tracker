import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../data/models/exchange_rate_model.dart';
import '../../../data/repositories/exchange_repository.dart';

final exchangeRepositoryProvider = Provider<ExchangeRepository>((ref) {
  return ExchangeRepository();
});

class ExchangeState {
  final ExchangeRateModel? exchangeRate;
  final bool isLoading;
  final String? error;
  final String baseCurrency;
  final String targetCurrency;
  final double inputAmount;
  final double convertedAmount;

  const ExchangeState({
    this.exchangeRate,
    this.isLoading = false,
    this.error,
    this.baseCurrency = 'INR',
    this.targetCurrency = 'USD',
    this.inputAmount = 1.0,
    this.convertedAmount = 0.0,
  });

  ExchangeState copyWith({
    ExchangeRateModel? exchangeRate,
    bool? isLoading,
    String? error,
    String? baseCurrency,
    String? targetCurrency,
    double? inputAmount,
    double? convertedAmount,
    bool clearError = false,
  }) {
    return ExchangeState(
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      inputAmount: inputAmount ?? this.inputAmount,
      convertedAmount: convertedAmount ?? this.convertedAmount,
    );
  }
}

class ExchangeNotifier extends StateNotifier<ExchangeState> {
  final ExchangeRepository _repository;

  ExchangeNotifier(this._repository) : super(const ExchangeState()) {
    fetchRates();
  }

  Future<void> fetchRates({String base = 'INR'}) async {
    state = state.copyWith(isLoading: true, baseCurrency: base, clearError: true);
    try {
      final rates = await _repository.getExchangeRates(baseCurrency: base);
      final rate = rates.getRate(state.targetCurrency);
      final converted = state.inputAmount * rate;
      state = state.copyWith(
        exchangeRate: rates,
        isLoading: false,
        convertedAmount: converted,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch exchange rates: ${e.toString()}',
      );
    }
  }

  void updateTargetCurrency(String target) {
    if (state.exchangeRate != null) {
      final rate = state.exchangeRate!.getRate(target);
      final converted = state.inputAmount * rate;
      state = state.copyWith(
        targetCurrency: target,
        convertedAmount: converted,
      );
    } else {
      state = state.copyWith(targetCurrency: target);
    }
  }

  void updateInputAmount(double amount) {
    if (state.exchangeRate != null) {
      final rate = state.exchangeRate!.getRate(state.targetCurrency);
      final converted = amount * rate;
      state = state.copyWith(
        inputAmount: amount,
        convertedAmount: converted,
      );
    } else {
      state = state.copyWith(inputAmount: amount);
    }
  }

  void swapCurrencies() {
    final oldBase = state.baseCurrency;
    final oldTarget = state.targetCurrency;
    state = state.copyWith(
      baseCurrency: oldTarget,
      targetCurrency: oldBase,
    );
    fetchRates(base: oldTarget);
  }
}

final exchangeProvider = StateNotifierProvider<ExchangeNotifier, ExchangeState>((ref) {
  final repository = ref.watch(exchangeRepositoryProvider);
  return ExchangeNotifier(repository);
});