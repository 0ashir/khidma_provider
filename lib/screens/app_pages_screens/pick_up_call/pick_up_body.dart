import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../../config.dart';
import '../../../model/call_model.dart';

class PickupBody extends StatefulWidget {
  final Call? call;
  final CameraController? cameraController;
  final String? imageUrl;

  const PickupBody(
      {super.key, this.call, this.imageUrl, this.cameraController});

  @override
  State<PickupBody> createState() => _PickupBodyState();
}

class _PickupBodyState extends State<PickupBody> {
  //end call delete after end call
  Future<bool> endCall() async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName.calls)
          .doc(widget.call!.callerId)
          .collection(collectionName.calling)
          .where("callerId", isEqualTo: widget.call!.callerId)
          .limit(1)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          FirebaseFirestore.instance
              .collection(collectionName.calls)
              .doc(widget.call!.callerId)
              .collection(collectionName.calling)
              .doc(value.docs[0].id)
              .delete();
        }
      });
      await FirebaseFirestore.instance
          .collection(collectionName.calls)
          .doc(widget.call!.receiverId)
          .collection(collectionName.calling)
          .where("receiverId", isEqualTo: widget.call!.receiverId)
          .limit(1)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          FirebaseFirestore.instance
              .collection(collectionName.calls)
              .doc(widget.call!.receiverId)
              .collection(collectionName.calling)
              .doc(value.docs[0].id)
              .delete();
        }
      });

      return true;
    } catch (e) {
      log("error : $e");
      return false;
    }
  }

  endCallTap() async {
    await endCall();
    FirebaseFirestore.instance
        .collection(collectionName.calls)
        .doc(widget.call!.callerId)
        .collection(collectionName.collectionCallHistory)
        .doc(widget.call!.timestamp.toString())
        .set({
      'type': 'outGoing',
      'isVideoCall': widget.call!.isVideoCall,
      'id': widget.call!.receiverId,
      'timestamp': widget.call!.timestamp,
      'dp': widget.call!.receiverPic,
      'isMuted': false,
      'receiverId': widget.call!.receiverId,
      "isGroup": widget.call!.isGroup,
      "groupName": widget.call!.groupName,
      'isJoin': false,
      'started': null,
      'callerName': widget.call!.receiverName,
      'status': 'rejected',
      'ended': DateTime.now(),
    }, SetOptions(merge: true));
    FirebaseFirestore.instance
        .collection(collectionName.calls)
        .doc(widget.call!.receiverId)
        .collection(collectionName.collectionCallHistory)
        .doc(widget.call!.timestamp.toString())
        .set({
      'type': 'INCOMING',
      'isVideoCall': widget.call!.isVideoCall,
      'id': widget.call!.callerId,
      'timestamp': widget.call!.timestamp,
      'dp': widget.call!.callerPic,
      'isMuted': false,
      'receiverId': widget.call!.receiverId,
      'isJoin': true,
      'started': null,
      "isGroup": widget.call!.isGroup,
      "groupName": widget.call!.groupName,
      'callerName': widget.call!.callerName!,
      'status': 'rejected',
      'ended': DateTime.now(),
    }, SetOptions(merge: true));
  }


//get camera permission
  static Future<PermissionStatus> getCameraPermission() async {
    PermissionStatus cameraPermission = await Permission.camera.request();
    log("cameraPermission : $cameraPermission");
    if (cameraPermission != PermissionStatus.granted &&
        cameraPermission != PermissionStatus.denied) {
      return Permission.camera as FutureOr<PermissionStatus>? ??
          PermissionStatus.granted;
    } else {
      return cameraPermission;
    }
  }

  // get microphone permission
  static Future<PermissionStatus> getMicrophonePermission() async {
    if (await Permission.microphone.request().isGranted) {
      return PermissionStatus.granted;
    } else {
      return PermissionStatus.denied;
    }
  }

  static void _handleInvalidPermissions(
      PermissionStatus cameraPermissionStatus,
      PermissionStatus microphonePermissionStatus,
      ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  Future<bool> getCameraMicrophonePermissions() async {
    PermissionStatus cameraPermissionStatus = await getCameraPermission();
    PermissionStatus microphonePermissionStatus =
    await getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  pickUpCall(context) async {
    getCameraMicrophonePermissions().then((value) {
      var data = {
        "channelName": widget.call!.channelId,
        "call": widget.call,
        "token": widget.call!.agoraToken
      };
      if (widget.call!.isVideoCall!) {
        /* Get.toNamed(routeName.videoCall, arguments: data);*/
        route.pushNamed(context, routeName.videoCall, arg: data);
        log("isVideo Call:::${widget.call!.agoraToken}");
        log("widget.call::${widget.call}");
        log("widget.call!.channelId::${widget.call!.channelId}");

      } else {
        log("isVideo Call:::${widget.call!.agoraToken}");
        log("widget.call::${widget.call}");
        log("widget.call!.channelId::${widget.call!.channelId}");
        route.pushNamed(context, routeName.audioCall, arg: data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          widget.call!.isVideoCall == true
              ? widget.cameraController == null? Container(
            color: appColor(context).appTheme.fieldCardBg,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ): CameraPreview(widget.cameraController!)
                  .height(MediaQuery.of(context).size.height)
              : Container(
                  color: appColor(context).appTheme.fieldCardBg,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
          Column(
            children: [
              const VSpace(Sizes.s50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(eSvgAssets.arrowLeft),
                  Expanded(
                      child: Text(widget.call!.callerName!,
                          textAlign: TextAlign.center,
                          style: appCss.dmDenseMedium18
                              .textColor(appColor(context).appTheme.darkText)))
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: Sizes.s20),
          Align(
              alignment: Alignment.center,
              child: Container(
                      height: Sizes.s140,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.call!.callerPic!)),
                          shape: BoxShape.circle))
                  .paddingAll(5.11)
                  .decorated(
                      color: appColor(context).appTheme.whiteBg,
                      shape: BoxShape.circle)),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: Sizes.s50,
                    width: Sizes.s50,
                    child: SvgPicture.asset(
                      eSvgAssets.callEnd,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                      .decorated(
                          shape: BoxShape.circle,
                          color: appColor(context).appTheme.red)
                      .paddingAll(3)
                      .decorated(
                          shape: BoxShape.circle,
                          color: appColor(context).appTheme.trans)
                      .inkWell(onTap: () => endCallTap()),
                  SizedBox(
                    height: Sizes.s50,
                    width: Sizes.s50,
                    child: SvgPicture.asset(
                      eSvgAssets.call,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                      .decorated(
                          shape: BoxShape.circle,
                          color: appColor(context).appTheme.green)
                      .paddingAll(3)
                      .decorated(
                          shape: BoxShape.circle,
                          color: appColor(context).appTheme.trans)
                      .inkWell(onTap: () => pickUpCall(context))
                ],
              ).marginOnly(bottom: Sizes.s30))
        ],
      ),
    );
  }
}
