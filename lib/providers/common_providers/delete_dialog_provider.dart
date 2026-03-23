import 'package:dio/dio.dart';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/widgets/on_delete_dialog.dart';
import 'package:flutter/cupertino.dart';

class DeleteDialogProvider with ChangeNotifier {
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;
  bool isPositionedRight = false;
  bool isAnimateOver = false;

  double height = 6;
  double width = 6;

  //alert dialog open animation start
  onAnimate() {
    height = 6;
    width = 6;
    Future.delayed(const Duration(milliseconds: 500), () {
      height = 120;
      width = 120;

      notifyListeners();
      Future.delayed(const Duration(milliseconds: 800), () {
        height = 50;
        width = 50;
        notifyListeners();
      });
    });
    notifyListeners();
  }

  //on rest password dialog
  onResetPass(context, subtext, buttonText, onTap, {title}) {
    onAnimate();
    showDialog(
        context: context,
        builder: (context1) {
          return Consumer<DeleteDialogProvider>(
              builder: (context, value, child) {
            return AlertDialogCommon(
                isBooked: true,
                title: title ?? translations!.deleteSuccessfully,
                widget: Stack(alignment: Alignment.center, children: [
                  SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            eGifAssets.success,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ))
                      .paddingSymmetric(vertical: Insets.i8)
                      .decorated(
                          color: appColor(context).appTheme.fieldCardBg,
                          borderRadius: BorderRadius.circular(AppRadius.r10)),
                  AnimatedContainer(
                      height: height,
                      width: width,
                      curve: Curves.easeInToLinear,
                      duration: const Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(eImageAssets.successTick))))
                ]),
                subtext: subtext,
                bText1: buttonText,
                height: Sizes.s145,
                b1OnTap: onTap);
          });
        });
  }

  //animate design
  animateDesign(TickerProvider sync) {
    Future.delayed(DurationsDelay.s1).then((value) {
      isPositionedRight = true;
      notifyListeners();
    }).then((value) {
      Future.delayed(DurationsDelay.s2).then((value) {
        isAnimateOver = true;
        notifyListeners();
      }).then((value) {
        controller = AnimationController(
            vsync: sync, duration: const Duration(seconds: 2))
          ..forward();
        offsetAnimation = Tween<Offset>(
                begin: const Offset(0, 0.5), end: const Offset(0, 1.7))
            .animate(
                CurvedAnimation(parent: controller!, curve: Curves.elasticOut));
        notifyListeners();
      });
    });

    notifyListeners();
  }

  //on delete any confirmation dialog open
  onDeleteDialog(sync, context, image, title, subtitle, onDelete) {
    animateDesign(sync);
    showDialog(
        context: context,
        builder: (context1) {
          return StatefulBuilder(builder: (context2, setState) {
            return Consumer<DeleteDialogProvider>(
                builder: (context3, value, child) {
              return OnDeleteDialog(
                  image: image,
                  onDelete: onDelete,
                  subtitle: subtitle,
                  title: title);
            });
          });
        }).then((value) {
      isPositionedRight = false;
      isAnimateOver = false;
      notifyListeners();
    });
  }

  //on delete account confirmation dialog
  onDeleteAccount(TickerProvider sync, context) {
    animateDesign(sync);
    showDialog(
        context: context,
        builder: (context1) {
          return StatefulBuilder(builder: (context2, setState) {
            return Consumer<DeleteDialogProvider>(
                builder: (context3, value, child) {
              return DeleteAccountAlert(
                isAnimateOver: isAnimateOver,
                isPositionedRight: isPositionedRight,
                offsetAnimation: offsetAnimation,
              );
            });
          });
        }).then((value) {
      isPositionedRight = false;
      isAnimateOver = false;
      notifyListeners();
    });
  }

  /*  Future<void> deleteAccount(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);
    notifyListeners();

    try {
      final response = await Dio().post(
        api.deleteAccount,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      print("Delete Account Error: ${token}");
      print("Delete Account Error: ${response.statusCode}");
      if (response.statusCode == 200) {
        snackBarMessengers(context,
            message: response.data['message'],
            color: appColor(context).appTheme.primary);

        route.pushReplacementNamed(context, routeName.loginProvider);
      } else {
        /*  message = "Something went wrong."; */
      }
    } catch (e, s) {
      /* message = "Error: $e"; */
      print("Delete Account Error: $e");
      print("Delete Account Error: $token");
      print("Delete Account Error: ${s}");
    }

    /* isDeleting = false; */
    notifyListeners();
  } */

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }
}
