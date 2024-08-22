import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:okto_sdk_example/screens/home_page.dart';
import 'package:okto_sdk_example/utils/global.dart';
import 'package:okto_sdk_example/utils/okto.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  Globals globals1 = Globals.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid',
    ],
    forceCodeForRefreshToken: true,
  );
  String error = '';
  @override
  void initState() {
    super.initState();
    print(globals1.getOktoApiKey());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5166EE),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(40),
                child: const Text(
                  'Welcome to Okto',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 30),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final GoogleSignInAccount? googleUser =
                        await googleSignIn.signIn();
                    final GoogleSignInAuthentication? googleAuth =
                        await googleUser?.authentication;
                    if (googleAuth != null) {
                      final String? idToken = googleAuth.idToken;
                      await okto!.authenticate(idToken: idToken!);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }
                    // ignore: use_build_context_synchronously
                  } catch (e) {
                    print(e.toString());
                    setState(() {
                      error = e.toString();
                    });
                  }
                },
                child: const Text('Login with Google')),
            const SizedBox(
              height: 20,
            ),
            error.isNotEmpty
                ? Container(
                    color: const Color.fromARGB(255, 23, 28, 67),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
