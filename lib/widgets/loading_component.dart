import '../config.dart';

class LoadingComponent extends StatelessWidget {
  final Widget child;
  const LoadingComponent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      child,
      Consumer<LoadingProvider>(builder: (context, ctrl, child) {
        return ctrl.isLoading == true
            ? Container(
                width: screenWidth,
                height: screenHeight,
                color: isDark(context)
                    ? Colors.black.withOpacity(.3)
                    : appColor(context).appTheme.darkText.withOpacity(0.2),
                child: Center(
                    child:
                        Image.asset(eGifAssets.loaderGif, height: Sizes.s100)))
            : Container();
      })
    ]);
  }
}
