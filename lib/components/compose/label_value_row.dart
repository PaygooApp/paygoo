import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;
  final double fontSize;
  final FontWeight? valueFontWeight;

  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
    this.fontSize = 13,
    this.valueFontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: fontSize,
            color: labelColor ?? TokenPrimitiveMode1.gray500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: fontSize,
            fontWeight: valueFontWeight,
            color: valueColor ?? TokenPrimitiveMode1.gray700,
          ),
        ),
      ],
    );
  }
}

