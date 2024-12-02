import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:seconds_fi_app/theme/app_theme.dart';

class DepositQRCode extends StatelessWidget {
  final String depositAddress;
  final double size;

  const DepositQRCode({
    super.key,
    required this.depositAddress,
    this.size = 200.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.whiteBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: depositAddress,
            version: QrVersions.auto,
            size: size,
            backgroundColor: AppTheme.whiteBackgroundColor,
            foregroundColor: AppTheme.primaryTextColor,
          ),
          const SizedBox(height: 16),
          SelectableText(
            depositAddress,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
