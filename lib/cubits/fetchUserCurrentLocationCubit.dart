import 'package:edemand_partner/app/generalImports.dart';

abstract class FetchUserCurrentLocationState {}

class FetchUserCurrentLocationInitial extends FetchUserCurrentLocationState {}

class FetchUserCurrentLocationInProgress
    extends FetchUserCurrentLocationState {}

class FetchUserCurrentLocationSuccess extends FetchUserCurrentLocationState {
  final Position position;

  FetchUserCurrentLocationSuccess({required this.position});
}

class FetchUserCurrentLocationFailure extends FetchUserCurrentLocationState {
  FetchUserCurrentLocationFailure({required this.errorMessage});

  final String errorMessage;
}

class FetchUserCurrentLocationCubit
    extends Cubit<FetchUserCurrentLocationState> {
  FetchUserCurrentLocationCubit() : super(FetchUserCurrentLocationInitial());

  Future<void> fetchUserCurrentLocation() async {
    try {
      emit(FetchUserCurrentLocationInProgress());
      final Position? position = await LocationRepository.getCurrentLocation();
      if (position != null) {
        emit(FetchUserCurrentLocationSuccess(position: position));
      } else {
        emit(
          FetchUserCurrentLocationFailure(
            errorMessage: "pleaseAllowLocationPermission",
          ),
        );
      }
    } catch (e) {
      emit(FetchUserCurrentLocationFailure(errorMessage: e.toString()));
    }
  }
}
