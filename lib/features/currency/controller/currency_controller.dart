// lib/features/currency/controller/currency_controller.dart
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';

import 'package:calc_sphere/features/currency/service/currency_data.dart';
import 'package:calc_sphere/features/currency/service/currency_model.dart';
import 'package:calc_sphere/features/currency/service/currency_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/number_formatter.dart';

class CurrencyController extends ChangeNotifier {
  final CurrencyService _service = CurrencyService();

  String from = 'USD';
  String to = 'INR';
  String amount = '';

  double rate = 0;
  bool loading = false;

  List<CurrencyModel> currencies = [];
  List<String> favorites = [];
  List<String> hiddenCurrencies = [];

  // Cached rates map: all rates from current [from] currency
  // e.g. { 'INR': 83.5, 'EUR': 0.92, ... }
  Map<String, double> _ratesCache = {};

  Timer? _timer;

  CurrencyController() {
    init();
  }

  static String flagFor(String code) => CurrencyData.flagFor(code);

  Future<void> init() async {
    // Step 1: Load static currencies INSTANTLY — user sees list immediately
    _loadStaticCurrencies();

    // Step 2: Load cached rate from disk — user sees last known rate immediately
    await _loadCachedRate();

    // Step 3: Load preferences in parallel
    await Future.wait([
      loadFavorites(),
      loadHiddenCurrencies(),
      autoDetectCurrency(),
    ]);

    // Step 4: Fetch fresh data from API in background
    _fetchCurrenciesFromApi();
    await fetchRate();

    // Step 5: Start live rate updates every 15 seconds
    startLiveRates();
  }

  /// Step 1: Show static list instantly — no network needed
  void _loadStaticCurrencies() {
    currencies =
        CurrencyData.all.map((e) => CurrencyModel.fromStaticData(e)).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  /// Step 4a: Silently fetch currency names from API in background
  /// and update list — user won't notice the switch
  Future<void> _fetchCurrenciesFromApi() async {
    try {
      final apiCurrencies = await _service.getCurrencies();
      if (apiCurrencies.isNotEmpty) {
        currencies = apiCurrencies;
        notifyListeners();
      }
    } catch (_) {
      // Silent fail — static list is already showing
    }
  }

  void startLiveRates() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => fetchRate());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> autoDetectCurrency() async {
    try {
      final code = await _service.detectCurrency();
      if (code != null) {
        to = code;
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Main rate fetch — uses fetch-all so we get all rates in one call.
  /// This means switching currency pairs is instant (no extra API call).
  Future<void> fetchRate() async {
    loading = true;
    notifyListeners();

    try {
      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity == ConnectivityResult.none) {
        await _loadCachedRate();
      } else {
        // fetch-all gives us every currency rate from [from] in one call
        _ratesCache = await _service.getAllRates(from: from);
        rate = _ratesCache[to] ?? 0;
        await _cacheRates();
      }
    } catch (_) {
      await _loadCachedRate();
    }

    loading = false;
    notifyListeners();
  }

  /// Cache entire rates map to disk for offline use
  Future<void> _cacheRates() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _ratesCache.map((k, v) => MapEntry(k, v.toString())),
    );
    await prefs.setString('rates_from_$from', encoded);
    // Also cache the specific pair for quick access
    await prefs.setDouble('rate_${from}_$to', rate);
  }

  /// Load cached rates from disk — shown instantly on app open
  Future<void> _loadCachedRate() async {
    final prefs = await SharedPreferences.getInstance();

    // Try to load full rates map first
    final encoded = prefs.getString('rates_from_$from');
    if (encoded != null) {
      try {
        final decoded = jsonDecode(encoded) as Map<String, dynamic>;
        _ratesCache = decoded.map((k, v) => MapEntry(k, double.parse(v)));
        rate = _ratesCache[to] ?? 0;
        return;
      } catch (_) {}
    }

    // Fallback: load single cached pair
    rate = prefs.getDouble('rate_${from}_$to') ?? 0;
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList('favorites') ?? [];
  }

  Future<void> loadHiddenCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    hiddenCurrencies = prefs.getStringList('hidden_currencies') ?? [];
  }

  Future<void> toggleFavorite(String code) async {
    final prefs = await SharedPreferences.getInstance();
    if (favorites.contains(code))
      favorites.remove(code);
    else
      favorites.add(code);
    await prefs.setStringList('favorites', favorites);
    notifyListeners();
  }

  Future<void> toggleHidden(String code) async {
    final prefs = await SharedPreferences.getInstance();
    if (hiddenCurrencies.contains(code))
      hiddenCurrencies.remove(code);
    else
      hiddenCurrencies.add(code);
    await prefs.setStringList('hidden_currencies', hiddenCurrencies);
    notifyListeners();
  }

  /// Returns visible, sorted currencies filtered by search query
  List<CurrencyModel> sortedCurrencies({String search = ''}) {
    List<CurrencyModel> list = currencies
        .where((c) => !hiddenCurrencies.contains(c.code))
        .toList();

    if (search.trim().isNotEmpty) {
      final q = search.toLowerCase();
      list = list.where((c) {
        return c.code.toLowerCase().contains(q) ||
            c.name.toLowerCase().contains(q);
      }).toList();
    }

    list.sort((a, b) {
      final af = favorites.contains(a.code);
      final bf = favorites.contains(b.code);
      if (af && !bf) return -1;
      if (!af && bf) return 1;
      return a.name.compareTo(b.name);
    });

    return list;
  }

  String get converted {
    if (amount.isEmpty || rate == 0) return '';
    final v = double.tryParse(amount) ?? 0;
    return NumberFormatter.formatFixed(v * rate, 2);
  }

  void onKey(String k) {
    if (k == '.' && amount.contains('.')) return;
    amount = (amount == '0' && k != '.') ? k : amount + k;
    notifyListeners();
  }

  void onBack() {
    if (amount.isNotEmpty) {
      amount = amount.substring(0, amount.length - 1);
    }
    notifyListeners();
  }

  void clear() {
    amount = '';
    notifyListeners();
  }

  Future<void> swap() async {
    final t = from;
    from = to;
    to = t;

    // Check if we already have cached rate for new pair — instant update
    if (_ratesCache.containsKey(to)) {
      rate = _ratesCache[to] ?? 0;
      notifyListeners();
    }

    // Then refresh with new base currency in background
    await fetchRate();
  }

  Future<void> setCurrency({
    required bool isFrom,
    required String value,
  }) async {
    if (isFrom) {
      from = value;
      // Invalidate rates cache since base changed
      _ratesCache = {};
    } else {
      to = value;
      // If we already have this rate cached, show instantly
      if (_ratesCache.containsKey(value)) {
        rate = _ratesCache[value] ?? 0;
        notifyListeners();
        return; // No need to fetch again
      }
    }
    await fetchRate();
  }
}
