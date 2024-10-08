import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';
import 'package:seconds_fi_app/providers/auth_state_provider.dart';
import 'package:seconds_fi_app/providers/user_provider.dart';
import 'package:seconds_fi_app/screens/auth/google_login.dart';
import 'package:seconds_fi_app/screens/onboarding_screen.dart';
import 'package:seconds_fi_app/data/states/auth_state.dart';
import 'package:seconds_fi_app/services/google_signin_service.dart';
import 'package:seconds_fi_app/utils/okto.dart';
import 'package:seconds_fi_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:seconds_fi_app/providers/wallet_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  okto = Okto(globals.getOktoApiKey(), globals.getBuildType());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider<AuthStateProvider>(
          create: (context) => AuthStateProvider(),
        ),
        ChangeNotifierProxyProvider<AuthStateProvider, UserProvider>(
          create: (_) => UserProvider(),
          update: (_, authProvider, previousUserProvider) {
            final userProvider = previousUserProvider ?? UserProvider();
            userProvider.update(authProvider);
            return userProvider;
          },
        ),
      ],
      child: const SecondsFiApp(),
    ),
  );
}

class SecondsFiApp extends StatelessWidget {
  const SecondsFiApp({super.key});

  Future<bool> checkLoginStatus() async {
    bool isOktoLoggedIn = await okto!.isLoggedIn();
    bool isGoogleSignedIn = await GoogleSignIn().isSignedIn();
    return isOktoLoggedIn && isGoogleSignedIn;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seconds FI App',
      theme: AppTheme.theme,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Show login or home page based on login status]
            bool isLoggedIn = snapshot.data ?? false;
            if (isLoggedIn) {
              return const OnboardingScreen();
            } else {
              return const LoginWithGoogle();
            }
          }
        },
      ),
    );
  }
}
