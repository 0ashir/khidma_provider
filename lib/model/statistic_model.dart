class StatisticModel {
  double? totalRevenue;
  int? totalBookings;
  int? totalUsers;
  int? totalServices;
  int? totalProviders;
  int? totalCategories;
  int? totalServicemen;

  StatisticModel(
      {this.totalRevenue,
      this.totalBookings,
      this.totalUsers,
      this.totalServices,
      this.totalProviders,
      this.totalCategories,
      this.totalServicemen});

  StatisticModel.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['total_revenue'] != null
        ? double.parse(json['total_revenue'].toString())
        : 0;
    totalBookings = json['total_Bookings'] != null
        ? int.parse(json['total_Bookings'].toString())
        : 0;
    totalUsers = json['total_users'] != null
        ? int.parse(json['total_users'].toString())
        : 0;
    totalServices = json['total_services'] != null
        ? int.parse(json['total_services'].toString())
        : 0;
    totalProviders = json['total_providers'] != null
        ? int.parse(json['total_providers'].toString())
        : 0;
    totalCategories = json['total_categories'] != null
        ? int.parse(json['total_categories'].toString())
        : 0;
    totalServicemen = json['total_servicemen'] != null
        ? int.parse(json['total_servicemen'].toString())
        : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_revenue'] = totalRevenue;
    data['total_Bookings'] = totalBookings;
    data['total_users'] = totalUsers;
    data['total_services'] = totalServices;
    data['total_providers'] = totalProviders;
    data['total_categories'] = totalCategories;
    data['total_servicemen'] = totalServicemen;
    return data;
  }
}
