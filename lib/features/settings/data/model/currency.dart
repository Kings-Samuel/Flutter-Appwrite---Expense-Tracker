class Currency {
  String? symbol;
  String? name;
  String? symbolNative;
  int? decimalDigits;
  double? rounding;
  String? code;
  String? namePlural;

  Currency(
      {this.symbol,
      this.name,
      this.symbolNative,
      this.decimalDigits,
      this.rounding,
      this.code,
      this.namePlural});

  Currency.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    name = json['name'];
    symbolNative = json['symbolNative'];
    decimalDigits = json['decimalDigits'];
    rounding = json['rounding'] != null ? double.parse("${json['rounding']}") : null;
    code = json['code'];
    namePlural = json['namePlural'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    data['symbolNative'] = symbolNative;
    data['decimalDigits'] = decimalDigits;
    data['rounding'] = rounding;
    data['code'] = code;
    data['namePlural'] = namePlural;
    return data;
  }
}