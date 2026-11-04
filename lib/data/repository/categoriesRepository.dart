import '../../app/generalImports.dart';

class CategoriesRepository {
  Future<DataOutput<CategoryModel>> fetchCategories({
    required int offset,
    required int limit,
  }) async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getCategoryHierarchical,
      parameter: {},
      useAuthToken: true,
    );

    final List<CategoryModel> result = (response['data'] as List).map((
      element,
    ) {
      return CategoryModel.fromJson(element);
    }).toList();

    return DataOutput<CategoryModel>(
      total: int.parse(response['total'] ?? '0'),
      modelList: result,
    );
  }

  Future<Map<String, dynamic>> manageCategoryPreference({
    required List<String>? categoryId,
  }) async {
    final Map<String, dynamic> categoryMap = {};

    for (int i = 0; i < categoryId!.length; i++) {
      categoryMap['category_id[$i]'] = categoryId[i];
    }

    final Map<String, dynamic> parameters = categoryMap;

    final response = await ApiClient.post(
      url: ApiUrl.manageCategoryPreference,
      parameter: parameters,
      useAuthToken: true,
    );

    // Check if the response contains the expected keys and handle potential null values
    if (response.containsKey('error') && response.containsKey('message')) {
      // If the response contains 'error' and 'message', proceed with the response
      final bool error = response['error'] ?? false; // Default to false if null
      final String message =
          response['message'] ??
          'Unknown error'; // Default to 'Unknown error' if null

      return {"error": error, "message": message};
    } else {
      throw Exception(
        'Invalid response format. Missing "error" or "message" keys.',
      );
    }
  }
}
