import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class TermsAndConditions extends StatelessWidget {
  final VoidCallback? onTermsTapped;
  final VoidCallback? onPrivacyTapped;

  const TermsAndConditions({
    super.key,
    this.onTermsTapped,
    this.onPrivacyTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontSize: 10,
            color: TokenPrimitiveMode1.gray400,
          ),
          children: [
            const TextSpan(text: 'By proceeding you agree to our '),
            WidgetSpan(
              child: GestureDetector(
                onTap: onTermsTapped,
                child: Text(
                  'Terms & Conditions',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: TokenPrimitiveMode1.primary500,
                  ),
                ),
              ),
            ),
            const TextSpan(text: '\nand '),
            WidgetSpan(
              child: GestureDetector(
                onTap: onPrivacyTapped,
                child: Text(
                  'Privacy Policy',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: TokenPrimitiveMode1.primary500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

