class ExchangeRateModel {
  final String baseCode;
  final Map<String, double> rates;
  final String? timeLastUpdateUtc;

  ExchangeRateModel({
    required this.baseCode,
    required this.rates,
    this.timeLastUpdateUtc,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    final rawRates = json['conversion_rates'] ?? json['rates'] ?? <String, dynamic>{};
    final parsedRates = <String, double>{};

    rawRates.forEach((key, value) {
      if (value is num) {
        parsedRates[key.toString()] = value.toDouble();
      }
    });

    return ExchangeRateModel(
      baseCode: (json['base_code'] ?? json['base'] ?? 'USD').toString(),
      rates: parsedRates,
      timeLastUpdateUtc: json['time_last_update_utc']?.toString() ?? json['date']?.toString(),
    );
  }

  double getRate(String targetCurrency) {
    return rates[targetCurrency.toUpperCase()] ?? 1.0;
  }
}