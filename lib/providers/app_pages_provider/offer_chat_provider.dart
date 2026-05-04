import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config.dart';
import '../../firebase/firebase_api.dart';
import '../../screens/app_pages_screens/add_new_service_screen/layouts/category_bottom_sheet.dart';
import '../../widgets/year_dialog.dart';

class OfferChatProvider with ChangeNotifier {
  bool isCheck = false;
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController durationCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController servicemenCtrl = TextEditingController();
  FocusNode descriptionFocus = FocusNode();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode chatFocus = FocusNode();
  List<ChatModel> chatList = [];
  String? chatId, image, name, role, token, code, phone, senderName;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages = [];
  List<DateTimeChip> localMessage = [];
  int? userId;
  StreamSubscription? messageSub;
  XFile? imageFile;
  String activeStatus = "Offline";
  List<CategoryModel> categories = [], newCatList = [];
  List<Services> serviceList = [];
  TextEditingController filterSearchCtrl = TextEditingController();
  final FocusNode filterSearchFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  String? durationValue;
  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  GlobalKey<FormState> addOffer = GlobalKey<FormState>();
  List<CategoryModel> newCategoryList = [];

  dynamic chosenValue;
  DateTime? slotSelectedDay;
  DateTime slotSelectedYear = DateTime.now();
  DateTime? selectedDay;
  DateTime selectedYear = DateTime.now();
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  CalendarFormat calendarFormat = CalendarFormat.month;
  int demoInt = 0;
  PageController pageController = PageController();
  TextEditingController categoryCtrl = TextEditingController();
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime currentDate = DateTime.now();
  String? month;
  String showYear = 'Select Year';

  checkBox() {
    isCheck = !isCheck;
    notifyListeners();
  }

  //select duration unit
  onChangeDuration(val) {
    durationValue = val;
    notifyListeners();
  }

  //category selection
  onChangeCategory(CategoryModel val, id, bool isCheck) {
    log(" id:::$id");
    newCategoryList = [];
    //categories = val;
    if (!categories.contains(val)) {
      log("val.parentId:: ${val.parentId}");
      if (val.parentId != null) {
        int index = newCatList.indexWhere(
            (element) => element.id.toString() == val.parentId.toString());
        if (index >= 0) {
          if (!categories.contains(newCatList[index])) {
            categories.add(newCatList[index]);
          }
        }
      }
      categories.add(val);
      isCheck = true;
      log("categories::$categories");
    } else {
      log("categories::");
      categories.remove(val);
    }

    notifyListeners();
    categories.asMap().entries.forEach((e) {
      int index =
          allCategoryList.indexWhere((element) => element.id == e.value.id);
      if (index >= 0) {
        newCategoryList.add(allCategoryList[index]);
      }
    });
    // notifyListeners();
    log("NewCategoris:::${newCategoryList.length}");
    if (newCategoryList.isNotEmpty) {
      var largestGeekValue = newCategoryList.reduce((current, next) =>
          double.parse(current.commission!.toString()) >
                  double.parse(next.commission!.toString())
              ? current
              : next);
    }
    notifyListeners();
  }

  getCategory({search}) async {
    // notifyListeners();
    try {
      String apiUrl = "${api.category}?providerId=${userModel!.id}";
      if (search != null) {
        apiUrl = "${api.category}?providerId=${userModel!.id}&search=$search";
      } else {
        apiUrl = "${api.category}?providerId=${userModel!.id}";
      }
      await apiServices.getApi(apiUrl, []).then((value) {
        newCatList = [];
        if (value.isSuccess!) {
          List category = value.data;
          for (var data in category.reversed.toList()) {
            if (!newCatList.contains(CategoryModel.fromJson(data))) {
              newCatList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }

  List<Services> allServiceList = [];

  onBottomSheet(context) {
    if (newCatList.isEmpty) {
      newCatList = allCategoryList;
    }
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return const CategoryBottomSheet(isOffer: true);
        });
  }

  //month selection
  onTapMonth(val) {
    month = val;
    notifyListeners();
  }

  //date range selection
  onRangeSelect(start, end, focusedDay) {
    selectedDay = null;
    currentDate = focusedDay;
    rangeStart = start;
    rangeEnd = end;
    log("STTT :$start");
    log("STTT :$rangeStart");
    log("STTT :$rangeEnd");
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    startDateCtrl.text = DateFormat("dd-MM-yyyy").format(rangeStart!);
    endDateCtrl.text =
        rangeEnd != null ? DateFormat("dd-MM-yyyy").format(rangeEnd!) : "";
    notifyListeners();
  }

  //select year
  selectYear(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context3) {
          return YearAlertDialog(
              selectedDate: selectedYear,
              onChanged: (DateTime dateTime) {
                selectedYear = dateTime;
                showYear = "${dateTime.year}";
                focusedDay.value = DateTime.utc(selectedYear.year,
                    chosenValue["index"], focusedDay.value.day + 0);
                onDaySelected(focusedDay.value, focusedDay.value);
                notifyListeners();
                route.pop(context);
                log("YEAR CHANGE : ${focusedDay.value}");
              });
        });
  }

  //right arrow button click functionality
  onRightArrow() {
    pageController.nextPage(
        duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
    final newMonth = focusedDay.value.add(const Duration(days: 30));
    focusedDay.value = newMonth;
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == focusedDay.value.month);
    chosenValue = appArray.monthList[index];
    selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
        focusedDay.value.day + 0);
    notifyListeners();
  }

  //left arrow button click functionality
  onLeftArrow() {
    if (focusedDay.value.month != DateTime.january ||
        focusedDay.value.year != DateTime.now().year) {
      pageController.previousPage(
          duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
      final newMonth = focusedDay.value.subtract(const Duration(days: 30));
      focusedDay.value = newMonth;
      int index = appArray.monthList
          .indexWhere((element) => element['index'] == focusedDay.value.month);
      chosenValue = appArray.monthList[index];
      selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
          focusedDay.value.day + 0);
    }
    notifyListeners();
  }

  //date selection
  void onDaySelected(DateTime selectDay, DateTime fDay) {
    notifyListeners();
    focusedDay.value = selectDay;
  }

  //table calendar page change
  onPageCtrl(dayFocused) {
    focusedDay.value = dayFocused;
    demoInt = dayFocused.year;
    notifyListeners();
  }

// table calendar create
  onCalendarCreate(controller) {
    pageController = controller;
  }

  //month selection dropdown option
  onDropDownChange(choseVal) {
    notifyListeners();
    chosenValue = choseVal;

    notifyListeners();
    int index = choseVal['index'];
    focusedDay.value =
        DateTime.utc(focusedDay.value.year, index, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
  }

  // date selection button and go to back
  onSelect(context) {
    route.pop(context);
    if (rangeEnd != null) {
      log("hesidfij");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text("opps!! you have not select date yet.",
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.whiteColor)),
          backgroundColor: appColor(context).appTheme.red));
    }
    notifyListeners();
  }

  //on date select from calendar
  onDateSelect(context, date, {isStart = true}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Consumer<OfferChatProvider>(
                  builder: (context, value, child) {
                return const DateRangePickerLayout(
                  isOffer: true,
                );
              });
            }));
  }

  saveOfferInChatInFirebase(context) async {
    final chat = Provider.of<OfferChatProvider>(context, listen: false);

    log("DATE :${categories}");
    if (addOffer.currentState!.validate()) {
      if (startDateCtrl.text.isNotEmpty) {
        if (endDateCtrl.text.isNotEmpty) {
          dynamic content = {
            "title": titleCtrl.text,
            "description": descriptionCtrl.text,
            for (var i = 0; i < categories.length; i++)
              "category_ids[$i]": categories[i].id,
            "is_servicemen_required": isCheck,
            "required_servicemen":
                isCheck ? int.tryParse(servicemenCtrl.text) : 1,
            "price": double.tryParse(priceCtrl.text) ?? 0.0,
            "provider_id": userModel!.id,
            "duration": durationCtrl.text,
            "duration_unit": durationValue,
            "status": "pending",
            "started_at": startDateCtrl.text,
            "ended_at": endDateCtrl.text,
            "user_id": chat.userId.toString(),
          };
          log("content:$content");
          await chat.setMessage(content, MessageType.offer, context);
          route.pop(context);
        } else {
          snackBarMessengers(context,
              message: language(context, appFonts.pleaseSelectEndDate));
        }
      } else {
        snackBarMessengers(context,
            message: language(context, appFonts.pleaseSelectStartDate));
      }
    }
  }

  onReady(context) async {
    try {
      // showLoading(context);
      notifyListeners();

      messageSub?.cancel();
      messageSub = null;
      allMessages = [];
      localMessage = [];

      dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
      if (data != "") {
        userId = int.parse(data['userId'].toString());
        name = data['name'];
        image = data['image'];
        role = data['role'];
        token = data['token'];
        phone = data['phone'].toString();
        code = data['code']?.toString();
        chatId = data['chatId']?.toString();
      }

      if (chatId == "0") {
        chatId = null;
      }
      focusedDay.value = DateTime.utc(focusedDay.value.year,
          focusedDay.value.month, focusedDay.value.day + 0);
      onDaySelected(focusedDay.value, focusedDay.value);
      DateTime dateTime = DateTime.now();
      int index = appArray.monthList
          .indexWhere((element) => element['index'] == dateTime.month);
      chosenValue = appArray.monthList[index];
      log("name;$name");
      //bookingId = booking!.id;
      await getChatData(context);
      getCategory();
      notifyListeners();
      getActiveStatus();
      hideLoading(context);
    } catch (e) {
      hideLoading(context);
      log("EEEE onREADY CHAT : $e");
    }
  }

  //user active status
  getActiveStatus() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .get()
        .then((value) {
      if (value.exists) {
        activeStatus = value.data()!['status'];
      }
    });
    notifyListeners();
  }

  onBack(context, isBack) {
    messageSub?.cancel();
    allMessages = [];
    localMessage = [];
    messageSub = null;
    chatId = null;
    image = null;
    name = null;
    role = null;
    token = null;
    code = null;
    phone = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  Future<void> showLayout(context) async {
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppRadius.r12))),
              content:
                  Consumer<LanguageProvider>(builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, translations!.selectOne),
                            style: appCss.dmDenseBold18.textColor(
                                appColor(context).appTheme.darkText)),
                        const Icon(CupertinoIcons.multiply)
                            .inkWell(onTap: () => route.pop(context))
                      ],
                    ),
                    const VSpace(Sizes.s20),
                    ...appArray.selectList
                        .asMap()
                        .entries
                        .map((e) => SelectOptionLayout(
                            data: e.value,
                            index: e.key,
                            list: appArray.selectList,
                            onTap: () {
                              if (e.key == 0) {
                                pickAndUploadFile(context, ImageSource.gallery);
                              } else {
                                pickAndUploadFile(context, ImageSource.camera);
                              }
                            }))
                  ],
                );
              }));
        });
  }

  // Pick media from gallery (Image or Video)
  Future pickMediaGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    // Use pickMedia for combined selection if available
    final XFile? pickedFile = await picker.pickMedia();

    if (pickedFile != null) {
      route.pop(context);
      bool isVideo = pickedFile.path.toLowerCase().endsWith('.mp4') ||
          pickedFile.path.toLowerCase().endsWith('.mov') ||
          pickedFile.path.toLowerCase().endsWith('.m4v');
      await uploadFile(navigatorKey.currentContext!, pickedFile,
          isVideo: isVideo);
    }
  }

  Future getImage(BuildContext context1, ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    imageFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (imageFile != null) {
      notifyListeners();
      route.pop(context1);

      await uploadFile(
        navigatorKey.currentContext!,
        imageFile!, // ✅ non-null assertion
        isVideo: false, // ✅ image only
      );
    }
  }

  // Function to pick and upload files (images or videos)
  Future pickAndUploadFile(BuildContext context, ImageSource source,
      {bool isVideo = false}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile;

      // Pick image or video based on the flag
      if (isVideo) {
        pickedFile = await picker.pickVideo(
            source: source, maxDuration: const Duration(minutes: 2));
      } else {
        pickedFile = await picker.pickImage(source: source, imageQuality: 70);
      }

      if (pickedFile != null) {
        log("Picked file path: ${pickedFile.path}");

        // Notify listeners (if required in your state management)
        notifyListeners();

        // Close the selection sheet IMMEDIATELY
        route.pop(context);

        // Upload the file
        await uploadFile(context, pickedFile,
            isVideo: pickedFile.name.contains(".mp4") ? true : false);
      } else {
        log("No file selected.");
      }
    } catch (e) {
      log("Error picking file: $e");
      snackBarMessengers(
        context,
        color: appColor(context).appTheme.red,
        message: "Error picking file: $e",
      );
    }
  }

  Future uploadFile(BuildContext context, XFile file,
      {bool isVideo = false}) async {
    // showLoading(context);

    try {
      showLoading(context);
      notifyListeners();
      FocusScope.of(context).unfocus();

      final fileName = "${DateTime.now().millisecondsSinceEpoch}_${file.name}";
      final ref = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = ref.putFile(File(file.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      log("Uploaded: $downloadUrl");

      await setMessage(
          downloadUrl, isVideo ? MessageType.video : MessageType.image, context,
          isShowLoader: false);

      imageFile = null;
      notifyListeners();
    } catch (e) {
      log("Upload error: $e");

      snackBarMessengers(
        context,
        color: appColor(context).appTheme.red,
        message: "Failed to upload file",
      );
    } finally {
      // 🔥 GUARANTEED TO EXECUTE
      hideLoading(context);
    }
  }

  Future<void> makePhoneCall(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  onTapPhone(context) async {
    log("CODE :$code $phone");
    launchCall(context, phone);
    notifyListeners();
  }

  Future getChatData(context) async {
    log("chatIdsd :$chatId ///$userId // ${userModel!.id}");
    if (chatId != "0" && chatId != null) {
      messageSub?.cancel();
      messageSub = FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userModel!.id.toString())
          .collection(collectionName.messages)
          .doc(chatId.toString())
          .collection(collectionName.chat)
          .snapshots()
          .listen((event) async {
        allMessages = event.docs;
        notifyListeners();

        FirebaseApi().getLocalMessageOffer(context);
        log("allMessages :$allMessages");
        notifyListeners();
        seenMessage();
      });
      // hideLoading(context);
      notifyListeners();
    } else {
      chatId = "0";
      messageSub = null;
      allMessages = [];
      localMessage = [];
      // hideLoading(context);
      notifyListeners();
    }

    notifyListeners();
  }

  //seen all message
  seenMessage() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.messages)
        .doc(chatId.toString())
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      log("RECEIVER : ${value.docs.length}");
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.messages)
            .doc(chatId.toString())
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });

    log("userModel!.id.toString() :${userModel!.id.toString()}");
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: chatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({"isSeen": true});
      }
    });

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.messages)
        .doc(chatId.toString())
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      log("RECEIVER : ${value.docs.length}");
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.messages)
            .doc(chatId.toString())
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .collection(collectionName.chats)
        .where("bookingId", isEqualTo: chatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userId.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({"isSeen": true});
      }
    });
  }

  Widget timeLayout(BuildContext context) {
    final reversedLocalMessage = localMessage.reversed.toList();

    return ListView.builder(
      //reverse: true,
      // Reverse the entire scroll direction
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // If inside another scrollable
      itemCount: reversedLocalMessage.length,
      itemBuilder: (context, index) {
        final timeGroup = reversedLocalMessage[index];
        final timeLabel = timeGroup.time!.contains("-other")
            ? timeGroup.time!.split("-other")[0]
            : timeGroup.time!;

        final messages = timeGroup.message!.reversed.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeLabel,
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.lightText),
            ).center(),
            ...messages.asMap().entries.map((entry) {
              final msgIndex = entry.key;
              final msg = entry.value;
              log("newMessageList::${msg.docId}");
              return buildItem(
                msgIndex,
                msg,
                msg.docId,
                timeLabel,
                context,
              );
            }).toList(),
          ],
        );
      },
    );
  }

// BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
  Widget buildItem(
      int index, MessageModel document, documentId, title, context) {
    if (document.senderId.toString() == userModel!.id.toString()) {
      log("index:::$index");
      /*   return SenderMessage(
          document: document,
          index: index,
          docId: document.docId,
          title: title);*/

      return ChatLayout(
              document: document,
              index: index,
              isSentByMe: true,
              isEmailOrPhone: (document.content.toString().contains("@") ||
                      document.content.toString().contains(".com") ||
                      document.content.toString().contains(".gmail"))
                  ? Validation().emailValidation(context, document.content) ==
                          null ||
                      Validation().validateMobile(document.content)
                  : false)
          .padding(top: Sizes.s5);
    } else {
      // RECEIVER MESSAGE

      return ChatLayout(
              document: document,
              isSentByMe: false,
              isEmailOrPhone: document.content.toString().contains("@") ||
                      document.content.toString().contains(".com") ||
                      document.content.toString().contains(".gmail")
                  ? Validation().emailValidation(context, document.content) ==
                          null ||
                      Validation().validateMobile(document.content)
                  : false)
          .padding(top: Sizes.s5);
    }
  }

  // SEND MESSAGE CLICK
  Future<void> setMessage(content, MessageType? type, context,
      {bool isShowLoader = true}) async {
    bool isNotEmpty = false;
    if (content is String) {
      isNotEmpty = content.trim().isNotEmpty;
    } else if (content is Map) {
      isNotEmpty = content.isNotEmpty;
    }

    if (isNotEmpty) {
      try {
        if (isShowLoader) showLoading(context);

        // Use existing chatId if available, otherwise generate a new one.
        if (chatId == null || chatId == "" || chatId == "0") {
          // chatId = DateTime.now().microsecondsSinceEpoch.toString();
          final s = int.parse(userModel!.id.toString());
          final r = int.parse(userId.toString());
          final low = s < r ? s : r;
          final high = s < r ? r : s;
          chatId = "${low}_$high";
        }

        // Timestamp for the message
        String time = DateTime.now().millisecondsSinceEpoch.toString();

        // Create the message model
        MessageModel messageModel = MessageModel(
          chatId: chatId,
          // Use the existing or newly created chatId
          content: content,
          docId: time,
          messageType: "sender",
          receiverId: userId!.toString(),
          senderId: userModel!.id!.toString(),
          timestamp: time,
          type: type!.name,
          receiverImage: image,
          receiverName: name,
          senderImage: userModel!.media != null && userModel!.media!.isNotEmpty
              ? userModel!.media![0].originalUrl!
              : null,
          senderName: userModel!.name,
          role: "user",
        );

        controller.text = "";

        // Check if there are messages for today in the local messages
        bool isEmpty =
            localMessage.where((element) => element.time == "Today").isEmpty;

        if (isEmpty) {
          List<MessageModel>? message = [];
          message.add(messageModel);
          message[0].docId = time;

          DateTimeChip dateTimeChip =
              DateTimeChip(time: getDate(time), message: message);
          localMessage.add(dateTimeChip);
        } else {
          int index =
              localMessage.indexWhere((element) => element.time == "Today");

          if (!localMessage[index].message!.contains(messageModel)) {
            localMessage[index].message!.add(messageModel);
          }
        }

        if (messageSub == null && chatId != null && chatId != "0") {
          getChatData(context);
        }

        notifyListeners();
        log("chatId: $chatId");
        log("token: $token");
        log("userModel FCM Token: ${userModel!.fcmToken}");

        // Save the message to Firebase
        await FirebaseApi().saveMessageByOffer(
            role: "user",
            receiverName: name,
            type: type,
            dateTime: time,
            encrypted: content,
            isSeen: false,
            newChatId: chatId,
            pId: userId,
            receiverImage: image,
            senderId: userModel!.id);

        await FirebaseApi().saveMessageByOffer(
            role: "user",
            receiverName: name,
            type: type,
            dateTime: time,
            encrypted: content,
            isSeen: false,
            newChatId: chatId,
            pId: userId,
            receiverImage: image,
            senderId: userId.toString());

        await FirebaseApi().saveMessageInUserCollectionByOffer(
            senderId: userModel!.id,
            rToken: token,
            sToken: userModel!.fcmToken,
            receiverImage: image,
            newChatId: chatId,
            type: type,
            receiverName: name,
            content: content,
            receiverId: userId,
            id: userModel!.id,
            role: "user",
            isOffer: true);

        await FirebaseApi().saveMessageInUserCollectionByOffer(
            senderId: userModel!.id,
            receiverImage: image,
            newChatId: chatId,
            rToken: token,
            sToken: userModel!.fcmToken,
            type: type,
            receiverName: name,
            content: content,
            receiverId: userId,
            id: userId,
            role: "user",
            isOffer: true);

        notifyListeners();
        getChatData(context);
        log("UserModel ID: ${userModel!.id}");
        if (token != "" && token != null) {
          FirebaseApi().sendNotification(
              title: "${userModel!.name} sent you a message",
              msg: content is String
                  ? content
                  : (content is Map
                      ? content['title']?.toString() ?? ""
                      : ""),
              chatId: chatId,
              token: token,
              pId: userModel!.id.toString(),
              image: image ?? "",
              name: userModel!.name,
              phone: phone,
              code: code);
        }

        // Validate email and phone content
        String contentString = content is String
            ? content
            : (content is Map ? content['title']?.toString() ?? "" : "");
        if (Validation().emailValidation(context, contentString) == null) {
          log("CHECK");
          alertEmailPhone(context, contentString);
        }
        if (Validation().validateMobile(contentString) == null) {
          alertEmailPhone(context, contentString);
          log("CHECK1");
        }

        // Retrieve chat data
        await Future.wait([getChatData(context)]);
        notifyListeners();

        // Clear controllers
        priceCtrl.clear();
        titleCtrl.clear();
        descriptionCtrl.clear();
        categoryCtrl.clear();
        controller.clear();
        endDateCtrl.clear();
        filterSearchCtrl.clear();
      } catch (e) {
        log("Error in setMessage: $e");
      } finally {
        if (isShowLoader) hideLoading(context);
      }
    }
  }

  onClearChat(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(sync, context, eImageAssets.clearChat,
        appFonts.clearChat, appFonts.areYouClearChat, () async {
      route.pop(context);
      await FirebaseApi().clearChat(context);
      value.onResetPass(context, language(context, appFonts.hurrayChatDelete),
          language(context, appFonts.okay), () => Navigator.pop(context));
    });
    value.notifyListeners();
  }

  bool isExpand = false;

  onExpand(data) {
    log("isExpadn::$data");
    isExpand = !isExpand;
    log("isExpadn::$data");
    notifyListeners();
  }

  Map<int, bool> _expandStates = {};

  bool isExpanded(int index) => _expandStates[index] ?? false;

  void toggleExpand(int index) {
    _expandStates[index] = !(_expandStates[index] ?? false);
    log("Index $index expand status: ${_expandStates[index]}");
    notifyListeners();
  }

  alertEmailPhone(context, message) async {
    try {
      var data = {
        "user_id": userModel!.id,
        "provider_id": userId,
        "message": message
      };
      log("data :$data");
      await apiServices
          .postApi(api.sendMessage, data, isToken: true)
          .then((value) {
        log("ZOOOO :${value.data}");
        // hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          log("SAVE");
        } else {
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      // hideLoading(context);
      notifyListeners();
      log("EEEE alertEmailPhone : $e");
    }
  }
}
