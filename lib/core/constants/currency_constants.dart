class CurrencyConstants {
  static const List<CurrencyModel> currencies = [
    CurrencyModel(code: 'TRY', name: 'Türk Lirası', symbol: '₺', flag: '🇹🇷'),
    CurrencyModel(code: 'USD', name: 'Amerikan Doları', symbol: '\$', flag: '🇺🇸'),
    CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
    CurrencyModel(code: 'GBP', name: 'İngiliz Sterlini', symbol: '£', flag: '🇬🇧'),
    CurrencyModel(code: 'JPY', name: 'Japon Yeni', symbol: '¥', flag: '🇯🇵'),
    CurrencyModel(code: 'CHF', name: 'İsviçre Frangı', symbol: 'CHF', flag: '🇨🇭'),
    CurrencyModel(code: 'CAD', name: 'Kanada Doları', symbol: 'C\$', flag: '🇨🇦'),
    CurrencyModel(code: 'AUD', name: 'Avustralya Doları', symbol: 'A\$', flag: '🇦🇺'),
    CurrencyModel(code: 'CNY', name: 'Çin Yuanı', symbol: '¥', flag: '🇨🇳'),
    CurrencyModel(code: 'KRW', name: 'Güney Kore Wonu', symbol: '₩', flag: '🇰🇷'),
    CurrencyModel(code: 'RUB', name: 'Rus Rublesi', symbol: '₽', flag: '🇷🇺'),
    CurrencyModel(code: 'SAR', name: 'Suudi Arabistan Riyali', symbol: '﷼', flag: '🇸🇦'),
    CurrencyModel(code: 'AED', name: 'Birleşik Arap Emirlikleri Dirhemi', symbol: 'د.إ', flag: '🇦🇪'),
  ];

  static CurrencyModel getCurrencyByCode(String code) {
    return currencies.firstWhere(
      (currency) => currency.code == code,
      orElse: () => currencies.first, // Varsayılan olarak TRY döndür
    );
  }

  static String getCurrencyName(String code) {
    return getCurrencyByCode(code).name;
  }

  static String getCurrencySymbol(String code) {
    return getCurrencyByCode(code).symbol;
  }

  static String getCurrencyFlag(String code) {
    return getCurrencyByCode(code).flag;
  }
}

class CurrencyModel {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  const CurrencyModel({required this.code, required this.name, required this.symbol, required this.flag});
}
