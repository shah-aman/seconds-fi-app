import 'package:google_sign_in/google_sign_in.dart';
import 'package:seconds_fi_app/data/models/wallet_data.dart';

class UserData {
  final String name;
  final String email;
  final String userId;
  final String? profileImage;
  final List<WalletData> wallets = [];
  UserData({
    required this.name,
    required this.email,
    required this.userId,
    this.profileImage,
  });

  factory UserData.fromGoogleSignInAccount(GoogleSignInAccount googleUser) {
    return UserData(
      name: googleUser.displayName ?? '',
      email: googleUser.email,
      userId: googleUser.id,
      profileImage: googleUser.photoUrl,
    );
  }
}
