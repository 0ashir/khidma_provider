import '../../app/generalImports.dart';
import '../../data/repository/handyman/handymanProfileRepository.dart';

abstract class HandymanProfileState {}

class HandymanProfileInitial extends HandymanProfileState {}

class HandymanProfileInProgress extends HandymanProfileState {}

class HandymanProfileSuccess extends HandymanProfileState {
  final HandymanProfileModel profile;
  HandymanProfileSuccess(this.profile);
}

/// Emitted during updateProfile while keeping the existing profile visible.
/// Consumers that display profile data should treat this the same as Success.
class HandymanProfileUpdating extends HandymanProfileState {
  final HandymanProfileModel profile;
  HandymanProfileUpdating(this.profile);
}

class HandymanProfileFailure extends HandymanProfileState {
  final String errorMessage;
  HandymanProfileFailure(this.errorMessage);
}

/// Emitted when update_handyman_profile returns is_logged_out: true.
/// The caller must clear the session and navigate to login.
class HandymanProfileLoggedOut extends HandymanProfileState {}

/// Returns the profile from Success or Updating states; null otherwise.
extension HandymanProfileStateX on HandymanProfileState {
  HandymanProfileModel? get currentProfile {
    if (this is HandymanProfileSuccess) return (this as HandymanProfileSuccess).profile;
    if (this is HandymanProfileUpdating) return (this as HandymanProfileUpdating).profile;
    return null;
  }
}

class HandymanProfileCubit extends Cubit<HandymanProfileState> {
  HandymanProfileCubit() : super(HandymanProfileInitial());

  final HandymanProfileRepository _repository = HandymanProfileRepository();

  Future<void> fetchProfile() async {
    try {
      emit(HandymanProfileInProgress());
      final profile = await _repository.fetchProfile();
      emit(HandymanProfileSuccess(profile));
    } catch (e) {
      emit(HandymanProfileFailure(e.toString()));
    }
  }

  Future<void> updateAvailability({required bool available}) async {
    final current = state;
    try {
      final newValue = await _repository.updateAvailability(
        available: available,
      );
      if (current is HandymanProfileSuccess) {
        emit(
          HandymanProfileSuccess(
            current.profile.copyWith(isAvailable: newValue),
          ),
        );
      }
    } catch (e) {
      // Revert UI — emit a new Success object so BLoC doesn't suppress it.
      if (current is HandymanProfileSuccess) {
        emit(HandymanProfileSuccess(current.profile));
      }
      emit(HandymanProfileFailure(e.toString()));
    }
  }

  Future<void> updateProfile({
    required Map<String, String> usernameByLang,
    required String phone,
    required String countryCode,
    String? email,
    String? address,
    String? profileImagePath,
    Map<String, dynamic> customFieldValues = const {},
  }) async {
    final current = state;
    try {
      if (current is HandymanProfileSuccess) {
        emit(HandymanProfileUpdating(current.profile));
      } else {
        emit(HandymanProfileInProgress());
      }
      final result = await _repository.updateProfile(
        usernameByLang: usernameByLang,
        phone: phone,
        countryCode: countryCode,
        email: email,
        address: address,
        profileImagePath: profileImagePath,
        customFieldValues: customFieldValues,
      );
      if (result.isLoggedOut) {
        emit(HandymanProfileLoggedOut());
      } else {
        emit(HandymanProfileSuccess(result.profile!));
      }
    } catch (e) {
      emit(HandymanProfileFailure(e.toString()));
    }
  }
}
