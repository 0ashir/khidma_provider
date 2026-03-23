import '../../../../config.dart';

class SplashLayout extends StatelessWidget {
  const SplashLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*  Container(
                child: AnimatedContainer(
                    alignment: Alignment.center,
                    height: Sizes.s10,
                    width:  Sizes.s10,
                    duration: const Duration(seconds: 1),
                    child: Text("ft",
                        style: appCss.dmDenseMedium10.textColor(const Color(0xffFFFFFF)))
                ).decorated(
                    color: const appColor(context).appTheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r14)))
            ), */
          ],
        ),
      ),
    );
  }
}
