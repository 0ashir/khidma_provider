import '../../../config.dart';

class ServicemanBottomNav extends StatelessWidget {
  const ServicemanBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, ThemeService>(
        builder: (contextTheme, value, theme, child) {
      return IntrinsicHeight(
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: value
                  .dashboardList()
                  .asMap()
                  .entries
                  .map((e) => Expanded(
                        child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              isDark(context)
                                  ? AnimatedScale(
                                      curve: Curves.fastOutSlowIn,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      scale: value.selectIndex == e.key &&
                                              value.expanded
                                          ? 1.3
                                          : 1,
                                      child: SvgPicture.asset(
                                          value.selectIndex == e.key
                                              ? e.value.icon2
                                              : e.value.icon,
                                          height: Sizes.s24,
                                          width: Sizes.s24,
                                          colorFilter: ColorFilter.mode(
                                              (isDark(context) &&
                                                      value.selectIndex ==
                                                          e.key)
                                                  ? appColor(context)
                                                      .appTheme
                                                      .primary
                                                  : appColor(context)
                                                      .appTheme
                                                      .darkText,
                                              BlendMode.srcIn),
                                          fit: BoxFit.scaleDown),
                                    )
                                  : AnimatedScale(
                                      duration: const Duration(seconds: 1),
                                      scale: value.selectIndex == e.key &&
                                              value.expanded
                                          ? 1.3
                                          : 1,
                                      child: SvgPicture.asset(
                                          value.selectIndex == e.key
                                              ? e.value.icon2
                                              : e.value.icon,
                                          height: Sizes.s24,
                                          colorFilter: ColorFilter.mode(
                                              value.selectIndex == e.key
                                                  ? appColor(context)
                                                      .appTheme
                                                      .primary
                                                  : appColor(context)
                                                      .appTheme
                                                      .darkText,
                                              BlendMode.srcIn),
                                          width: Sizes.s24,
                                          fit: BoxFit.scaleDown),
                                    ),
                              const VSpace(Sizes.s5),
                              Text(language(context, e.value.title),
                                  overflow: TextOverflow.ellipsis,
                                  style: value.selectIndex == e.key
                                      ? appCss.dmDenseMedium14.textColor(
                                          appColor(context).appTheme.primary)
                                      : appCss.dmDenseRegular14.textColor(
                                          appColor(context).appTheme.darkText))
                            ])
                            .inkWell(onTap: () => value.onTap(e.key, context)),
                      ))
                  .toList()));
    });
  }
}
