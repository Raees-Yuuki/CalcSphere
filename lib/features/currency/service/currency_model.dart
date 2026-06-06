// currency_model.dart

class CurrencyModel {
  final String code;
  final String name;
  final String flag;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.flag,
  });

  /// Primary constructor: builds from the static CurrencyData map entries.
  factory CurrencyModel.fromStaticData(Map<String, String> data) {
    return CurrencyModel(
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      flag: data['flag'] ?? '🏳️',
    );
  }

  /// Fallback constructor: builds from the Frankfurter API MapEntry.
  /// Flag is looked up separately via CurrencyData.flagFor().
  factory CurrencyModel.fromApiEntry(MapEntry<String, dynamic> e, String flag) {
    return CurrencyModel(code: e.key, name: e.value.toString(), flag: flag);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CurrencyModel && other.code == code);

  @override
  int get hashCode => code.hashCode;
}
