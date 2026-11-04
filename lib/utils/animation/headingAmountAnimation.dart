import 'dart:async';
import 'package:flutter/material.dart';

class HeadingAmountAnimation extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration speed;

  const HeadingAmountAnimation({
    Key? key,
    required this.text,
    this.textStyle,
    this.speed = const Duration(milliseconds: 50),
  }) : super(key: key);

  @override
  _HeadingAmountAnimationState createState() => _HeadingAmountAnimationState();
}

class _HeadingAmountAnimationState extends State<HeadingAmountAnimation> {
  String displayedText = '';
  int charIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTypingAnimation();
  }

  void startTypingAnimation() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (charIndex < widget.text.length) {
        setState(() {
          displayedText = widget.text.substring(0, charIndex + 1);
          charIndex++;
        });
      } else {
        _timer.cancel(); // Stop animation when complete
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedText,
      style:
          widget.textStyle ??
          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
