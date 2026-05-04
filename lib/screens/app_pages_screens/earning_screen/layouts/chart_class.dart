

import '../../../../config.dart';

class ChartDataColor {
  ChartDataColor(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}


class ChartDataColors {
  ChartDataColors(this.x, this.y, );
  final int x;
  final double y;

}


class ChartData {
  String? x;
  double? y;

  ChartData(
      {this.x,
        this.y});

  ChartData.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = double.parse(json['y'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['x'] = x;
    data['y'] = y;
    return data;
  }
}