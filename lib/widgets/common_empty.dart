import '../config.dart';

class CommonEmpty extends StatelessWidget {
  const CommonEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: Insets.i50), // 👈 move downward
        child: EmptyLayout(
          title: translations!.noDataFound,
          isButton: false,
          subtitle: translations!.noDataFoundDesc,
          widget: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              eImageAssets.noSearch,
              height: Sizes.s300,
              width: Sizes.s88,
            ).paddingOnly(bottom: Insets.i15, top: Insets.i25),
          ),
        ),
      ),
    );
  }
}
