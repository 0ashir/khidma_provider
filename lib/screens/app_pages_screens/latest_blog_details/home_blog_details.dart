import 'package:intl/intl.dart';

import '../../../config.dart';
import 'home_blog_details_layout.dart';

class HomeLatestBlogDetailsScreen extends StatelessWidget {
  const HomeLatestBlogDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LatestBLogDetailsProvider>(
        builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(const Duration(milliseconds: 150),
              () => value.onHomeReady(context)),
          child: Scaffold(
              appBar: AppBarCommon(
                  title: translations!.latestBlog,
                  onTap: () {
                    value.onHomeBack(context);
                  }),
              body: SingleChildScrollView(
                  child: Column(children: [
                SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: value.data1 != null
                            ? const HomeBlogDetailsLayout()
                            : Container())
                    .decorated(
                        color: appColor(context).appTheme.whiteBg,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              spreadRadius: 2,
                              color: appColor(context)
                                  .appTheme
                                  .darkText
                                  .withValues(alpha: 0.06))
                        ],
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                        border: Border.all(
                            color: appColor(context).appTheme.stroke))
                    .padding(vertical: Insets.i15, horizontal: Insets.i20)
              ]))));
    });
  }
}
