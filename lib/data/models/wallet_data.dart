import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';

class WalletData extends Wallet {
  WalletData({
    required super.networkName,
    required super.address,
    required super.success,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      networkName: json['network_name'],
      address: json['address'],
      success: json['success'],
    );
  }

  factory WalletData.fromWallet(Wallet wallet) {
    return WalletData(
      networkName: wallet.networkName,
      address: wallet.address,
      success: wallet.success,
    );
  }
}
