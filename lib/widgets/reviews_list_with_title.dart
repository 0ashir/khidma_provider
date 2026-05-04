import '../config.dart';

class ReviewListWithTitle extends StatelessWidget {
  final List<Reviews>? reviews;

  const ReviewListWithTitle({super.key, this.reviews});

  @override
  Widget build(BuildContext context) {
    /* log("message =-=-=-=-=-=-= ${reviews?.first.consumer?.media?.first.originalUrl}"); */
    return Column(children: [
      HeadingRowCommon(
          isViewAllShow: reviews!.length >= 10,
          title: translations!.review,
          onTap: () {
            Provider.of<ServiceReviewProvider>(context, listen: false)
                .getMyReview(context);
            route.pushNamed(context, routeName.serviceReview);
          }).paddingOnly(bottom: Insets.i12),
      ...reviews!.asMap().entries.map((e) =>
          ServiceReviewLayout(data: e.value, index: e.key, list: reviews!))
    ]);
  }
}
