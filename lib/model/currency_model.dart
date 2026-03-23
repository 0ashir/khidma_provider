import '../config.dart';

class CurrencyModel {
  int? id;
  String? code;
  String? symbol;
  String? symbolPosition;
  int? noOfDecimal;
  double? exchangeRate;
  String? thousandsSeparator;
  String? decimalSeparator;

  int? status;
  String? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Media>? media;

  CurrencyModel(
      {this.id,
      this.code,
      this.symbol,
      this.symbolPosition,
      this.noOfDecimal,
      this.exchangeRate,
      this.thousandsSeparator,
      this.decimalSeparator,
      this.status,
      this.createdById,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.media});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    code = json['code'];
    symbol = json['symbol'];
    symbolPosition = json['symbol_position'];
    noOfDecimal = json['no_of_decimal'];
    exchangeRate = json['exchange_rate'] != null
        ? double.parse(json['exchange_rate'].toString())
        : null;
    thousandsSeparator = json['thousands_separator'];
    decimalSeparator = json['decimal_separator'];

    status = json['status'];
    createdById = json['created_by_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['symbol'] = symbol;
    data['symbol_position'] = symbolPosition;
    data['no_of_decimal'] = noOfDecimal;
    data['exchange_rate'] = exchangeRate;
    data['thousands_separator'] = thousandsSeparator;
    data['decimal_separator'] = decimalSeparator;

    data['status'] = status;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
