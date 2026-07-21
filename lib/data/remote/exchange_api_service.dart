import '../../core/network/api_client.dart';
import '../models/exchange_rate_model.dart';

class ExchangeApiService {
  final ApiClient _apiClient;
  static const String _baseUrl = 'https://open.er-api.com/v6/latest';

  ExchangeApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<ExchangeRateModel> getExchangeRates({String baseCurrency = 'INR'}) async {
    final response = await _apiClient.get('$_baseUrl/$baseCurrency');
    return ExchangeRateModel.fromJson(response as Map<String, dynamic>);
  }
}