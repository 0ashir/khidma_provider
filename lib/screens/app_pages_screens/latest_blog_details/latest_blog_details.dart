
import 'dart:developer';

import '../../../config.dart';
import 'blog_detail_shimmer/blog_detail_shimmer.dart';

class LatestBlogDetailsScreen extends StatelessWidget {
  const LatestBlogDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LatestBLogDetailsProvider>(
        builder: (context, value, child) {
          log("value.data:${value.data}");
          return StatefulWrapper(
              onInit: () => Future.delayed(
                  const Duration(milliseconds: 150), () => value.onReady(context)),
              child: PopScope(
                canPop: true,
                onPopInvoked: (didPop) {
                  value.onBack(context,false );
                  if (didPop) return;
                },
                child:  Scaffold(
                    appBar: AppBarCommon(
                        title: translations!.latestBlog,
                        onTap: () => value.onBack(context,true)),
                    body:value.isBlogList == true
                        ?  const BlogDetailShimmer()
                        : SingleChildScrollView(
                        child: Column(children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: value.data != null
                                  ? const BlogDetailsLayout()
                                  : Container())
                              .decorated(
                              color: appColor(context).appTheme.whiteBg,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                    color: appColor(context).appTheme
                                        .darkText
                                        .withValues(alpha: 0.06))
                              ],
                              borderRadius: BorderRadius.circular(AppRadius.r8),
                              border:
                              Border.all(color: appColor(context).appTheme.stroke))
                              .padding(vertical: Insets.i15, horizontal: Insets.i20)
                        ]))),
              ));
        });
  }
}
