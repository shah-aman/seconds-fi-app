import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './deposit_qr_code.dart';

class DepositScreen extends StatelessWidget {
  final String depositAddress;

  const DepositScreen({
    super.key,
    required this.depositAddress,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: depositAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Scan QR Code to Deposit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              DepositQRCode(
                depositAddress: depositAddress,
                size: 250,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(context),
                icon: const Icon(Icons.copy),
                label: const Text('Copy Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
