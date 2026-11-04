import 'package:flutter/widgets.dart';

/// Device types based on screen size
enum DeviceType { smallPhone, largePhone, tablet, largeTablet }

extension Sizing on num {
  /// Responsive height based
  double rh(BuildContext context) {
    final deviceType = _getDeviceType(context);

    switch (deviceType) {
      case DeviceType.smallPhone:
        return this * 0.9;
      case DeviceType.largePhone:
        return this * 1;
      case DeviceType.tablet:
        return this * 1.3;
      case DeviceType.largeTablet:
        return this * 1.5;
    }
  }

  /// Responsive width based
  double rw(BuildContext context) {
    final deviceType = _getDeviceType(context);

    switch (deviceType) {
      case DeviceType.smallPhone:
        return this * 0.9;
      case DeviceType.largePhone:
        return this * 1;
      case DeviceType.tablet:
        return this * 1.3;
      case DeviceType.largeTablet:
        return this * 1.5;
    }
  }

  /// Safe responsive scaling - use only to show big images or banner
  double rs(BuildContext context) {
    final deviceType = _getDeviceType(context);

    return this *
        switch (deviceType) {
          DeviceType.smallPhone => 0.9,
          DeviceType.largePhone => 1,
          DeviceType.tablet => 1.5,
          DeviceType.largeTablet => 2.5,
        };
  }

  /// Responsive font scaling
  double rf(BuildContext context) {
    final deviceType = _getDeviceType(context);

    return this *
        switch (deviceType) {
          DeviceType.smallPhone => 0.75,
          DeviceType.largePhone => 1,
          DeviceType.tablet => 1.15,
          DeviceType.largeTablet => 1.25,
        };
  }

  /// Helper method to determine device type
  static DeviceType _getDeviceType(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;

    return switch (shortestSide) {
      >= 900 => DeviceType.largeTablet,
      >= 600 => DeviceType.tablet,
      >= 300 => DeviceType.largePhone,
      _ => DeviceType.smallPhone,
    };
  }
}

/// Helper class for device detection and safe values
class ResponsiveHelper {
  static bool isSmallPhone(BuildContext context) {
    return _getDeviceType(context) == DeviceType.smallPhone;
  }

  /// Check if device is a tablet (screen width >= 600)
  static bool isTablet(BuildContext context) {
    return _getDeviceType(context) == DeviceType.tablet ||
        _getDeviceType(context) == DeviceType.largeTablet;
  }

  /// Check if device is a large tablet (screen width >= 900)
  static bool isLargeTablet(BuildContext context) {
    return _getDeviceType(context) == DeviceType.largeTablet;
  }

  /// Get screen type for debugging
  static String getScreenType(BuildContext context) {
    final deviceType = _getDeviceType(context);
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;

    return switch (deviceType) {
      DeviceType.largeTablet => 'Large Tablet /Shortest Side: $shortestSide',
      DeviceType.tablet => 'Tablet /Shortest Side: $shortestSide',
      DeviceType.largePhone => 'Large Phone /Shortest Side: $shortestSide',
      DeviceType.smallPhone => 'Small Phone /Shortest Side: $shortestSide',
    };
  }

  /// Helper method to determine device type
  static DeviceType _getDeviceType(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;

    return switch (shortestSide) {
      >= 900 => DeviceType.largeTablet,
      >= 600 => DeviceType.tablet,
      >= 300 => DeviceType.largePhone,
      _ => DeviceType.smallPhone,
    };
  }
}
