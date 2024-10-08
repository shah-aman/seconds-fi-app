import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seconds_fi_app/data/states/auth_state.dart';
import 'package:seconds_fi_app/services/google_signin_service.dart';
import 'package:seconds_fi_app/providers/user_provider.dart';

class AuthStateProvider extends ChangeNotifier {
  AuthState _authState = AuthState.loading;
  String _error = '';
  GoogleSignInAccount? _googleSignInAccount;
  GoogleSignInAuthentication? _googleSignInAuthentication;
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  AuthState get authState => _authState;
  String get error => _error;
  void setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }

  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;
  GoogleSignInAuthentication? get googleSignInAuthentication =>
      _googleSignInAuthentication;

  AuthStateProvider();

  void setGoogleSignInAccount(GoogleSignInAccount? googleSignInAccount) {
    _googleSignInAccount = googleSignInAccount;
  }

  void setGoogleSignInAuthentication(
      GoogleSignInAuthentication? googleSignInAuthentication) {
    _googleSignInAuthentication = googleSignInAuthentication;
  }

  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void signInWithGoogle() async {
    setAuthState(AuthState.loading);
    final result = await _googleSignInService.signIn();
    if (result['success'] == true) {
      setGoogleSignInAccount(result['googleUser']);
      setGoogleSignInAuthentication(result['auth']);
      // await userProvider.initializeUserData(result['googleUser']);
      setAuthState(AuthState.authenticated);
    } else {
      setAuthState(AuthState.error);
      setError(result['error']);
    }
  }

  void signOut() async {
    await _googleSignInService.signOut();
    setAuthState(AuthState.unauthenticated);
  }
}
