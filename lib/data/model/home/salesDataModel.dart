import 'package:edemand_partner/app/generalImports.dart';

class SalesData {
  final List<SalesModel> monthlySales;
  final List<SalesModel> yearlySales;
  final List<SalesModel> weeklySales;

  SalesData({
    List<SalesModel>? monthlySales,
    List<SalesModel>? yearlySales,
    List<SalesModel>? weeklySales,
  }) : monthlySales = monthlySales ?? [],
       yearlySales = yearlySales ?? [],
       weeklySales = weeklySales ?? [];

  SalesData.fromJson(Map<String, dynamic> json)
    : monthlySales =
          (json['monthly_sales'] as List?)
              ?.map(
                (dynamic e) => SalesModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      yearlySales =
          (json['yearly_sales'] as List?)
              ?.map(
                (dynamic e) => SalesModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      weeklySales =
          (json['weekly_sales'] as List?)
              ?.map(
                (dynamic e) => SalesModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [];

  Map<String, dynamic> toJson() => {
    'monthly_sales': monthlySales.map((e) => e.toJson()).toList(),
    'yearly_sales': yearlySales.map((e) => e.toJson()).toList(),
    'weekly_sales': weeklySales.map((e) => e.toJson()).toList(),
  };
}
