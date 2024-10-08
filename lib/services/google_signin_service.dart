import 'package:google_sign_in/google_sign_in.dart';
import 'package:seconds_fi_app/data/states/auth_state.dart';
import 'package:seconds_fi_app/utils/okto.dart';

class GoogleSignInService {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid',
    ],
    forceCodeForRefreshToken: true,
  );

  Future<Map<String, dynamic>> signIn() async {
    return await _handleGoogleSignIn();
  }

  Future<Map<String, dynamic>> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth != null) {
        final String? idToken = googleAuth.idToken;
        await okto!.authenticate(idToken: idToken!);

        return {
          'success': true,
          'googleUser': googleUser,
          'auth': googleAuth,
        };
      } else {
        return {'success': false, 'error': 'Google sign in failed'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<GoogleSignInAccount?> signOut() async {
    return await googleSignIn.signOut();
  }
}
