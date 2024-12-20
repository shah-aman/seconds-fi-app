import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seconds_fi_app/data/models/wallet_data.dart';
import 'package:seconds_fi_app/providers/router_protocol_provider.dart';
import 'package:seconds_fi_app/providers/user_provider.dart';
import 'package:seconds_fi_app/providers/wallet_provider.dart';
import 'package:seconds_fi_app/screens/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWallets();
    });
  }

  Future<void> fetchWallets() async {
    if (_isNavigating) return;

    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await walletProvider.fetchWallets();

    if (walletProvider.error == null &&
        walletProvider.walletResponse != null &&
        mounted &&
        !_isNavigating) {
      _isNavigating = true;

      List<WalletData> walletDataList = walletProvider
          .walletResponse!.data.wallets
          .map((wallet) => WalletData.fromWallet(wallet))
          .toList();

      userProvider.addWallet(walletDataList);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<WalletProvider>(
          builder: (context, walletProvider, child) {
            if (walletProvider.isLoading) {
              //gif loader full screen

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/loader.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (walletProvider.error != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${walletProvider.error}'),
                  ElevatedButton(
                    onPressed: fetchWallets,
                    child: Text('Retry'),
                  ),
                ],
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/loader.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
