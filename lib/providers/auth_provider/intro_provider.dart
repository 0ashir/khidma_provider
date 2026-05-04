import 'package:fixit_provider/config.dart';

class IntroProvider with ChangeNotifier {
  int selectedIndex = 0;

  //intro screen on change
  onTapOption(index) {
    selectedIndex = index;
    notifyListeners();
  }

  //on continue skip page redirect to login
  onContinue(context) async {
    hideLoading(context);
    if (selectedIndex == 0) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      isFreelancer = false;
      prefs.setBool("isFreelancer", isFreelancer);
      route.pushNamed(context, routeName.signUpCompany);
    } else {
      route.pushNamed(context, routeName.signUpFreelancer);
      notifyListeners();
    }
  }

  //option select for signup as company or freelance
  onSignUp(context) {
    showDialog(
        context: context,
        builder: (context1) {
          return StatefulBuilder(builder: (context2, setState) {
            return Consumer<IntroProvider>(builder: (context, value, child) {
              return AlertDialogCommon(
                  isBooked: true,
                  title: translations!.selectOption,
                  widget: Column(children: [
                    Text(language(context, translations!.toCreateAnew),
                        style: appCss.dmDenseMedium13
                            .textColor(appColor(context).appTheme.lightText)),
                    const VSpace(Sizes.s15),
                    Text(language(context, translations!.iAmJoining),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.primary))
                        .alignment(Alignment.centerLeft),
                    const VSpace(Sizes.s35),
                    Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: appArray.joiningList
                                .asMap()
                                .entries
                                .map((e) => JoiningLayout(
                                    data: e.value,
                                    index: e.key,
                                    selectedIndex: selectedIndex,
                                    onTap: () => onTapOption(e.key)))
                                .toList())
                        .paddingSymmetric(horizontal: Insets.i10)
                  ]),
                  subtext: "",
                  bText1: translations!.continues,
                  b1OnTap: () => onContinue(context));
            });
          });
        });
  }
}
