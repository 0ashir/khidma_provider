import 'dart:developer';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixit_provider/screens/app_pages_screens/pick_up_call/pick_up_body.dart';

import '../../../config.dart';
import '../../../model/call_model.dart';

class PickupLayout extends StatefulWidget {
  final Widget scaffold;

  const PickupLayout({
    super.key,
    required this.scaffold,
  });

  @override
  State<PickupLayout> createState() => _PickupLayoutState();
}

class _PickupLayoutState extends State<PickupLayout>
    with SingleTickerProviderStateMixin {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  // ClientRoleType role = ClientRoleType.clientRoleBroadcaster;
  Animation? sizeAnimation;

  fetchCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCamera();
    Future.delayed(Durations.medium2).then(
      (value) {
        if (cameras.isNotEmpty) {
          if (userModel != null) {
            FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(userModel!.id.toString())
                .collection(collectionName.calling)
                .limit(1)
                .snapshots()
                .listen((event) {
              log("event.docs ;${event.docs.length}");
              if (event.docs.isNotEmpty) {
                cameraController = CameraController(
                  cameras.length == 1 ? cameras[0] : cameras[1],
                  ResolutionPreset.max,
                  imageFormatGroup: ImageFormatGroup.yuv420,
                );
                log("cameraController : $cameraController");
                cameraController!.initialize().then((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {});
                }).catchError((Object e) {
                  if (e is CameraException) {
                    switch (e.code) {
                      case 'CameraAccessDenied':
                        // Handle access errors here.
                        break;
                      default:
                        // Handle other errors here.
                        break;
                    }
                  }
                });
              }
            });
          }
        }
      },
    );
    log("cameras :${cameras.length}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName.calls)
          .doc(userModel?.id.toString())
          .collection(collectionName.calling)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          Call call = Call.fromMap(snapshot.data!.docs[0].data());
          /*   if (!call.hasDialled!) {

                  return PickupBody(
                    call: call,
                    cameraController: cameraController,
                    imageUrl: snapshot.data!.docs[0].data()["callerPic"]
                  );
                }else{
                  return widget.scaffold;
                }*/
          if (call.hasDialled != null && !call.hasDialled!) {
            return PickupBody(
                call: call,
                cameraController: cameraController,
                imageUrl: snapshot.data!.docs[0].data()["callerPic"]);
          } else {
            return widget.scaffold;
          }
        }
        return widget.scaffold;
      },
    );
    widget.scaffold;
  }
}
