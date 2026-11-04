import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomPagesScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const CustomPagesScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  State<CustomPagesScreen> createState() => _CustomPagesScreenState();
}

class _CustomPagesScreenState extends State<CustomPagesScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<FetchCustomPagesCubit>().fetchCustomPages();
    });
  }

  Widget _buildListTile({required String title, required VoidCallback onTap}) {
    return Material(
      color: context.colorScheme.secondaryColor,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        title: CustomText(
          title,
          color: context.colorScheme.blackColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: context.colorScheme.lightGreyColor,
          size: 24,
        ),
      ),
    );
  }

  Widget backgroundContainer({required final Widget child}) => CustomContainer(
    color: context.colorScheme.secondaryColor,
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: 'customPagesLbl'.translate(context: context),
        elevation: 1,
        statusBarColor: context.colorScheme.secondaryColor,
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsetsDirectional.only(bottom: 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            // Fixed System Pages
            backgroundContainer(
              child: Column(
                children: [
                  _buildListTile(
                    title: "privacyPolicyLbl".translate(context: context),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.customPageDetailsRoute,
                        arguments: {
                          "title": "privacyPolicyLbl",
                          "pageKey": "privacy_policy",
                        },
                      );
                    },
                  ),
                  _buildListTile(
                    title: "termsConditionLbl".translate(context: context),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.customPageDetailsRoute,
                        arguments: {
                          "title": "termsConditionLbl",
                          "pageKey": "terms_conditions",
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Dynamic Pages (Other Pages)
            BlocBuilder<FetchCustomPagesCubit, FetchCustomPagesState>(
              builder: (context, state) {
                if (state is FetchCustomPagesInProgress) {
                  return Column(
                    children: List.generate(
                      5,
                      (index) => const CustomShimmerContainer(
                        height: 50,
                        margin: EdgeInsets.only(bottom: 10, top: 15),
                      ),
                    ),
                  );
                }

                if (state is FetchCustomPagesFailure) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ErrorContainer(
                      errorMessage: state.errorMessage.translate(
                        context: context,
                      ),
                      onTapRetry: () {
                        context
                            .read<FetchCustomPagesCubit>()
                            .fetchCustomPages();
                      },
                    ),
                  );
                }

                if (state is FetchCustomPagesSuccess) {
                  if (state.customPages.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: backgroundContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 15,
                            ).copyWith(bottom: 10, top: 8),
                            child: CustomText(
                              'otherPages'.translate(context: context),
                              color: context.colorScheme.lightGreyColor,
                              fontSize: 14,
                            ),
                          ),
                          ...state.customPages.map(
                            (page) => _buildListTile(
                              title: page.translatedTitle,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.customPageDetailsRoute,
                                  arguments: {
                                    "title": page.translatedTitle,
                                    "pageKey": page.slug,
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
