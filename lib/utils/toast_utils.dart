import 'package:fluttertoast/fluttertoast.dart';
import '../config.dart';

enum ToastType { success, error, warning, info }

class ToastUtils {
  static void showCustomToast(
    BuildContext context,
    String message, {
    String type = "info", // success | error | info
  }) {
    final fToast = FToast();
    fToast.init(context);

    Color bgColor;

    switch (type) {
      case "success":
        bgColor = appColor(context).appTheme.primary;
        break;
      case "error":
        bgColor = appColor(context).appTheme.red;
        break;
      case "info":
      default:
        bgColor = const Color(0xFF323232);
    }

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: bgColor,
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}

void showToast(
  BuildContext context,
  String message, {
  String type = "info",
}) {
  ToastUtils.showCustomToast(
    context,
    message,
    type: type,
  );
}

void showSuccessToast(BuildContext context, String msg) {
  showToast(context, msg, type: "success");
}

void showErrorToast(BuildContext context, String msg) {
  showToast(context, msg, type: "error");
}

void showInfoToast(BuildContext context, String msg) {
  showToast(context, msg, type: "info");
}
