import 'dart:developer';

import '../config.dart';

class RevenueModel {
  List<ChartData> monthlyRevenues =[];
  List<ChartData> yearlyRevenues = [];
  List<ChartData> weekdayRevenues = [];

  RevenueModel(
      {required this.weekdayRevenues,required this.monthlyRevenues,required this.yearlyRevenues});

  RevenueModel.fromJson(Map<String, dynamic> json) {
    json['yearlyRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x:key, y: double.parse(n.toString()));
      yearlyRevenues.add(chartData);
    });
    json['monthlyRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x:key, y: double.parse(n.toString()));
      monthlyRevenues.add(chartData);
    });
    json['weekdayRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x:key, y: double.parse(n.toString()));
      weekdayRevenues.add(chartData);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (monthlyRevenues.isNotEmpty) {
      data['monthlyRevenues'] = monthlyRevenues.map((v) =>  v.toJson()).toList();
    }
    if (yearlyRevenues.isNotEmpty) {
      data['yearlyRevenues'] = yearlyRevenues.map((v) =>  v.toJson()).toList();
    }
    if (weekdayRevenues.isNotEmpty) {
      data['weekdayRevenues'] = weekdayRevenues.map((v) =>  v.toJson()).toList();
    }
    return data;
  }
}