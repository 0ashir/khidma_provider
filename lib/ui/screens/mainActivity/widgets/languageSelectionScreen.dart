import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final String title;

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => LanguageSelectionScreen(title: args["title"]),
    );
  }

  const LanguageSelectionScreen({super.key, required this.title});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  AppLanguage? selectedLanguage;
  bool isLoadingLanguageData = false;

  @override
  void initState() {
    super.initState();

    // Fetch language list
    context.read<LanguageListCubit>().getLanguageList();

    selectedLanguage = HiveRepository.getCurrentLanguage();
  }

  Widget getItem({
    required AppLanguage language,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return CustomCheckIconTextButton(
      title: language.languageName.translate(context: context),
      isSelected: isSelected,
      onTap: onTap ?? () {},
    );
  }

  void _selectLanguage(AppLanguage language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  void _confirmSelection() {
    if (selectedLanguage != null) {
      setState(() {
        isLoadingLanguageData = true;
      });
      context.read<LanguageDataCubit>().getLanguageData(
        languageData: selectedLanguage!,
      );
      // BlocListener handles popping and storing to Hive
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: widget.title.translate(context: context),
        statusBarColor: Theme.of(context).colorScheme.secondaryColor,
      ),
      body: BlocListener<LanguageDataCubit, LanguageDataState>(
        listener: (_, state) async {
          if (state is GetLanguageDataSuccess) {
            await HiveRepository.storeLanguage(
              data: state.jsonData,
              lang: state.currentLanguage,
            );
            final futures = <Future>[
              context.read<GetProviderDetailsCubit>().getProviderDetails(),
              context.read<FetchHomeDataCubit>().getHomeData(),
              context.read<FetchBookingsCubit>().fetchBookings(),
              context.read<FetchServiceCategoryCubit>().fetchCategories(),
            ];

            Future.wait(futures);

            Navigator.pop(context);
          } else if (state is GetLanguageDataError) {
            setState(() {
              isLoadingLanguageData = false;
            });
            // Show error message
            UiUtils.showMessage(context, state.error, ToastificationType.error);
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<LanguageListCubit, LanguageListState>(
                    builder: (context, state) {
                      if (state is GetLanguageListInProgress) {
                        return ShimmerLoadingContainer(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: 5, // Show 5 shimmer items
                            itemBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CustomShimmerContainer(
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is GetLanguageListError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                'failedToLoadLanguages'.translate(
                                  context: context,
                                ),
                                color: context.colorScheme.blackColor,
                              ),
                              const SizedBox(height: 10),
                              CustomRoundedButton(
                                onTap: () {
                                  context
                                      .read<LanguageListCubit>()
                                      .getLanguageList();
                                },
                                buttonTitle: 'retry'.translate(
                                  context: context,
                                ),
                                widthPercentage: 0.5,
                                showBorder: false,
                                backgroundColor:
                                    context.colorScheme.accentColor,
                              ),
                            ],
                          ),
                        );
                      } else if (state is GetLanguageListSuccess) {
                        if (state.languages.isEmpty) {
                          return Center(
                            child: CustomText(
                              'noLanguagesAvailable'.translate(
                                context: context,
                              ),
                              color: context.colorScheme.blackColor,
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: state.languages.length,
                          itemBuilder: (context, index) {
                            final language = state.languages[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getItem(
                                language: language,
                                isSelected: selectedLanguage?.id == language.id,
                                onTap: () => _selectLanguage(language),
                              ),
                            );
                          },
                        );
                      }

                      return ShimmerLoadingContainer(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount:
                              3, // Show 3 shimmer items for default state
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CustomShimmerContainer(
                                height: 60,
                                margin: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                CloseAndConfirmButton(
                  showCloseBorder: true,
                  addBottomPadding: false,
                  closeButtonBackgroundColor: Colors.transparent,
                  closeButtonPressed: () => Navigator.pop(context),
                  confirmButtonPressed: _confirmSelection,
                ),
              ],
            ),
            // Progress indicator overlay during GetLanguageDataSuccess
            if (isLoadingLanguageData)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.lightPrimaryColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
