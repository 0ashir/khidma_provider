import '../../../../config.dart';
import '../../../../widgets/progress_bar_common.dart';

class ProgressBarLayout extends StatelessWidget {
  final int? data;
  final int? index;
  final List? list;

  const ProgressBarLayout({super.key, this.data, this.list, this.index});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
          "${(index! == 0 ? 5 : index == 1 ? 4 : index == 2 ? 3 : index == 3 ? 4 : 1).toString()} ${language(context, translations!.star)}",
          style: appCss.dmDenseMedium13
              .textColor(appColor(context).appTheme.darkText)),
      Expanded(
          child: ProgressBar(max: 100, current: data.toString())
              .paddingSymmetric(horizontal: Insets.i15)),
      Text("$data%",
          style: appCss.dmDenseMedium12
              .textColor(appColor(context).appTheme.lightText))
    ]).paddingOnly(bottom: index != list!.length - 1 ? Insets.i20 : 0);
  }
}
