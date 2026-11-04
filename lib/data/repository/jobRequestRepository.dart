import 'package:edemand_partner/app/generalImports.dart';

class jobRequestRepository {
  Future<DataOutput<JobRequestModel>> fetchCustomJobRequest({
    required int offset,
    required String? jobType,
    String? id,
  }) async {
    try {
      final Map<String, dynamic> parameters = {
        ApiParam.jobType: ?jobType,
        ApiParam.offset: offset,
        ApiParam.limit: UiUtils.limit,
        ApiParam.id: ?id,
      };
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getCustomRequestJob,
        parameter: parameters,
        useAuthToken: true,
      );

      List<JobRequestModel> modelList;
      if (response['data'].isEmpty) {
        modelList = [];
      } else {
        modelList = (response['data'] as List).map((element) {
          return JobRequestModel.fromJson(element);
        }).toList();
      }

      return DataOutput<JobRequestModel>(
        total: response['total'] ?? "0",
        modelList: modelList,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchCustomJobValue({
    String? customJobValue,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.manageCustomJobRequest,
        parameter: {ApiParam.customJobValue: customJobValue},
        useAuthToken: true,
      );

      return {'message': response['message'], 'error': response['error']};
    } catch (e) {
      return {'message': e.toString(), 'error': true};
    }
  }

  Future<Map<String, dynamic>> applyForCustomJob({
    required String? id,
    required String? counterPrice,
    required String? coverNote,
    required String? duration,
    String? taxId,
  }) async {
    try {
      final Map<String, dynamic> parameters = {
        ApiParam.customJobRequestId: id,
        ApiParam.counterPrice: counterPrice,
        ApiParam.coverNote: coverNote,
        ApiParam.duration: duration,
        ApiParam.taxId: taxId,
      };
      final response = await ApiClient.post(
        url: ApiUrl.applyForCustomJob,
        parameter: parameters,
        useAuthToken: true,
      );

      return {
        'error': response['error'],
        'message': response['message'],
        'data': response['data'] ?? [],
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
