import '../remote/exchange_api_service.dart';
import '../models/exchange_rate_model.dart';

class ExchangeRepository {
  final ExchangeApiService _apiService;

  ExchangeRepository({ExchangeApiService? apiService})
      : _apiService = apiService ?? ExchangeApiService();

  Future<ExchangeRateModel> getExchangeRates({String baseCurrency = 'INR'}) async {
    return await _apiService.getExchangeRates(baseCurrency: baseCurrency);
  }
}