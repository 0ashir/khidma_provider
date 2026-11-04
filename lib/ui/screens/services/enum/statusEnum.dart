import 'package:edemand_partner/app/generalImports.dart';

enum StateStatus {
  active("Active", AppAssets.activeState),
  deactive("Deactive", AppAssets.deactive);

  final String label;
  final String svgImage;

  const StateStatus(this.label, this.svgImage);

  static StateStatus fromApi(String apiValue) {
    switch (apiValue.toLowerCase()) {
      case "active":
        return StateStatus.active;
      case "deactive":
        return StateStatus.deactive;
      default:
        return StateStatus.deactive; // Default to `deactive`
    }
  }

  Color getStatusColor(BuildContext context) {
    return this == StateStatus.active
        ? AppColors.greenColor
        : context.colorScheme.lightGreyColor;
  }

  /// Get text color based on the status
  Color getTextColor(BuildContext context) {
    return this == StateStatus.active
        ? context.colorScheme.blackColor
        : context.colorScheme.lightGreyColor;
  }

  static List<StateStatus> get filteredStatuses => [
    StateStatus.active,
    StateStatus.deactive,
  ];
}
