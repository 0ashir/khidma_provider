import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CustomPageDetailsScreen extends StatefulWidget {
  final String title;
  final String pageKey;
  final UserType? requestedUserType;

  const CustomPageDetailsScreen({
    Key? key,
    required this.title,
    required this.pageKey,
    this.requestedUserType,
  }) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) =>
            FetchCustomPageDetailsCubit(CustomPageRepository()),
        child: CustomPageDetailsScreen(
          title: arguments['title'] ?? '',
          pageKey: arguments['pageKey'] ?? '',
          requestedUserType: arguments['userType'] as UserType?,
        ),
      ),
    );
  }

  @override
  State<CustomPageDetailsScreen> createState() =>
      _CustomPageDetailsScreenState();
}

class _CustomPageDetailsScreenState extends State<CustomPageDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<FetchCustomPageDetailsCubit>().fetchCustomPageDetails(
        pageKey: widget.pageKey,
        requestedUserType: widget.requestedUserType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedSafeArea(
      child: InterstitialAdWidget(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondaryColor,
          appBar: UiUtils.getSimpleAppBar(
            statusBarColor: context.colorScheme.secondaryColor,
            context: context,
            title: widget.title.translate(context: context),
            elevation: 1,
          ),
          bottomNavigationBar: const BannerAdWidget(),
          body:
              BlocBuilder<
                FetchCustomPageDetailsCubit,
                FetchCustomPageDetailsState
              >(
                builder: (context, state) {
                  if (state is FetchCustomPageDetailsInProgress) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: Column(
                        children: List.generate(
                          15,
                          (index) => const CustomShimmerContainer(
                            height: 15,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 10),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is FetchCustomPageDetailsFailure) {
                    return ErrorContainer(
                      errorMessage: state.errorMessage.translate(
                        context: context,
                      ),
                      onTapRetry: () {
                        context
                            .read<FetchCustomPageDetailsCubit>()
                            .fetchCustomPageDetails(pageKey: widget.pageKey);
                      },
                    );
                  }

                  if (state is FetchCustomPageDetailsSuccess) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: HtmlWidget(
                        state.content.isEmpty
                            ? "noDataFound".translate(context: context)
                            : state.content,
                        textStyle: TextStyle(
                          color: context.colorScheme.blackColor,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
        ),
      ),
    );
  }
}
