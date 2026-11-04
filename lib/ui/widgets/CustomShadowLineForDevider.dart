import 'package:flutter/material.dart';

enum ShadowDirection { leftToRight, rightToLeft, centerToSides, sidesToCenter }

class CustomShadowLineForDevider extends StatelessWidget {
  final double height;
  final double width;
  final ShadowDirection direction;

  const CustomShadowLineForDevider({
    Key? key,
    this.height = 1.0,
    this.width = double.infinity,
    this.direction = ShadowDirection.centerToSides,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors;

    switch (direction) {
      case ShadowDirection.leftToRight:
        colors = [Colors.black26, Colors.transparent];
        break;
      case ShadowDirection.rightToLeft:
        colors = [Colors.transparent, Colors.black26];
        break;
      case ShadowDirection.sidesToCenter:
        colors = [Colors.black26, Colors.transparent, Colors.black26];
        break;
      case ShadowDirection.centerToSides:
        colors = [Colors.transparent, Colors.black26, Colors.transparent];
    }

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
      ),
    );
  }
}
