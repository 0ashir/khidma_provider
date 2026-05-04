import '../../../../config.dart';

class UnlockPlan extends StatelessWidget {
  final Animation<Offset>? position;
  const UnlockPlan({super.key, this.position});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Image.asset(eImageAssets.cup),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Column(children: [
          Text(language(context, translations!.unlockYourFull),
              style: appCss.dmDenseBold14
                  .textColor(appColor(context).appTheme.darkText)),
          Text(language(context, translations!.stayAhead),
              style: appCss.dmDenseRegular11
                  .textColor(appColor(context).appTheme.darkText))
        ]),
        SizedBox(
                height: Sizes.s30,
                width: Sizes.s30,
                child: SlideTransition(
                    position: position!,
                    child: SvgPicture.asset(eSvgAssets.arrowRightYellow,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                            Color(0xffFFC412), BlendMode.srcIn))))
            .decorated(
                shape: BoxShape.circle,
                color: appColor(context).appTheme.whiteColor)
            .inkWell(
                onTap: () => route.pushReplacementNamed(
                    context,
                    userModel != null
                        ? userModel!.activeSubscription != null
                            ? routeName.dashboard
                            : routeName.planDetails
                        : routeName.intro,
                    args: userModel != null &&
                            userModel!.activeSubscription != null
                        ? ""
                        : true))
            .paddingSymmetric(horizontal: Insets.i15)
      ]).paddingOnly(bottom: Insets.i10)
    ]);
  }
}
