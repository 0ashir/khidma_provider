import 'dart:convert';

class TimeSlotModel {
  final String? message;
  final String time;
  final int isAvailable;

  TimeSlotModel({required this.time, required this.isAvailable, this.message});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'time': time, 'is_available': isAvailable};
  }

  factory TimeSlotModel.fromMap(Map<String, dynamic> map) {
    return TimeSlotModel(
      message: map["message"]?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      isAvailable: map['is_available']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlotModel.fromJson(String source) =>
      TimeSlotModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TimeSlotModel(time: $time, isAvailable: $isAvailable)';

  @override
  bool operator ==(covariant TimeSlotModel other) {
    if (identical(this, other)) return true;

    return other.time == time && other.isAvailable == isAvailable;
  }

  @override
  int get hashCode => time.hashCode ^ isAvailable.hashCode;
}
