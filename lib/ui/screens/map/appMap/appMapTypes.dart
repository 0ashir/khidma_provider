import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor;

class AppLatLng {
  const AppLatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class AppMapMarker {
  const AppMapMarker({
    required this.id,
    required this.position,
    this.googleIcon,
    this.osmChild,
    this.onTap,
    this.anchor = const Offset(0.5, 1),
    this.infoWindowTitle,
  });

  final String id;
  final AppLatLng position;

  /// Icon used on the Google Maps path, e.g. `BitmapDescriptor.defaultMarkerWithHue(...)`.
  final BitmapDescriptor? googleIcon;

  /// Google Maps path only: title shown in the marker's default info window.
  final String? infoWindowTitle;

  /// Widget used on the OpenStreetMap path, e.g. an `SvgPicture.asset(...)` or `Icon(...)`.
  final Widget? osmChild;

  final VoidCallback? onTap;

  /// Relative anchor of the marker against [position], e.g. (0.5, 1) = bottom-center pin.
  final Offset anchor;
}

class AppMapPolyline {
  const AppMapPolyline({
    required this.id,
    required this.points,
    required this.color,
    this.width = 3,
  });

  final String id;
  final List<AppLatLng> points;
  final Color color;
  final double width;
}
