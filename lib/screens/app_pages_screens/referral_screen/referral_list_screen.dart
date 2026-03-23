import '../../../config.dart';
import 'layouts/referral_list_layout.dart';
import 'layouts/referral_shimmer.dart';

class ReferralListScreen extends StatelessWidget {
  const ReferralListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80,
        leading: CommonArrow(
            arrow: rtl(context) ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
            onTap: () => route.pop(context)).paddingAll(Insets.i8),
        title: Text(
          language(context, translations!.referralList),
          style: appCss.dmDenseBold18
              .textColor(appColor(context).appTheme.darkText),
        ),
      ),
      body: Consumer<ReferralProvider>(
        builder: (context, value, child) {
          return StatefulWrapper(
            onInit: () =>
                Future.delayed(Duration.zero, () => value.onReady(context)),
            child: value.isLoading
                ? ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: Insets.i15),
                    itemBuilder: (context, index) => const ReferralShimmer(),
                  )
                : value.referralList.isEmpty
                    ? const CommonEmpty()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // List of Referrals
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.referralList.length,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Insets.i15),
                              itemBuilder: (context, index) {
                                final data = value.referralList[index];
                                return ReferralListLayout(
                                  name: data.referred?.name ?? "User",
                                  email: data.referred?.email ?? "No Email",
                                  status: data.status ?? "Pending",
                                  profileImage: (data.referred?.media != null &&
                                          data.referred!.media!.isNotEmpty)
                                      ? data.referred!.media!.first.originalUrl
                                      : null,
                                );
                              },
                            ),
                          ],
                        ).paddingDirectional(vertical: Sizes.s15),
                      ),
          );
        },
      ),
    );
  }
}
