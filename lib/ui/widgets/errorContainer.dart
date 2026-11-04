import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/cubits/logoutCubit.dart';

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    required this.errorMessage,
    final Key? key,
    this.errorMessageColor,
    this.buttonName,
    this.errorMessageFontSize,
    this.onTapRetry,
    this.showErrorImage,
    this.retryButtonBackgroundColor,
    this.retryButtonTextColor,
    this.subErrorMessage,
    this.showRetryButton = true,
  }) : super(key: key);
  final String errorMessage;
  final String? buttonName;
  final bool? showErrorImage;
  final Color? errorMessageColor;
  final double? errorMessageFontSize;
  final Function? onTapRetry;
  final bool showRetryButton;
  final Color? retryButtonBackgroundColor;
  final Color? retryButtonTextColor;
  final String? subErrorMessage;

  @override
  Widget build(final BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage == "noInternetFound".translate(context: context))
            SizedBox(
              height: context.screenHeight * 0.35,
              child: const CustomSvgPicture(svgImage: AppAssets.noConnection),
            )
          else if (showErrorImage == true)
            SizedBox(
              height: context.screenHeight * 0.35,
              child: const CustomSvgPicture(
                svgImage: AppAssets.somethingWentWrong,
              ),
            )
          else
            const SizedBox.shrink(),
          SizedBox(height: context.screenHeight * 0.025),
          CustomText(
            (errorMessage == "noInternetFound"
                    ? "noInternetFound"
                    : errorMessage == "somethingWentWrong"
                    ? "somethingWentWrongTitle"
                    : errorMessage)
                .translate(context: context),
            textAlign: TextAlign.center,
            color: context.colorScheme.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: CustomText(
              subErrorMessage?.translate(context: context) ?? '',
              textAlign: TextAlign.center,
              color: context.colorScheme.blackColor,
              fontSize: errorMessageFontSize ?? 14,
            ),
          ),
          const SizedBox(height: 15),
          if (showRetryButton)
            CustomRoundedButton(
              height: 40,
              widthPercentage: 0.6,
              backgroundColor:
                  retryButtonBackgroundColor ?? context.colorScheme.accentColor,
              onTap: () {
                if (UiUtils.authenticationError) {
                  //logout and redirect to login screen
                  context.read<LogoutCubit>().logout(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.loginScreenRoute,
                    (Route<dynamic> route) => false,
                  );
                  UiUtils.authenticationError = false;
                } else {
                  onTapRetry?.call();
                }
              },
              titleColor: retryButtonTextColor ?? AppColors.whiteColors,
              buttonTitle: UiUtils.authenticationError
                  ? 'goToLogin'.translate(context: context)
                  : (buttonName ?? 'retry').translate(context: context),
              showBorder: false,
            ),
        ],
      ),
    ),
  );
}
