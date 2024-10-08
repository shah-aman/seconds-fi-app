import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seconds_fi_app/data/models/user_data.dart';
import 'package:seconds_fi_app/data/models/wallet_data.dart';
import 'package:seconds_fi_app/data/states/auth_state.dart';
import 'package:seconds_fi_app/providers/auth_state_provider.dart';
import 'package:seconds_fi_app/utils/okto.dart';

class UserProvider extends ChangeNotifier {
  UserData? _userData;
  UserData? get userData => _userData;

  void setUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  void addWallet(List<WalletData> walletData) {
    if (_userData == null) {
      return;
    }
    _userData!.wallets.addAll(walletData);
    debugPrint('Wallets added: ${_userData!.wallets.length}');
    debugPrint('First wallet address: ${_userData!.wallets.first.address}');
    notifyListeners();
  }

  void userLogout() {
    _userData = null;
    notifyListeners();
  }

  Future<void> initializeUserData(GoogleSignInAccount googleUser) async {
    _userData = UserData.fromGoogleSignInAccount(googleUser);
    notifyListeners();
  }

  void update(AuthStateProvider authProvider) {
    if (authProvider.authState == AuthState.authenticated &&
        authProvider.googleSignInAccount != null) {
      initializeUserData(authProvider.googleSignInAccount!);
    } else if (authProvider.authState == AuthState.unauthenticated) {
      _userData = null;
    }
    notifyListeners();
  }
}
