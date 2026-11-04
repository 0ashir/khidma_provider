import '../../../app/generalImports.dart';

class HandymanReviewsRepository {
  Future<({List<HandymanReviewModel> reviews, int total})> fetchReviews({
    required int offset,
    String search = '',
  }) async {
    final Map<String, dynamic> params = {
      ApiParam.limit: UiUtils.limit,
      ApiParam.offset: offset,
    };
    if (search.isNotEmpty) params['search'] = search;

    final response = await ApiClient.post(
      url: ApiUrl.handymanGetMyReviews,
      parameter: params,
      useAuthToken: true,
    );

    final reviews = (response['data'] as List? ?? [])
        .map((e) => HandymanReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = int.tryParse(response['total']?.toString() ?? '0') ?? 0;

    return (reviews: reviews, total: total);
  }
}
