import 'dart:developer';

import '../../../config.dart';

class LatestBlogViewAll extends StatefulWidget {
  const LatestBlogViewAll({super.key});

  @override
  State<LatestBlogViewAll> createState() => _LatestBlogViewAllState();
}

class _LatestBlogViewAllState extends State<LatestBlogViewAll> {


  @override
  Widget build(BuildContext context) {
    final data = Provider.of<CommonApiProvider>(context, listen: true);
    final value = Provider.of<DashboardProvider>(context, listen: true);

    return StatefulWrapper(
      onInit: () {
        data.getBlog();
        log("value.blogList${blogList}");
      },
      child: Scaffold(
          appBar: AppBarCommon(title: translations!.latestBlog),
          body: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                          children: blogList
                              .asMap()
                              .entries
                              .map((e) => LatestBlogLayout(
                                      data: e.value, rPadding: 0, isView: true)
                                  .width(MediaQuery.of(context).size.width))
                              .toList())
                      .paddingSymmetric(horizontal: Insets.i20))
              /* FutureBuilder(
                  future: fetchData(context),
                  initialData: value.blogList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data!.isEmpty) {
                      return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                              5, (index) => const BlogShimmerLayout()).toList());
                    } else {
                      if (snapshot.error != null) {
                        return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                                    5, (index) => const BlogShimmerLayout())
                                .toList());
                      } else {

                      }
                    }
                  })*/
              )),
    );
  }
}
