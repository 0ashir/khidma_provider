import '../../../app/generalImports.dart';

/// Provider-side CRUD for the handymen a provider manages.
/// Backed by get_handymen / store_handyman / update_handyman /
/// delete_handyman / toggle_handyman_status / toggle_handyman_availability.
class ManageHandymanRepository {
  Future<DataOutput<HandymanModel>> getHandymen({
    required int offset,
    int? limit,
    String search = '',
  }) async {
    final Map<String, dynamic> parameters = {
      ApiParam.limit: limit ?? UiUtils.limit,
      ApiParam.offset: offset,
    };
    if (search.trim().isNotEmpty) {
      parameters[ApiParam.search] = search.trim();
    }

    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getHandymen,
      parameter: parameters,
      useAuthToken: true,
    );

    if (response['error'] == true) {
      throw ApiException(response['message'].toString());
    }

    final List<HandymanModel> handymen = ((response['data'] ?? []) as List).map(
      (value) {
        return HandymanModel.fromJson(Map<String, dynamic>.from(value));
      },
    ).toList();

    return DataOutput<HandymanModel>(
      total: int.tryParse(response['total']?.toString() ?? '0') ?? 0,
      modelList: handymen,
    );
  }

  Future<String> storeHandyman(CreateHandymanModel model) async {
    return _manageHandyman(url: ApiUrl.storeHandyman, model: model);
  }

  Future<String> updateHandyman(CreateHandymanModel model) async {
    return _manageHandyman(url: ApiUrl.updateHandyman, model: model);
  }

  Future<String> _manageHandyman({
    required String url,
    required CreateHandymanModel model,
  }) async {
    final Map<String, dynamic> parameters = model.toJson();
    parameters.removeWhere(
      (key, value) => value == null || value.toString().trim().isEmpty,
    );

    await _convertFilePathsToMultipart(parameters);

    final Map<String, dynamic> response = await ApiClient.post(
      url: url,
      parameter: parameters,
      useAuthToken: true,
    );

    if (response['error'] == true) {
      throw ApiException(response['message'].toString());
    }
    return response['message']?.toString() ?? '';
  }

  /// Converts the profile image and any custom-field file paths into
  /// [MultipartFile]s. A value is treated as a file when it points at an
  /// existing local file (matches how the form supplies absolute paths for
  /// file fields and plain text for everything else).
  Future<void> _convertFilePathsToMultipart(
    Map<String, dynamic> parameters,
  ) async {
    for (final key in parameters.keys.toList()) {
      if (key != ApiParam.profileImage && !key.startsWith('cf_')) {
        continue;
      }
      final dynamic value = parameters[key];
      if (value is String && value.isNotEmpty && File(value).existsSync()) {
        parameters[key] = await MultipartFile.fromFile(value);
      }
    }
  }

  Future<String> deleteHandyman(String handymanId) async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.deleteHandyman,
      parameter: {ApiParam.handymanId: handymanId},
      useAuthToken: true,
    );
    if (response['error'] == true) {
      throw ApiException(response['message'].toString());
    }
    return response['message']?.toString() ?? '';
  }

  /// Returns the new `active` flag (0/1).
  Future<int> toggleStatus(
    String handymanId, {
    required int currentValue,
  }) async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.toggleHandymanStatus,
      parameter: {ApiParam.handymanId: handymanId},
      useAuthToken: true,
    );
    if (response['error'] == true) {
      throw ApiException(response['message'].toString());
    }
    // API response carries no data field — infer new value by inverting current.
    return 1 - currentValue;
  }

  /// Returns the new `is_available` flag (0/1).
  Future<int> toggleAvailability(
    String handymanId, {
    required int currentValue,
  }) async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.toggleHandymanAvailability,
      parameter: {ApiParam.handymanId: handymanId},
      useAuthToken: true,
    );
    if (response['error'] == true) {
      throw ApiException(response['message'].toString());
    }
    // API response carries no data field — infer new value by inverting current.
    return 1 - currentValue;
  }
}
