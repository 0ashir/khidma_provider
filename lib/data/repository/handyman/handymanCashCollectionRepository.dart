import '../../../app/generalImports.dart';

class HandymanCashCollectionRepository {
  Future<({List<HandymanCashCollectionModel> rows, int total, HandymanCashCollectionSummary summary})>
      fetchList({required Map<String, dynamic> params}) async {
    try {
      final response = await ApiClient.post(
        url: ApiUrl.handymanGetCashCollectionList,
        parameter: params,
        useAuthToken: true,
      );

      final rows = (response['data'] as List? ?? [])
          .map((e) => HandymanCashCollectionModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final total = int.tryParse(response['total']?.toString() ?? '0') ?? 0;

      final summary = HandymanCashCollectionSummary.fromJson(
        response['summary'] as Map<String, dynamic>? ?? {},
      );

      return (rows: rows, total: total, summary: summary);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
