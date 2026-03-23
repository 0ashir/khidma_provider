import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

//
const mail = 'mailto:';
const call = 'tel:';
const googleMapLink = 'https://www.google.com/maps/search/?api=1&query=';
const wpLink = 'whatsapp://send?phone=';

enum MessageType { text, image, audio, video, offer }

//return color as per status
Color colorCondition(String? text, context) {
  if (text == translations!.pending) {
    return appColor(context).appTheme.pending;
  } else if (text == translations!.accepted) {
    return appColor(context).appTheme.accepted;
  } else if (text == translations!.ongoing || text == appFonts.startAgain) {
    return appColor(context).appTheme.ongoing;
  } else if (text == translations!.cancel) {
    return appColor(context).appTheme.red;
  } else if (text == translations!.pendingApproval) {
    return appColor(context).appTheme.pendingApproval;
  } else if (text == appFonts.onHold) {
    return appColor(context).appTheme.hold;
  } else if (text == translations!.assigned) {
    return appColor(context).appTheme.assign;
  } else if (text == appFonts.ontheway1) {
    return appColor(context).appTheme.onTheWay;
  } else {
    return appColor(context).appTheme.primary;
  }
}

//star condition
starCondition(String? rate) {
  if (rate == "0") {
    return eSvgAssets.star;
  } else if (rate == "0.5") {
    return eSvgAssets.star;
  } else if (rate == "1") {
    return eSvgAssets.star1;
  } else if (rate == "1.5") {
    return eSvgAssets.star1;
  } else if (rate == "2") {
    return eSvgAssets.star2;
  } else if (rate == "3") {
    return eSvgAssets.star3;
  } else if (rate == "4") {
    return eSvgAssets.star4;
  } else if (rate == "5") {
    return eSvgAssets.star5;
  } else {
    return eSvgAssets.star3;
  }
}

//return month 3 character
String monthCondition(String? text) {
  if (text == '1') {
    return "JAN";
  } else if (text == '2') {
    return "FEB";
  } else if (text == '3') {
    return "MAR";
  } else if (text == '4') {
    return "APR";
  } else if (text == '5') {
    return "MAY";
  } else if (text == '6') {
    return "JUN";
  } else if (text == '7') {
    return "JUL";
  } else if (text == '8') {
    return "AUG";
  } else if (text == '9') {
    return "SEP";
  } else if (text == '10') {
    return "OCT";
  } else if (text == "11") {
    return "NOV";
  } else if (text == '12') {
    return "DEC";
  } else {
    return "JAN";
  }
}

//network connection
Future<bool> isNetworkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  } else {
    final result = await InternetAddress.lookup(
        'google.com'); //Check For Internet Connection
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // log("messageajsajds");
      return true;
    } else {
      log("messageajsajds");
      return false;
    }
  }
}

mailTap(context, String url) {
  if (url.isNotEmpty) {
    commonUrlTap(context, '$mail$url',
        launchMode: LaunchMode.externalApplication);
  }
}

commonUrlTap(context, String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    snackBarMessengers(context);
  });
}

launchCall(context, String? url) {
  if (Platform.isIOS) {
    commonUrlTap(context, '$call//${url!}',
        launchMode: LaunchMode.externalApplication);
  } else {
    commonUrlTap(context, '$call${url!}',
        launchMode: LaunchMode.externalApplication);
  }
}

launchMap(context, String? url) {
  commonUrlTap(context, googleMapLink + url!,
      launchMode: LaunchMode.externalApplication);
}

wpTap(context, String? url) {
  commonUrlTap(context, wpLink + url!,
      launchMode: LaunchMode.externalApplication);
}

getFcmToken() async {
  String? token;
  if (Platform.isAndroid) {
    token = await FirebaseMessaging.instance.getToken();
  }
  if (Platform.isIOS) {
    token = await FirebaseMessaging.instance.getAPNSToken();
    debugPrint("APNS Token: $token");
  }

  return token;
}

//fetch tax name
String getTaxName(id) {
  String name = "";
  int index =
      taxList.indexWhere((element) => element.id.toString() == id.toString());
  if (index >= 0) {
    name = taxList[index].rate!;
  }
  log("name :$name");
  return name;
}

//get time
getTime(time) {
  if (!DateTime.now().difference(time).isNegative) {
    if (DateTime.now().difference(time).inMinutes < 1) {
      return "a few seconds ago";
    } else if (DateTime.now().difference(time).inMinutes < 60) {
      return "${DateTime.now().difference(time).inMinutes} minutes ago";
    } else if (DateTime.now().difference(time).inMinutes < 1440) {
      return "${DateTime.now().difference(time).inHours} hours ago";
    } else if (DateTime.now().difference(time).inMinutes > 1440) {
      return DateFormat('dd MMM, yyyy').format(time);
    }
  }
}

showBookingStatus(context, BookingModel? bookingModel) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BookingStatusDialog(
          bookingModel: bookingModel,
        );
      });
}

String getReason(List<BookingReasons> reason, id) {
  String name = "";
  List<BookingReasons> reasonList = [];
  reasonList = reason
      .where((element) => element.statusId.toString() == id.toString())
      .toList();
  if (reasonList.isNotEmpty) {
    name = reasonList.last.reason!;
  }
  return name;
}

getDate(date) {
  DateTime now = DateTime.now();
  String when;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (dateTime.day == now.day) {
    when = 'Today';
  } else if (dateTime.day == now.subtract(const Duration(days: 1)).day) {
    when = 'Yesterday';
  } else {
    when = "${DateFormat.MMMd().format(dateTime)}-other";
  }
  return when;
}

double totalServicesCharges(BookingModel bookingModel) {
  double price = 0.0;
  for (var d in bookingModel.extraCharges!) {
    price = price + d.total!;
  }
  return price;
}

/// Capitalize given String
String capitalizeFirstLetter(val) {
  return (val != null)
      ? (val![0].toString().toUpperCase() + val!.substring(1))
      : validate(value: val);
}

// Check null string, return given value if null
String validate({String? value}) {
  if (isEmptyOrNull(value)) {
    return value!;
  } else {
    return value!;
  }
}

/// Returns true if given String is null or isEmpty
bool isEmptyOrNull(val) =>
    val == null ||
    (val != null && val!.isEmpty) ||
    (val != null && val! == 'null');

String getCategoryName(List<dynamic> cat) {
  String name = "";
  String commaSeparatedNames = cat.map((person) => person.title).join(', ');
  name = commaSeparatedNames;
  return name;
}

etCategoryCommission(List<dynamic> cat) {
  // Convert commissions to double
  List<int> categoryCommission =
      cat.map((person) => int.parse(person.commission.toString())).toList();

  // Find the maximum value
  int maxNumber = categoryCommission.reduce((a, b) => a > b ? a : b);
  log("Highest value: $maxNumber");

  // Return the maximum value as a string if needed
  return maxNumber.toString();
}
