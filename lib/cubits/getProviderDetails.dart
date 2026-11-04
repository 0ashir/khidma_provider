import '../../app/generalImports.dart';

abstract class GetProviderDetailsState {}

class GetProviderDetailsInitialState extends GetProviderDetailsState {}

class GetProviderDetailsInProgressState extends GetProviderDetailsState {}

class GetProviderDetailsSuccessState extends GetProviderDetailsState {
  final ProviderDetails providerDetails;

  GetProviderDetailsSuccessState({required this.providerDetails});
}

class GetProviderDetailsFailureState extends GetProviderDetailsState {
  final String errorMessage;

  GetProviderDetailsFailureState(this.errorMessage);
}

class GetProviderDetailsCubit extends Cubit<GetProviderDetailsState> {
  GetProviderDetailsCubit() : super(GetProviderDetailsInitialState());
  final AuthRepository _authRepository = AuthRepository();

  Future<void> getProviderDetails() async {
    try {
      emit(GetProviderDetailsInProgressState());

      final Map<String, dynamic> result = await _authRepository
          .getProviderDetails();
      emit(
        GetProviderDetailsSuccessState(
          providerDetails: ProviderDetails.fromJson(Map.from(result["data"])),
        ),
      );
    } catch (e) {
      emit(GetProviderDetailsFailureState(e.toString()));
    }
  }
}
