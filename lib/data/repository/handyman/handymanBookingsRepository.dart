import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

import '../../../app/generalImports.dart';

class HandymanBookingsRepository {
  Future<DataOutput<HandymanBookingListItem>> fetchBookings({
    required int offset,
    int limit = 10,
    String? status,
    String? search,
    String sort = 'date_of_service',
    String order = 'DESC',
  }) async {
    try {
      final Map<String, dynamic> params = {
        ApiParam.limit: limit,
        ApiParam.offset: offset,
        ApiParam.order: order,
        ApiParam.sort: sort,
      };
      if (status != null && status.isNotEmpty) {
        params[ApiParam.status] = status;
      }
      if (search != null && search.isNotEmpty) {
        params[ApiParam.search] = search;
      }

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.handymanGetBookings,
        parameter: params,
        useAuthToken: true,
      );

      final List<HandymanBookingListItem> modelList;
      if (response['data'] == null ||
          (response['data'] is Map && response['data']['data'] == null)) {
        modelList = [];
      } else {
        final rawList = response['data'] is List
            ? response['data'] as List
            : (response['data']['data'] as List? ?? []);
        modelList = rawList
            .map(
              (e) => HandymanBookingListItem.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      }

      return DataOutput<HandymanBookingListItem>(
        total: int.tryParse(response['total']?.toString() ?? '0') ?? 0,
        modelList: modelList,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<HandymanBookingDetail> fetchBookingDetails({
    required String orderId,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.handymanGetBookingDetails,
        parameter: {ApiParam.orderId: orderId},
        useAuthToken: true,
      );

      if (response['error'] == true) {
        throw ApiException(response['message']?.toString() ?? 'fetchFailed');
      }

      final data = response['data'];
      final Map<String, dynamic> detailJson = data is List
          ? Map<String, dynamic>.from(data.first)
          : Map<String, dynamic>.from(data);

      return HandymanBookingDetail.fromJson(detailJson);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<HandymanStatusUpdateResult> updateBookingStatus({
    required String orderId,
    required String status,
    String? rejectedReason,
    String? otp,
    List<Map<String, dynamic>>? additionalCharges,
    List<Map<String, dynamic>>? workProof,
  }) async {
    try {
      final Map<String, dynamic> params = {
        ApiParam.orderId: orderId,
        ApiParam.status: status,
      };

      if (rejectedReason != null && rejectedReason.isNotEmpty) {
        params[ApiParam.rejectedReason] = rejectedReason;
      }
      if (otp != null && otp.isNotEmpty) {
        params[ApiParam.otp] = otp;
      }
      if (additionalCharges != null) {
        for (int i = 0; i < additionalCharges.length; i++) {
          params['booking_ended_additional_charges[$i][name]'] =
              additionalCharges[i]['name'];
          params['booking_ended_additional_charges[$i][charge]'] =
              additionalCharges[i]['charge'];
        }
      }
      // if (additionalCharges != null && additionalCharges.isNotEmpty) {
      //   params[ApiParam.bookingEndedAdditionalCharges] = additionalCharges;
      // }
      if (workProof != null) {
        final String fileParamKey = status == 'booking_ended'
            ? 'work_complete_files'
            : 'work_started_files';
        for (int i = 0; i < workProof.length; i++) {
          final file = workProof[i]['file'] as File;
          final fileType = workProof[i]['fileType']?.toString() ?? 'jpeg';
          params['$fileParamKey[$i]'] = await MultipartFile.fromFile(
            file.path,
            filename: p.basename(file.path),
            contentType: MediaType('image', fileType),
          );
        }
      }

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.handymanUpdateBookingStatus,
        parameter: params,
        useAuthToken: true,
      );

      return HandymanStatusUpdateResult.fromJson(response);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
