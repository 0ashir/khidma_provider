import '../../app/generalImports.dart';

class ServiceRepository {
  Future<DataOutput<ServiceModel>> fetchService({
    required int offset,
    String? searchQuery,
    // ServiceFilterDataModel? filter,
    String? order,
    String? sort,
    int? serviceId,
  }) async {
    final Map<String, dynamic> parameters = {ApiParam.offset: offset};

    if (order != null && sort != null) {
      parameters[ApiParam.sort] = sort;
      parameters[ApiParam.order] = order;
    }

    if (searchQuery != null) {
      parameters[ApiParam.search] = searchQuery.trim();
      parameters.remove(ApiParam.offset);
    }

    if (serviceId != null) {
      parameters[ApiParam.serviceId] = serviceId;
      // If only service_id is provided, offset might not be needed
      // Remove offset when serviceId is provided (similar to searchQuery)
      if (searchQuery == null) {
        parameters.remove(ApiParam.offset);
      }
    }

    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getServices,
      parameter: parameters,
      useAuthToken: true,
    );

    final List<ServiceModel> modelList = (response['data'] as List).map((
      element,
    ) {
      return ServiceModel.fromJson(element);
    }).toList();
    return DataOutput<ServiceModel>(
      extraData: ExtraData(
        data: {
          'max_price': response['max_price'],
          'min_price': response['min_price'],
          'min_discount_price': response['min_discount_price'],
          'max_discount_price': response['max_discount_price'],
        },
      ),
      total: int.parse(response['total'] ?? '0'),
      modelList: modelList,
    );
  }

  Future<DataOutput<ServiceCategoryModel>> fetchCategories({
    required int offset,
    required int limit,
  }) async {
    final Map<String, dynamic> parameters = {};
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getCategoryHierarchical,
      parameter: parameters,
      useAuthToken: true,
    );

    final List<ServiceCategoryModel> modelList = (response['data'] as List).map(
      (element) {
        return ServiceCategoryModel.fromJson(element);
      },
    ).toList();

    return DataOutput<ServiceCategoryModel>(
      total: int.parse(response['total'] ?? '0'),
      modelList: modelList,
    );
  }

  Future<Map<String, dynamic>> fetchTaxes() async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getTaxes,
      parameter: {},
      useAuthToken: true,
    );

    final List<Taxes> taxesList = (response['data'] as List).map((element) {
      return Taxes.fromJson(element);
    }).toList();

    return {
      'taxesDataList': taxesList,
      'error': response['error'],
      'message': response['message'],
    };
  }

  Future<ServiceModel> createService(CreateServiceModel dataModel) async {
    try {
      final Map<String, dynamic> parameters = dataModel.toJson();
      if (parameters['image'] != null && parameters['image'] != '') {
        parameters['image'] = await MultipartFile.fromFile(parameters['image']);
      }

      if (parameters.containsKey("other_images")) {
        for (int i = 0; i < parameters["other_images"].length; i++) {
          parameters['other_images[$i]'] = await MultipartFile.fromFile(
            parameters["other_images"][i],
          );
        }
      }
      if (parameters.containsKey("files")) {
        for (int i = 0; i < parameters["files"].length; i++) {
          parameters['files[$i]'] = await MultipartFile.fromFile(
            parameters["files"][i],
          );
        }
      }

      // Handle SEO OG Image
      if (parameters['seo_og_image'] != null &&
          parameters['seo_og_image'] != '') {
        parameters['seo_og_image'] = await MultipartFile.fromFile(
          parameters['seo_og_image'],
        );
      }

      parameters.remove("other_images");
      parameters.remove("files");
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.manageService,
        parameter: parameters,
        useAuthToken: true,
      );
      if (response['error']) {
        throw ApiException(response["message"].toString());
      }
      return ServiceModel.fromJson(response['data'][0]);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteService({required int id}) async {
    await ApiClient.post(
      url: ApiUrl.deleteService,
      parameter: {ApiParam.serviceId: id},
      useAuthToken: true,
    );
  }

  Future<DataOutput<ReviewsModel>> fetchReviews(
    int serviceId, {
    required int offset,
  }) async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getServiceRatings,
      parameter: {
        ApiParam.serviceId: serviceId,
        ApiParam.offset: offset,
        ApiParam.limit: UiUtils.limit,
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
