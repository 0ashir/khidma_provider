enum LoginType {
  email('email'),
  phone('phone');

  const LoginType(this.value);
  final String value;

  /// Convert API string value to LoginType enum
  static LoginType fromAPIValue(String? apiValue) {
    switch (apiValue?.toLowerCase()) {
      case 'email':
        return LoginType.email;
      case 'phone':
        return LoginType.phone;
      default:
        return LoginType.phone; // Default to phone for backward compatibility
    }
  }

  /// Check if login type is email
  bool get isEmail => this == LoginType.email;

  /// Check if login type is phone
  bool get isPhone => this == LoginType.phone;
}

/// Role of the authenticated user. The login endpoint serves both roles and
/// returns the role via `user_type`; anything that isn't `handyman` is treated
/// as a provider.
enum UserType {
  provider('provider'),
  handyman('handyman');

  const UserType(this.value);
  final String value;

  /// Convert an API / stored string value to a [UserType]. Defaults to
  /// [UserType.provider] for unknown or missing values.
  static UserType fromValue(String? value) {
    switch (value?.toLowerCase()) {
      case 'handyman':
        return UserType.handyman;
      default:
        return UserType.provider;
    }
  }

  bool get isHandyman => this == UserType.handyman;

  bool get isProvider => this == UserType.provider;
}
