// import 'dart:async';
// import 'dart:developer';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../config.dart';
// import '../../model/call_model.dart';
//
//
// class AudioCallProvider extends ChangeNotifier {
//   String? channelName, token;
//   Call? call;
//   bool localUserJoined = false;
//   bool isSpeaker = true, switchCamera = false;
//   late RtcEngine engine;
//   final _infoStrings = <String>[];
//   Stream<int>? timerStream;
//   int? remoteUId;
//   Timer? timer;
//   // ignore: cancel_subscriptions
//   StreamSubscription<int>? timerSubscription;
//   bool muted = false;
//   final _users = <int>[];
//   bool isAlreadyEnded = false;
//   ClientRoleType? role;
//   dynamic userData;
//   Stream<DocumentSnapshot>? stream;
//   int? remoteUidValue;
//   bool isStart = false;
//
//   // ignore: close_sinks
//   StreamController<int>? streamController;
//   String hoursStr = '00';
//   String minutesStr = '00';
//   String secondsStr = '00';
//   int counter = 0;
//
//   void stopTimer() {
//     if (!isStart) return;
//
//     timer?.cancel();
//     counter = 0;
//     isStart = false;
//     notifyListeners();
//   }
//
//   String getFormattedTime() {
//     int hours = counter ~/ 3600;
//     int minutes = (counter % 3600) ~/ 60;
//     int seconds = counter % 60;
//     log("hours:$hours");
//     return hours != 0? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}':'${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _dispose();
//   }
//
//   Future<void> _dispose() async {
//     await engine.leaveChannel();
//     await engine.release();
//     stopTimer();
//   }
//
//   Future<bool> onWillPopNEw() {
//     return Future.value(false);
//   }
//
//   //start time count
//   startTimerNow() {
//     log("isStart :$isStart");
//     if (isStart) return;
//
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       counter++;
//       log("START :$counter");
//       notifyListeners();
//     });
//
//     isStart = true;
//     notifyListeners();
//   }
//
//   init(context) async {
//     await Future.delayed(Duration(milliseconds: 150));
//     dynamic data = ModalRoute.of(context)!.settings.arguments;
//
//     channelName = data["channelName"];
//     call = data["call"];
//     token = data["token"];
//     log("callcall; $call");
//     notifyListeners();
//     stream = FirebaseFirestore.instance
//         .collection(collectionName.calls)
//         .doc(userModel!.id.toString() == call!.callerId
//             ? call!.receiverId
//             : call!.callerId)
//         .collection("collectionCallHistory")
//         .doc(call!.timestamp.toString())
//         .snapshots();
//
//     initAgora(context);
//   }
//
//   //initialise agora
//   Future<void> initAgora(context) async {
//     await Future.delayed(Duration(milliseconds: 50));
//     //create the engine
//
//     engine = createAgoraRtcEngine();
//     if (appSettingModel!.agora != null) {
//       await engine.initialize(RtcEngineContext(
//         appId: appSettingModel!.agora!.appId,
//         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//       ));
//       notifyListeners();
//       log("INITIALIZE AGORA");
//       engine.registerEventHandler(
//         RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             debugPrint("local user dfdhfg ${connection.localUid} joined");
//             localUserJoined = true;
//
//             if (call!.callerId == userModel!.id.toString()) {
//               log("sgdfhsdfuih");
//               notifyListeners();
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.callerId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'type': 'OUTGOING',
//                 'isVideoCall': call!.isVideoCall,
//                 'id': call!.receiverId,
//                 'timestamp': call!.timestamp,
//                 'dp': call!.receiverPic,
//                 'isMuted': false,
//                 'receiverId': call!.receiverId,
//                 'isJoin': false,
//                 'status': 'calling',
//                 'started': null,
//                 'ended': null,
//                 'callerName': call!.receiverName,
//               }, SetOptions(merge: true));
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.receiverId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'type': 'INCOMING',
//                 'isVideoCall': call!.isVideoCall,
//                 'id': call!.callerId,
//                 'timestamp': call!.timestamp,
//                 'dp': call!.callerPic,
//                 'isMuted': false,
//                 'receiverId': call!.receiverId,
//                 'isJoin': true,
//                 'status': 'missedCall',
//                 'started': null,
//                 'ended': null,
//                 'callerName': call!.callerName,
//               }, SetOptions(merge: true));
//             }
//             //flutterLocalNotificationsPlugin!.cancelAll();
//             notifyListeners();
//           },
//           onError: (err, msg) {
//             log("ERROORRR : $err");
//             log("ERROORRR : $msg");
//           },
//           onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//             remoteUidValue = remoteUid;
//             startTimerNow();
//             notifyListeners();
//
//             debugPrint("remote user $remoteUidValue joined");
//             if (userModel!.id.toString() == call!.callerId) {
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.callerId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'started': DateTime.now(),
//                 'status': 'pickedUp',
//                 'isJoin': true,
//               }, SetOptions(merge: true));
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.receiverId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'started': DateTime.now(),
//                 'status': 'pickedUp',
//               }, SetOptions(merge: true));
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.callerId)
//                   .set({
//                 "audioCallMade": FieldValue.increment(1),
//               }, SetOptions(merge: true));
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.receiverId)
//                   .set({
//                 "audioCallReceived": FieldValue.increment(1),
//               }, SetOptions(merge: true));
//             }
//
//             notifyListeners();
//           },
//           onUserOffline: (RtcConnection connection, int remoteUid,
//               UserOfflineReasonType reason) {
//             debugPrint("remote user $remoteUid left channel");
//             remoteUid = 0;
//
//             final info = 'userOffline: $remoteUid';
//             _infoStrings.add(info);
//             _users.remove(remoteUid);
//             notifyListeners();
//
//             if (isAlreadyEnded == false) {
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.callerId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'status': 'ended',
//                 'ended': DateTime.now(),
//               }, SetOptions(merge: true));
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.receiverId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'status': 'ended',
//                 'ended': DateTime.now(),
//               }, SetOptions(merge: true));
//             }
//           },
//           onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//             debugPrint(
//                 '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//           },
//           onLeaveChannel: (connection, stats) {
//             _infoStrings.add('onLeaveChannel');
//             _users.clear();
//             _dispose();
//             notifyListeners();
//             if (isAlreadyEnded == false) {
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.callerId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'status': 'ended',
//                 'ended': DateTime.now(),
//               }, SetOptions(merge: true));
//               FirebaseFirestore.instance
//                   .collection(collectionName.calls)
//                   .doc(call!.receiverId)
//                   .collection(collectionName.collectionCallHistory)
//                   .doc(call!.timestamp.toString())
//                   .set({
//                 'status': 'ended',
//                 'ended': DateTime.now(),
//               }, SetOptions(merge: true));
//             }
//             route.pop(context);
//
//             notifyListeners();
//           },
//           onUserEnableVideo:(connection, remoteUid, enabled)async {
//             if(enabled){
//               engine.enableVideo();
//               await engine.startPreview();
//             }
//           },
//         ),
//       );
//       notifyListeners();
//       await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//
//       await engine.startPreview();
//
//       await engine.joinChannel(
//         token: call!.agoraToken!,
//         channelId: channelName!,
//         uid: 0,
//         options: const ChannelMediaOptions(),
//       );
//       notifyListeners();
//       notifyListeners();
//     }
//   }
//
//   //speaker mute - unMute
//   void onToggleSpeaker() {
//     isSpeaker = !isSpeaker;
//     notifyListeners();
//     engine.setEnableSpeakerphone(isSpeaker);
//   }
//
//   //firebase mute un Mute
//   void onToggleMute() {
//     muted = !muted;
//     notifyListeners();
//
//     engine.muteLocalAudioStream(muted);
//     FirebaseFirestore.instance
//         .collection(collectionName.calls)
//         .doc(userModel!.id.toString())
//         .collection(collectionName.collectionCallHistory)
//         .doc(call!.timestamp.toString())
//         .set({'isMuted': muted}, SetOptions(merge: true));
//   }
//
//   //bottom tool bar
//   Widget toolbar(
//     bool isShowSpeaker,
//     String? status,
//   ) {
//     if (role == ClientRoleType.clientRoleAudience) return Container();
//     /* return AudioToolBar(
//       status: status,
//       isShowSpeaker: isShowSpeaker,
//     );*/
//
//     return Container();
//   }
//
//   //end call and remove
//   Future<bool> endCall({required Call call}) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection(collectionName.calls)
//           .doc(call.callerId)
//           .collection(collectionName.calling)
//           .where("callerId", isEqualTo: call.callerId)
//           .limit(1)
//           .get()
//           .then((value) {
//         if (value.docs.isNotEmpty) {
//           FirebaseFirestore.instance
//               .collection(collectionName.calls)
//               .doc(call.callerId)
//               .collection("calling")
//               .doc(value.docs[0].id)
//               .delete();
//         }
//       });
//       await FirebaseFirestore.instance
//           .collection(collectionName.calls)
//           .doc(call.receiverId)
//           .collection(collectionName.calling)
//           .where("receiverId", isEqualTo: call.receiverId)
//           .limit(1)
//           .get()
//           .then((value) {
//         if (value.docs.isNotEmpty) {
//           FirebaseFirestore.instance
//               .collection(collectionName.calls)
//               .doc(call.receiverId)
//               .collection("calling")
//               .doc(value.docs[0].id)
//               .delete();
//         }
//       });
//       return true;
//     } catch (e) {
//       log("error : $e");
//       return false;
//     }
//   }
//
//   //end call
//   void onCallEnd(BuildContext context) async {
//     log("endCall1");
//     stopTimer();
//     _dispose();
//     DateTime now = DateTime.now();
//     if (remoteUId != null) {
//       await FirebaseFirestore.instance
//           .collection(collectionName.calls)
//           .doc(call!.callerId)
//           .collection(collectionName.collectionCallHistory)
//           .doc(call!.timestamp.toString())
//           .set({'status': 'ended', 'ended': now}, SetOptions(merge: true));
//       await FirebaseFirestore.instance
//           .collection(collectionName.calls)
//           .doc(call!.receiverId)
//           .collection(collectionName.collectionCallHistory)
//           .doc(call!.timestamp.toString())
//           .set({'status': 'ended', 'ended': now}, SetOptions(merge: true));
//     } else {
//       await endCall(call: call!).then((value) async {
//         FirebaseFirestore.instance
//             .collection(collectionName.calls)
//             .doc(call!.callerId)
//             .collection(collectionName.collectionCallHistory)
//             .doc(call!.timestamp.toString())
//             .set({
//           'type': 'outGoing',
//           'isVideoCall': call!.isVideoCall,
//           'id': call!.receiverId,
//           'timestamp': call!.timestamp,
//           'dp': call!.receiverPic,
//           'isMuted': false,
//           'receiverId': call!.receiverId,
//           'isJoin': false,
//           'started': null,
//           'callerName': call!.receiverName,
//           'status': 'ended',
//           "totalTalk": timer,
//           'ended': DateTime.now(),
//         }, SetOptions(merge: true));
//         FirebaseFirestore.instance
//             .collection(collectionName.calls)
//             .doc(call!.receiverId)
//             .collection(collectionName.collectionCallHistory)
//             .doc(call!.timestamp.toString())
//             .set({'type': 'inComing',
//           'isVideoCall': call!.isVideoCall,
//           'id': call!.callerId,
//           'timestamp': call!.timestamp,
//           'dp': call!.callerPic,
//           'isMuted': false,
//           'receiverId': call!.receiverId,
//           'isJoin': true,
//           'started': null,
//           'callerName': call!.callerName,
//           'status': 'ended',
//           "totalTalk": timer,
//           'ended': now
//         }, SetOptions(merge: true));
//       });
//     }
//     notifyListeners();
//     log("endCall");
//   }
//
//   chatTap(context){
//     endCall(call: call!);
//     route.pop(context);
//   }
//
//   videoTap()async{
//     call!.isVideoCall = !call!.isVideoCall!;
//
//     engine.enableVideo();
//     await engine.startPreview();
// log("SSS");
// if(call!.isVideoCall!){
//
// }
//     notifyListeners();
//
//     FirebaseFirestore.instance
//         .collection(collectionName.calls)
//         .doc(userModel!.id.toString())
//         .collection(collectionName.collectionCallHistory)
//         .doc(call!.timestamp.toString())
//         .set({'isVideoCall': call!.isVideoCall}, SetOptions(merge: true));
//     FirebaseFirestore.instance
//         .collection(collectionName.calls)
//         .doc(call!.callerId)
//         .collection(collectionName.collectionCallHistory)
//         .doc(call!.timestamp.toString())
//         .set({'isVideoCall': call!.isVideoCall}, SetOptions(merge: true));
//   }
//
//
//
// }
//
