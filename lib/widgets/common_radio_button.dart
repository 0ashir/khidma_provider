import '../config.dart';

class CommonRadioBool extends StatelessWidget {

  final GestureTapCallback? onTap;
  final bool? selectedIndex;
  const CommonRadioBool({super.key,this.onTap,this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: Sizes.s22,
        height: Sizes.s22,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: selectedIndex! ? appColor(context).appTheme.trans : appColor(context).appTheme.stroke),
            color: selectedIndex! ? appColor(context).appTheme.primary.withOpacity(0.18) :  appColor(context).appTheme.trans ),
        child:  selectedIndex! ? Icon(Icons.circle,
            color: appColor(context).appTheme.primary, size: 13) : null).inkWell(onTap: onTap);
  }
}

