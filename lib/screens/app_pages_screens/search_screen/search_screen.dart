import '../../../config.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<SearchProvider, UserDataApiProvider>(
        builder: (context1, value, userApi, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 20), () => value.onReady()),
          child: Scaffold(
              appBar: AppBarCommon(title: translations!.search),
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchTextFieldCommon(
                        suffixIcon: value.searchCtrl.text.isEmpty
                            ? SizedBox()
                            : Icon(Icons.close).inkWell(onTap: () {
                                value.searchClear();
                              }),
                        focusNode: value.searchFocus,
                        controller: value.searchCtrl,
                        onChanged: (v) {
                          if (v.length > 2) {
                            value.searchService(context);
                          }
                        },
                        onFieldSubmitted: (v) => value.searchService(context),
                      ),
                      const VSpace(Sizes.s25),
                      Text(language(context, translations!.recentSearch),
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.lightText)),
                      const VSpace(Sizes.s15),
                      value.searchList.isNotEmpty
                          ? Column(
                              children: value.searchList
                                  .asMap()
                                  .entries
                                  .map((e) => FeaturedServicesLayout(
                                        data: e.value,
                                        onToggle: (val) =>
                                            userApi.updateActiveStatusService(
                                                context,
                                                e.value.id,
                                                val,
                                                e.key),
                                        onTap: () => value.onTapFeatures(
                                            context, e.value, e.key),
                                      ))
                                  .toList())
                          : value.recentSearchList.isNotEmpty
                              ? Column(
                                  children: value.recentSearchList
                                      .asMap()
                                      .entries
                                      .map((e) => FeaturedServicesLayout(
                                            data: e.value,
                                            onToggle: (val) => userApi
                                                .updateActiveStatusService(
                                                    context,
                                                    e.value.id,
                                                    val,
                                                    e.key),
                                            onTap: () => value.onTapFeatures(
                                                context, e.value, e.key),
                                          ))
                                      .toList())
                              : const CommonEmpty(),
                    ]).paddingSymmetric(horizontal: Insets.i20),
              )));
    });
  }
}
