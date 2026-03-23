import '../../../config.dart';
import 'layouts/provider_top_layout.dart';

class ProviderDetailsScreen extends StatelessWidget {
  final String? id;

  const ProviderDetailsScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderDetailsProvider>(builder: (context, value, child) {
      return Scaffold(
          appBar: AppBar(
            leadingWidth: 80,
            title: Text(language(context, translations!.providerDetails),
                style: appCss.dmDenseBold18
                    .textColor(appColor(context).appTheme.darkText)),
            centerTitle: true,
            leading: CommonArrow(
                arrow: eSvgAssets.arrowLeft,
                onTap: () => route.pop(context)).paddingAll(Insets.i8),
            /* actions: [
                CommonArrow(
                    arrow: eSvgAssets.chat,
                    onTap: () => route.pushNamed(context, routeName.chat, arg: {
                          "image": provider!.media != null &&
                                  provider!.media!.isNotEmpty
                              ? provider!.media![0].originalUrl!
                              : "",
                          "name": provider!.name,
                          "role": "provider",
                          "userId": provider!.id,
                          "token": provider!.fcmToken,
                          "phone": provider!.phone,
                          "code": provider!.code
                        }).then((e) {
                          final chat = Provider.of<ChatHistoryProvider>(context,
                              listen: false);
                          chat.onReady(context);
                        })).marginSymmetric(horizontal: Insets.i20)
              ]*/
          ),
          body: ListView(children: const [ProviderTopLayout()])
              .paddingAll(Insets.i20));
    });
  }
}
