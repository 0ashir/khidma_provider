import '../../app/generalImports.dart';

abstract class EditProviderDetailsState {}

class EditProviderDetailsInitial extends EditProviderDetailsState {}

class EditProviderDetailsInProgress extends EditProviderDetailsState {}

class EditProviderDetailsSuccess extends EditProviderDetailsState {
  EditProviderDetailsSuccess({
    required this.isError,
    required this.message,
    required this.providerDetails,
  });

  final bool isError;
  final String message;
  final ProviderDetails providerDetails;
}

class EditProviderDetailsFailure extends EditProviderDetailsState {
  EditProviderDetailsFailure({required this.errorMessage});

  final String errorMessage;
}

class EditProviderDetailsCubit extends Cubit<EditProviderDetailsState> {
  EditProviderDetailsCubit() : super(EditProviderDetailsInitial());
  final AuthRepository _authRepository = AuthRepository();

  Future<void> editProviderDetails({
    required ProviderDetails providerDetails,
  }) async {
    try {
      emit(EditProviderDetailsInProgress());

      final Map<String, dynamic> parameters = providerDetails.toJson();

      if (parameters['other_images'] != null &&
          parameters['other_images'].isNotEmpty) {
        for (int i = 0; i < parameters['other_images'].length; i++) {
          parameters['other_images[$i]'] = await MultipartFile.fromFile(
            parameters['other_images'][i],
          );
        }
      }
      parameters.remove('other_images');

      if (parameters['custom_fields'] != null) {
        final List<Map<String, dynamic>> customFields =
            List<Map<String, dynamic>>.from(parameters['custom_fields']);
        for (int i = 0; i < customFields.length; i++) {
          final field = customFields[i];
          parameters['custom_fields[$i][custom_field_id]'] =
              field['custom_field_id'];
          if (field['value'] != null && field['value'].toString().isNotEmpty) {
            final String valueStr = field['value'].toString();
            // In Dart, File.existsSync doesn't throw on regular strings, it just returns false
            try {
              if (File(valueStr).existsSync()) {
                parameters['custom_fields[$i][value]'] =
                    await MultipartFile.fromFile(valueStr);
              } else {
                parameters['custom_fields[$i][value]'] = valueStr;
              }
            } catch (e) {
              parameters['custom_fields[$i][value]'] = valueStr;
            }
          }
        }
        parameters.remove('custom_fields');
      }

      if (parameters['image'] != '' && parameters['image'] != null) {
        parameters['image'] = await MultipartFile.fromFile(parameters['image']);
      } else {
        parameters.remove('image');
      }
      if (parameters['banner_image'] != '' &&
          parameters['banner_image'] != null) {
        parameters['banner_image'] = await MultipartFile.fromFile(
          parameters['banner_image'],
        );
      } else {
        parameters.remove('banner_image');
      }
      if (parameters['national_id'] != '' &&
          parameters['national_id'] != null) {
        parameters['national_id'] = await MultipartFile.fromFile(
          parameters['national_id'],
        );
      } else {
        parameters.remove('national_id');
      }

      if (parameters['seo_og_image'] != '' &&
          parameters['seo_og_image'] != null) {
        parameters['seo_og_image'] = await MultipartFile.fromFile(
          parameters['seo_og_image'],
        );
      } else {
        parameters.remove('seo_og_image');
      }
      if (parameters['address_id'] != '' && parameters['address_id'] != null) {
        parameters['address_id'] = await MultipartFile.fromFile(
          parameters['address_id'],
        );
      } else {
        parameters.remove('address_id');
      }
      if (parameters['passport'] != '' && parameters['passport'] != null) {
        parameters['passport'] = await MultipartFile.fromFile(
          parameters['passport'],
        );
      } else {
        parameters.remove('passport');
      }

      final Map<String, dynamic> responseData = await _authRepository
          .registerProvider(parameters: parameters, isAuthTokenRequired: true);

      if (!responseData['error']) {
        final updatedProviderDetails =
            responseData['providerDetails'] as ProviderDetails;

        // Log profile update
        ClarityService.logAction(ClarityActions.profileUpdated, {
          'provider_id': updatedProviderDetails.user?.id ?? '',
          'company_name':
              updatedProviderDetails.providerInformation
                  ?.getTranslatedCompanyName(
                    HiveRepository.getCurrentLanguage()?.languageCode ?? 'en',
                  ) ??
              '',
        });

        emit(
          EditProviderDetailsSuccess(
            providerDetails: updatedProviderDetails,
            isError: responseData['error'],
            message: responseData['message'],
          ),
        );
        return;
      }

      emit(EditProviderDetailsFailure(errorMessage: responseData['message']));
    } catch (e, st) {
      emit(EditProviderDetailsFailure(errorMessage: st.toString()));
    }
  }
}
