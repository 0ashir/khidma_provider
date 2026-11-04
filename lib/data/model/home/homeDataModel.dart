import 'package:edemand_partner/app/generalImports.dart';

class HomeDataModel {
  final SubscriptionInformation? subscriptionInformation;
  final BookingCountingModel? bookings;
  final EarningReport? earningReport;
  final CustomJobs? customJobs;
  final SalesData? salesData;

  HomeDataModel({
    this.subscriptionInformation,
    this.bookings,
    this.earningReport,
    this.customJobs,
    this.salesData,
  });

  HomeDataModel.fromJson(Map<String, dynamic> json)
    : subscriptionInformation =
          (json['subscription_information'] is Map<String, dynamic> &&
              (json['subscription_information'] as Map<String, dynamic>)
                  .isNotEmpty)
          ? SubscriptionInformation.fromJson(
              json['subscription_information'] as Map<String, dynamic>,
            )
          : null,
      bookings =
          (json['bookings'] is Map<String, dynamic> &&
              (json['bookings'] as Map<String, dynamic>).isNotEmpty)
          ? BookingCountingModel.fromJson(
              json['bookings'] as Map<String, dynamic>,
            )
          : null,
      earningReport =
          (json['earning_report'] is Map<String, dynamic> &&
              (json['earning_report'] as Map<String, dynamic>).isNotEmpty)
          ? EarningReport.fromJson(
              json['earning_report'] as Map<String, dynamic>,
            )
          : null,
      customJobs =
          (json['custom_jobs'] is Map<String, dynamic> &&
              (json['custom_jobs'] as Map<String, dynamic>).isNotEmpty)
          ? CustomJobs.fromJson(json['custom_jobs'] as Map<String, dynamic>)
          : null,
      salesData =
          (json['sales_data'] is Map<String, dynamic> &&
              (json['sales_data'] as Map<String, dynamic>).isNotEmpty)
          ? SalesData.fromJson(json['sales_data'] as Map<String, dynamic>)
          : null;
}
