
import '../config.dart';

class RowText extends StatelessWidget {
  const RowText({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CommonSkeleton(height: Sizes.s18, width: Sizes.s155),
      HSpace(Sizes.s3),
      CommonSkeleton(height: Sizes.s18, width: Sizes.s45)
    ]);
  }
}
