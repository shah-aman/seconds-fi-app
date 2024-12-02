import 'package:flutter/material.dart';
import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';
import 'package:seconds_fi_app/data/models/wallet_data.dart';
import 'package:seconds_fi_app/utils/okto.dart';

class WalletProvider extends ChangeNotifier {
  WalletResponse? _walletResponse;
  bool _isLoading = false;
  String? _error;
  bool _hasInitialized = false;

  WalletResponse? get walletResponse => _walletResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWallets() async {
    if (_hasInitialized || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final wallets = await okto!.createWallet();
      _walletResponse = wallets;
      _hasInitialized = true;
    } catch (e) {
      _error = e.toString();
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
