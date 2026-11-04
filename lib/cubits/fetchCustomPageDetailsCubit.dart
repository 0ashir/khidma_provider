import 'package:edemand_partner/app/generalImports.dart';

abstract class FetchCustomPageDetailsState {}

class FetchCustomPageDetailsInitial extends FetchCustomPageDetailsState {}

class FetchCustomPageDetailsInProgress extends FetchCustomPageDetailsState {}

class FetchCustomPageDetailsSuccess extends FetchCustomPageDetailsState {
  final String content;
  FetchCustomPageDetailsSuccess({required this.content});
}

class FetchCustomPageDetailsFailure extends FetchCustomPageDetailsState {
  final String errorMessage;
  FetchCustomPageDetailsFailure({required this.errorMessage});
}

class FetchCustomPageDetailsCubit extends Cubit<FetchCustomPageDetailsState> {
  final CustomPageRepository customPageRepository;

  FetchCustomPageDetailsCubit(this.customPageRepository)
    : super(FetchCustomPageDetailsInitial());

  Future<void> fetchCustomPageDetails({
    required String pageKey,
    UserType? requestedUserType,
  }) async {
    try {
      emit(FetchCustomPageDetailsInProgress());
      final String content = await customPageRepository.getPageSetting(
        pageKey,
        requestedUserType: requestedUserType,
      );
      emit(FetchCustomPageDetailsSuccess(content: content));
    } catch (e) {
      emit(FetchCustomPageDetailsFailure(errorMessage: e.toString()));
    }
  }
}
