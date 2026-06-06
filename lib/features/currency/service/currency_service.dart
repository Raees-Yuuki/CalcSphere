// lib/features/currency/currency_service.dart
//
// FastForex API integration.
// Replace YOUR_FASTFOREX_KEY with your actual API key.
// DO NOT commit your real key to GitHub or any public repo.

import 'package:calc_sphere/features/currency/service/currency_data.dart';
import 'package:calc_sphere/features/currency/service/currency_model.dart';
import 'package:dio/dio.dart';

class CurrencyService {
  static const String _apiKey = 'f6aad14d25-568f92fbe6-tfe1hn';
  static const String _base = 'https://api.fastforex.io';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Fetches all supported currency names from FastForex.
  /// Falls back to static CurrencyData names if API fails.
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final res = await _dio.get(
        '$_base/currencies',
        queryParameters: {'api_key': _apiKey},
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        res.data['currencies'] ?? {},
      );

      if (data.isEmpty) return _staticFallback();

      final List<CurrencyModel> list = data.entries.map((e) {
        return CurrencyModel(
          code: e.key,
          name: e.value.toString(),
          flag: CurrencyData.flagFor(e.key),
        );
      }).toList();

      // Remove duplicates and sort alphabetically by name
      final seen = <String>{};
      final unique = list.where((c) => seen.add(c.code)).toList();
      unique.sort((a, b) => a.name.compareTo(b.name));

      return unique;
    } catch (_) {
      // API failed — use static list so app never breaks
      return _staticFallback();
    }
  }

  /// Fetches ALL rates from [from] currency in a single API call.
  /// Returns a map of currency code -> rate.
  /// This is efficient — one call gives all rates at once.
  Future<Map<String, double>> getAllRates({required String from}) async {
    final res = await _dio.get(
      '$_base/fetch-all',
      queryParameters: {'from': from, 'api_key': _apiKey},
    );

    final Map<String, dynamic> results = Map<String, dynamic>.from(
      res.data['results'] ?? {},
    );

    return results.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
  }

  /// Fetches a single exchange rate from [from] to [to].
  /// Used when only one specific rate is needed quickly.
  Future<double> getRate({required String from, required String to}) async {
    try {
      final res = await _dio.get(
        '$_base/fetch-one',
        queryParameters: {'from': from, 'to': to, 'api_key': _apiKey},
      );

      final result = res.data['result'] as Map<String, dynamic>?;
      if (result == null) return 0;

      return (result[to] as num?)?.toDouble() ?? 0;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 ||
          e.response?.statusCode == 422 ||
          e.response?.statusCode == 400) {
        return 0;
      }
      rethrow;
    }
  }

  /// Attempts to detect user's local currency via IP.
  Future<String?> detectCurrency() async {
    try {
      final res = await _dio.get('https://ipapi.co/json');
      final code = res.data['currency'] as String?;
      if (code != null && CurrencyData.all.any((e) => e['code'] == code)) {
        return code;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Static fallback list — used when API is unreachable.
  List<CurrencyModel> _staticFallback() {
    return CurrencyData.all.map((e) => CurrencyModel.fromStaticData(e)).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}
