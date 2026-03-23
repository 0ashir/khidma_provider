import 'package:flutter_xlider/flutter_xlider.dart';

import '../../../../config.dart';

class SliderLayout extends StatelessWidget {
   final double? val;
   final Function(int handlerIndex, dynamic lowerValue, dynamic upperValue)?
   onDragging;
  const SliderLayout({super.key, this.val, this.onDragging});

  @override
  Widget build(BuildContext context) {
   
    return SizedBox(
      height: Sizes.s70,
      child: FlutterSlider(
          values: [val!],
          min: 0,
          max: 30,
          hatchMark: FlutterSliderHatchMark(
              density: 0.3,
              // means 50 lines, from 0 to 100 percent
              displayLines: true,
              labelBox: FlutterSliderSizedBox(
                  height: 10,
                  width: 20,
                  decoration: BoxDecoration(
                      color: appColor(context).appTheme.trans)),
              smallLine:
              const FlutterSliderSizedBox(width: 1, height: 1),
              bigLine: const FlutterSliderSizedBox(
                width: 1,
                height: 1,
              ),
              labels: [
                FlutterSliderHatchMarkLabel(
                    percent: 0.5,
                    label: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 4,
                          width: 2,
                          color: val == 0.0 ||
                              val == 5.0 ||
                              val == 10.0 ||
                              val == 15.0||
                              val == 20.0||
                              val == 25.0||
                              val == 30.0
                              ? appColor(context)
                              .appTheme
                              .darkText
                              : appColor(context).appTheme.stroke,
                        ),
                        const VSpace(Sizes.s3),
                        Text('0\nkm',
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseMedium12
                                .textColor(val == 0.0 ||
                                val == 5.0 ||
                                val == 10.0 ||
                                val == 15.0||
                                val == 20.0||
                                val == 25.0||
                                val == 30.0
                                ? appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText)
                                .textHeight(1)),
                      ],
                    )),
                FlutterSliderHatchMarkLabel(
                    percent: 17,
                    label: Column(
                      children: [
                        Container(
                          height: 4,
                          width: 2,
                          color: val == 5.0 ||
                              val == 10.0 ||
                              val == 15.0||
                              val == 20.0||
                              val == 25.0||
                              val == 30.0
                              ? appColor(context)
                              .appTheme
                              .darkText
                              : appColor(context).appTheme.stroke,
                        ),
                        const VSpace(Sizes.s3),
                        Text('5\nkm',
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseMedium12
                                .textColor(val == 5.0 ||
                                val == 10.0 ||
                                val == 15.0||
                                val == 20.0||
                                val == 25.0||
                                val == 30.0
                                ? appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText)
                                .textHeight(1)),
                      ],
                    )),
                FlutterSliderHatchMarkLabel(
                    percent: 33.5,
                    label: Column(
                      children: [
                        Container(
                          height: 4,
                          width: 2,
                          color: val == 10.0 ||
                              val == 15.0||
                              val == 20.0||
                              val == 25.0||
                              val == 30.0
                              ? appColor(context)
                              .appTheme
                              .darkText
                              : appColor(context).appTheme.stroke,
                        ),
                        const VSpace(Sizes.s3),
                        Text('10\nkm',
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseMedium12
                                .textColor(val == 10.0 ||
                                val == 15.0||
                                val == 20.0||
                                val == 25.0||
                                val == 30.0
                                ? appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText)
                                .textHeight(1)),
                      ],
                    )),
                FlutterSliderHatchMarkLabel(
                    percent: 50,
                    label: Column(
                      children: [
                        Container(
                          height: 4,
                          width: 2,
                          color: val == 15.0||
                              val == 20.0||
                              val == 25.0||
                              val == 30.0
                              ? appColor(context)
                              .appTheme
                              .darkText
                              : appColor(context).appTheme.stroke,
                        ),
                        const VSpace(Sizes.s3),
                        Text('15\nkm',
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseMedium12
                                .textColor(val == 15.0||
                                val == 20.0||
                                val == 25.0||
                                val == 30.0
                                ? appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText)
                                .textHeight(1)),
                      ],
                    )),
                FlutterSliderHatchMarkLabel(
                    percent: 66,
                    label: Column(
                      children: [
                        Container(
                          height: 4,
                          width: 2,
                          color: val == 20.0||
                              val == 25.0||
                              val == 30.0
                              ? appColor(context)
                              .appTheme
                              .darkText
                              : appColor(context).appTheme.stroke,
                        ),
                        const VSpace(Sizes.s3),
                        Text('20\nkm',
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseMedium12
                                .textColor(val == 20.0||
                                val == 25.0||
                                val == 30.0
                                ? appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText)
                                .textHeight(1)),
                      ],
                    )),
                FlutterSliderHatchMarkLabel(
                    percent: 84,
                    label: Column(
                      children: [
                        Container(
                          height: 4,
                          width: 2,
                          color: val == 25.0||
                              val == 30.0
                              ? appColor(context)
                              .appTheme
                              .darkText
                              : appColor(context).appTheme.stroke,
                        ),
                        const VSpace(Sizes.s3),
                        Text('25\nkm',
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseMedium12
                                .textColor(val == 25.0||
                                val == 30.0
                                ? appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText)
                                .textHeight(1)),
                      ],
                    )),
                FlutterSliderHatchMarkLabel(
                    percent: 100,
                    label: Column(
                      children: [
                        Container(
                          height: 4,
                          width: 2,
                          color: val == 30.0
                              ? appColor(context)
                              .appTheme
                              .darkText
                              : appColor(context).appTheme.stroke,
                        ),
                        const VSpace(Sizes.s3),
                        Text('30\nkm',
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseMedium12
                                .textColor( val == 30.0
                                ? appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText)
                                .textHeight(1)),
                      ],
                    )),
              ],
              labelsDistanceFromTrackBar: 35),
          tooltip: FlutterSliderTooltip(
              alwaysShowTooltip: false, disabled: true),
          handler: FlutterSliderHandler(
              decoration: BoxDecoration(
                  color: appColor(context).appTheme.trans),
              child: SvgPicture.asset(
                eSvgAssets.userSlider,color: appColor(context).appTheme.darkText,
                height: Sizes.s28,
              ).paddingOnly(bottom: 14)),
          trackBar: FlutterSliderTrackBar(
              activeTrackBarHeight: 4.5,
              activeTrackBarDraggable: true,
              inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: appColor(context).appTheme.stroke),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: appColor(context).appTheme.darkText),
              inactiveTrackBarHeight: 4.5,
              inactiveDisabledTrackBarColor:
              appColor(context).appTheme.stroke,
              activeDisabledTrackBarColor:
              appColor(context).appTheme.darkText),
          step: const FlutterSliderStep(step: 5),
          jump: true,
          onDragging: onDragging),
    );
  }
}
