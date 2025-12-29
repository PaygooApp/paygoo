import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class VenueTableCard extends StatelessWidget {
  const VenueTableCard({
    super.key,
    required this.venueLogo,
    required this.venueName,
    required this.tableNumber,
    required this.totalAmount,
    this.totalLabel = "Your total Bill",
  });

  final String venueLogo;
  final String venueName;
  final String tableNumber;
  final String totalAmount;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(TokenPrimitiveMode1.scale400.toDouble()),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
          TokenPrimitiveMode1.borderRadiuslg.toDouble(),
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 35,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: TokenPrimitiveMode1.gray200,
          width: TokenPrimitiveMode1.borderWidthsm.toDouble(),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TokenPrimitiveMode1.gray100,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(venueLogo, fit: BoxFit.cover),
                ),
                SizedBox(width: TokenPrimitiveMode1.scale300.toDouble()),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venueName,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: TokenPrimitiveMode1.scale100.toDouble()),
                      Text(
                        tableNumber,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: TokenPrimitiveMode1.scale300.toDouble()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs
                      .toDouble(),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: TokenPrimitiveMode1.scale100.toDouble()),
              Text(totalAmount, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ],
      ),
    );
  }
}
