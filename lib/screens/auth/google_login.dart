import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:seconds_fi_app/providers/user_provider.dart';
import 'package:seconds_fi_app/screens/home_page.dart';
import 'package:seconds_fi_app/data/states/auth_state.dart';
import 'package:seconds_fi_app/screens/onboarding_screen.dart';
import 'package:seconds_fi_app/utils/global.dart';
import 'package:seconds_fi_app/utils/okto.dart';
import 'package:seconds_fi_app/theme/app_theme.dart';
import 'package:seconds_fi_app/providers/auth_state_provider.dart';
import 'package:provider/provider.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  @override
  Widget build(BuildContext context) {
    final AuthStateProvider authStateProvider =
        Provider.of<AuthStateProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.whiteBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to\nSeconds.fi',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 64,
                      height: 1.2,
                    ),
              ),
              const SizedBox(height: 40),
              Text(
                'How do you like\nyour savings?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 32,
                      height: 1.35,
                    ),
              ),
              const SizedBox(height: 40),
              _buildSavingsOption('Cash ->'),
              _buildSavingsOption('Savings', percentage: '12%'),
              _buildSavingsOption('DCA'),
              _buildSavingsOption('Options', percentage: '25%'),
              _buildSavingsOption('ETFs'),
              _buildSavingsOption('Private Companies'),
              const Spacer(),
              Center(
                child: Consumer<AuthStateProvider>(
                  builder: (context, authProvider, _) {
                    if (authProvider.authState == AuthState.authenticated) {
                      // Navigate to OnboardingScreen only once
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const OnboardingScreen()),
                          (route) => false, // This removes all previous routes
                        );
                      });
                      return const SizedBox.shrink();
                    }
                    return _buildGoogleSignInButton(
                      () => authProvider.signInWithGoogle(),
                    );
                  },
                ),
              ),
              if (authStateProvider.authState == AuthState.error)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    authStateProvider.error.toString(),
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsOption(String text, {String? percentage}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.primaryTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (percentage != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.highlightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                percentage,
                style: const TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

//create a neopop button that will be used to sign in with google
  Widget _buildGoogleSignInButton(Function() onTap) {
    return NeoPopButton(
      color: AppTheme.highlightColor,
      onTapUp: () => {HapticFeedback.vibrate()},
      onTapDown: () => {
        HapticFeedback.vibrate(),
        onTap(),
      },
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Sign in with Google",
          style: const TextStyle(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.normal,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
