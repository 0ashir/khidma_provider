import '../../app/generalImports.dart';

class ReviewsRepository {
  Future<DataOutput<ReviewsModel>> fetchReviews({required int offset}) async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getServiceRatings,
      parameter: {
        ApiParam.offset: offset,
        ApiParam.limit: UiUtils.limit,
        ApiParam.order: 'DESC',
        ApiParam.sort: 'created_at',
      },
      useAuthToken: true,
    );

    final List<ReviewsModel> modelList = (response['data'] as List)
        .map((element) => ReviewsModel.fromJson(element))
        .toList();

    return DataOutput<ReviewsModel>(
      total: int.parse(response['total'] ?? '0'),
      modelList: modelList,
      extraData: ExtraData<RatingsModel>(
        data: RatingsModel.fromJson(response['ratings'][0]),
      ),
    );
  }
}
