import '../../../../app/generalImports.dart';

enum SortOrder {
  none, // 0
  ascending, // 1
  descending, // 2
}

extension SortOrderExtension on SortOrder {
  String get asset {
    switch (this) {
      case SortOrder.ascending:
        return AppAssets.ascendingFilter;
      case SortOrder.descending:
        return AppAssets.descendingFilter;
      default:
        return AppAssets.defaultFilter;
    }
  }

  Color? backgroundColor(BuildContext context) {
    return this == SortOrder.none ? null : context.colorScheme.secondaryColor;
  }

  Color? svgColor(BuildContext context) {
    return this == SortOrder.none ? context.colorScheme.blackColor : null;
  }
}
