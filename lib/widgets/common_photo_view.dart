import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../config.dart';

class CommonPhotoView extends StatefulWidget {
  final String? image;

  const CommonPhotoView({super.key, this.image});

  @override
  State<CommonPhotoView> createState() => _CommonPhotoViewState();
}

class _CommonPhotoViewState extends State<CommonPhotoView> {
  bool isLoading = false;

  downloadImage(context) async {
    log("IMAGE URL :${widget.image}");
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      late final Map<Permission, PermissionStatus> status;

      if (Platform.isAndroid) {
        if (androidInfo.version.sdkInt <= 32) {
          status = await [Permission.storage].request();
        } else {
          status = await [Permission.photos].request();
        }
      } else {
        status = await [Permission.photosAddOnly].request();
      }

      var allAccept = true;
      status.forEach((permission, status) {
        if (status != PermissionStatus.granted) {
          allAccept = false;
        }
      });

      if (allAccept) {
        isLoading = true;
        showLoading(context);
        setState(() async {
          var response = await Dio().get(widget.image!,
              options: Options(responseType: ResponseType.bytes));
          final result = await SaverGallery.saveImage(
            Uint8List.fromList(response.data),
            quality: 60,
            fileName: "Fixit:${DateTime.now().millisecond}",
            androidRelativePath: "Pictures/appName/xx",
            skipIfExists: false,
          );
          log("result:$result");
          if (result.isSuccess == true) {
            showSuccessToast(context, "Image Downloaded Successfully");
          }
        });
        isLoading = false;
        hideLoading(context);
        setState(() {});

        setState(() {});
      } else {
        isLoading = false;
        hideLoading(context);
        snackBarMessengers(context,
            color: appColor(context).appTheme.primary,
            message: "Image Downloaded Successfully");
        setState(() {});
      }
    } catch (e) {
      hideLoading(context);
      log("EEEE DOWNLOAD :$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    log("widget.image!:${widget.image!}");
    return Scaffold(
      backgroundColor: appColor(context).appTheme.darkText,
      appBar: AppBar(
        backgroundColor: appColor(context).appTheme.darkText,
        actions: [
          Icon(Icons.download_outlined,
                  color: appColor(context).appTheme.whiteBg)
              .marginSymmetric(horizontal: Insets.i20)
              .inkWell(onTap: () => downloadImage(context))
        ],
      ),
      body: LoadingComponent(
        child: Stack(
          children: [
            PhotoView(imageProvider: NetworkImage(widget.image!)),
          ],
        ),
      ),
    );
  }
}
