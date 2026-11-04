import 'package:edemand_partner/ui/widgets/customContainer.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
  });
  final Color color;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomContainer(
          width: 15,
          height: 15,
          shape: BoxShape.circle,
          color: color,
        ),
        // Widgets.getSizedBox(width: 15,),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
