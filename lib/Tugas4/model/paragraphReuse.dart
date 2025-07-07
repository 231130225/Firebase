import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  const Paragraph({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

