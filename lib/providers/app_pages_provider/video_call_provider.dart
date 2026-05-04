// import 'dart:async';
// import 'dart:developer';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
//
// import '../../config.dart';
// import '../../model/call_model.dart';
// import '../common_providers/notification_provider.dart';
//
//
// class VideoCallProvider extends ChangeNotifier {
//   String? channelName;
//   Call? call;
//   bool localUserJoined = false, isFullScreen = false;
//   bool isSpeaker = true, switchCamera = false, isCameraShow = true;
//    late RtcEngine engine;
//   Stream<int>? timerStream;
//   int? remoteUId;
//   List users = <int>[];
//   final infoStrings = <String>[];
//
//   // ignore: cancel_subscriptions
//   StreamSubscription<int>? timerSubscription;
//   bool muted = false;
//   bool isAlreadyEndedCall = false;
//   String nameList = "";
//   ClientRoleType? role;
//   dynamic userData;
//   Stream<DocumentSnapshot>? stream;
//
//   int? remoteUidValue;
//   String? token;
//   bool isStart = false;
//
//   // ignore: close_sinks
//   StreamController<int>? streamController;
//   String hoursStr = '00';
//   String minutesStr = '00';
//   String secondsStr = '00';
//   int counter = 0;
//   Timer? timer;
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
//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
//   Future<void> _dispose() async {
//     await engine!.leaveChannel();
//     await engine!.release();
//     stopTimer();
//   }
//
//   init(context) async {
//     await Future.delayed(Duration(milliseconds: 150));
//     dynamic data = ModalRoute.of(context)!.settings.arguments;
//
//     channelName = data["channelName"];
//     call = data["call"];
//     token = data["token"];
//     log("callcall; ${call}");
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
//     await engine!.initialize(RtcEngineContext(
//       appId: appSettingModel!.agora!.appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//     notifyListeners();
//     engine!.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ;;;${connection.localUid} joined");
//           localUserJoined = true;
//           notifyListeners();
//
//           final info = 'onJoinChannel: $channel, uid: ${connection.localUid}';
//           infoStrings.add(info);
//           log("info :info");
//
//           if (call!.callerId == userModel!.id.toString()) {
//             notifyListeners();
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.callerId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'type': 'outGoing',
//               'isVideoCall': call!.isVideoCall,
//               'id': call!.receiverId,
//               'timestamp': call!.timestamp,
//               'dp': call!.receiverPic,
//               'isMuted': false,
//               'receiverId': call!.receiverId,
//               'isJoin': false,
//               'status': 'calling',
//               'started': null,
//               'ended': null,
//               'callerName': call!.callerName,
//             }, SetOptions(merge: true));
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.receiverId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'type': 'inComing',
//               'isVideoCall': call!.isVideoCall,
//               'id': call!.callerId,
//               'timestamp': call!.timestamp,
//               'dp': call!.callerPic,
//               'isMuted': false,
//               'receiverId': call!.receiverId,
//               'isJoin': true,
//               'status': 'missedCall',
//               'started': null,
//               'ended': null,
//               'callerName': call!.callerName,
//             }, SetOptions(merge: true));
//           }
//           WakelockPlus.enable();
//           //flutterLocalNotificationsPlugin!.cancelAll();
//           notifyListeners();
//         },
//         onUserJoined:
//             (RtcConnection connection, int remoteUserId, int elapsed) {
//           debugPrint("remote user $remoteUserId joined");
//           remoteUId = remoteUserId;
//           notifyListeners();
//           startTimerNow();
//           final info = 'userJoined: $remoteUserId';
//           infoStrings.add(info);
//           if (users.isEmpty) {
//             users = [remoteUserId];
//           } else {
//             users.add(remoteUserId);
//           }
//           notifyListeners();
//           debugPrint("remote user $remoteUserId joined");
//
//           if (userModel!.id.toString() == call!.callerId) {
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.callerId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'started': DateTime.now(),
//               'status': 'pickedUp',
//               'isJoin': true,
//             }, SetOptions(merge: true));
//
//             FirebaseFirestore.instance
//                 .collection("calls")
//                 .doc(call!.callerId)
//                 .set({
//               "videoCallMade": FieldValue.increment(1),
//             }, SetOptions(merge: true));
//
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.receiverId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'started': DateTime.now(),
//               'status': 'pickedUp',
//             }, SetOptions(merge: true));
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.receiverId)
//                 .set({
//               "videoCallReceived": FieldValue.increment(1),
//             }, SetOptions(merge: true));
//           }
//           WakelockPlus.enable();
//           notifyListeners();
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           remoteUid = 0;
//           users.remove(remoteUid);
//           notifyListeners();
//           if (isAlreadyEndedCall == false) {
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.callerId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'status': 'ended',
//               'ended': DateTime.now(),
//             }, SetOptions(merge: true));
//
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.receiverId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'status': 'ended',
//               'ended': DateTime.now(),
//             }, SetOptions(merge: true));
//           }
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//         onError: (err, msg) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: $err, token: $msg)');
//         },
//         onFirstRemoteAudioFrame: (connection, userId, elapsed) {
//           final info = 'firstRemoteVideo: $userId';
//           infoStrings.add(info);
//           notifyListeners();
//         },
//         onLeaveChannel: (connection, stats) {
//           remoteUId = null;
//           infoStrings.add('onLeaveChannel');
//           users.clear();
//
//           _dispose();
//           notifyListeners();
//           if (isAlreadyEndedCall == false) {
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.callerId)
//                 .collection(collectionName.collectionCallHistory)
//                 .add({});
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.callerId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'status': 'ended',
//               'ended': DateTime.now(),
//             }, SetOptions(merge: true));
//
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call!.receiverId)
//                 .collection(collectionName.collectionCallHistory)
//                 .doc(call!.timestamp.toString())
//                 .set({
//               'status': 'ended',
//               'ended': DateTime.now(),
//             }, SetOptions(merge: true));
//           }
//           WakelockPlus.disable();
//           route.pop(context);
//           notifyListeners();
//         },
//       ),
//     );
//     notifyListeners();
//     await engine!.enableWebSdkInteroperability(true);
//     await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await engine!.enableVideo();
//     await engine!.startPreview();
//
//     await engine!.joinChannel(
//       token: call!.agoraToken!,
//       channelId: channelName!,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//     notifyListeners();
//
//     notifyListeners();
//   }
//
//   //on speaker off on
//   void onToggleSpeaker() {
//     isSpeaker = !isSpeaker;
//     notifyListeners();
//     engine!.setEnableSpeakerphone(isSpeaker);
//   }
//
//   //mute - unMute toggle
//   void onToggleMute() {
//     muted = !muted;
//     notifyListeners();
//     engine!.muteLocalAudioStream(muted);
//     FirebaseFirestore.instance
//         .collection(collectionName.calls)
//         .doc(userModel!.id.toString())
//         .collection(collectionName.collectionCallHistory)
//         .doc(call!.timestamp.toString())
//         .set({'isMuted': muted}, SetOptions(merge: true));
//   }
//
//
//   chatTap(context){
//     endCall(call: call!);
//     route.pop(context);
//   }
//
//   videoTap(){
//     call!.isVideoCall = !call!.isVideoCall!;
//
//     engine!.enableVideo();
//     notifyListeners();
//
//   }
//
//
//   //switch camera
//   Future<void> onSwitchCamera() async {
//     engine!.switchCamera();
//
//     notifyListeners();
//   }
//
//   //end call delete after end call
//   Future<bool> endCall({required Call call}) async {
//
//     try {
//
//         await FirebaseFirestore.instance
//             .collection(collectionName.calls)
//             .doc(call.callerId)
//             .collection(collectionName.calling)
//             .where("callerId", isEqualTo: call.callerId)
//             .limit(1)
//             .get()
//             .then((value) {
//           if (value.docs.isNotEmpty) {
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call.callerId)
//                 .collection(collectionName.calling)
//                 .doc(value.docs[0].id)
//                 .delete();
//           }
//         });
//         await FirebaseFirestore.instance
//             .collection(collectionName.calls)
//             .doc(call.receiverId)
//             .collection(collectionName.calling)
//             .where("receiverId", isEqualTo: call.receiverId)
//             .limit(1)
//             .get()
//             .then((value) {
//           if (value.docs.isNotEmpty) {
//             FirebaseFirestore.instance
//                 .collection(collectionName.calls)
//                 .doc(call.receiverId)
//                 .collection(collectionName.calling)
//                 .doc(value.docs[0].id)
//                 .delete();
//           }
//         });
//
//       return true;
//     } catch (e) {
//       log("error : $e");
//       return false;
//     }
//   }
//
//   onEndCall(context){
//     isAlreadyEndedCall =
//     false;
//     notifyListeners();
//     onCallEnd(context);
//   }
//
//
//   //on call end api
//   void onCallEnd(BuildContext context) async {
//     await endCall(call: call!).then((value) async {
//       log("value : $value");
//       DateTime now = DateTime.now();
//
//         FirebaseFirestore.instance
//             .collection(collectionName.calls)
//             .doc(call!.callerId)
//             .collection(collectionName.collectionCallHistory)
//             .doc(call!.timestamp.toString())
//             .set({'status': 'ended', 'ended': now}, SetOptions(merge: true));
//         FirebaseFirestore.instance
//             .collection(collectionName.calls)
//             .doc(call!.receiverId)
//             .collection(collectionName.collectionCallHistory)
//             .doc(call!.timestamp.toString())
//             .set({'status': 'ended', 'ended': now},
//             SetOptions(merge: true)).then((value) {
//           remoteUId = null;
//           channelName = "";
//           //  role = null;
//           notifyListeners();
//         });
//
//       remoteUId = null;
//       channelName = "";
//       role = null;
//       notifyListeners();
//     });
//
//     notifyListeners();
//     _dispose();
//
//     log("endCall");
//     WakelockPlus.disable();
//
//   }
//
// }
