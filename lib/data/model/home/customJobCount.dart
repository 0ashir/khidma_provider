import 'package:edemand_partner/app/generalImports.dart';

class CustomJobs {
  final int? totalOpenJobs;
  final List<JobRequestModel>? openJobs;

  CustomJobs({this.totalOpenJobs, this.openJobs});

  CustomJobs.fromJson(Map<String, dynamic> json)
    : totalOpenJobs = json['total_open_jobs']?.toInt() ?? 0,
      openJobs = (json['open_jobs'] as List?)
          ?.map(
            (dynamic e) => JobRequestModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
}
