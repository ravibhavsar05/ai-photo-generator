import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextSegment {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final VoidCallback? onTap; // 👈 add tap handler

  const TextSegment({
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.onTap,
  });
}

// --- Custom Widget for Styled Rich Text ---
class StyledText extends StatelessWidget {
  final List<TextSegment> segments;
  final TextAlign? textAlign;
  final List<Shadow>? shadows;

  const StyledText({
    super.key,
    required this.segments,
    this.textAlign,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;

    return Text.rich(
      TextSpan(
        children: segments.map((segment) {
          return TextSpan(
            text: segment.text,
            style: TextStyle(
              color: segment.color ?? defaultStyle.color,
              fontSize: segment.fontSize ?? defaultStyle.fontSize,
              fontWeight: segment.fontWeight ?? defaultStyle.fontWeight,
              shadows: shadows,
            ),
            recognizer: segment.onTap != null
                ? (TapGestureRecognizer()..onTap = segment.onTap)
                : null, // 👈 enable taps
          );
        }).toList(),
      ),
      textAlign: textAlign,
    );
  }
}
