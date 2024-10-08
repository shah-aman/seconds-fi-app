import 'package:flutter/material.dart';
import 'package:seconds_fi_app/screens/auth/google_login.dart';
import 'package:seconds_fi_app/screens/raw_txn/raw_transaction_execute_page.dart';
import 'package:seconds_fi_app/screens/supported_networks/supported_networks_page.dart';
import 'package:seconds_fi_app/screens/transfer_tokens/order_history_page.dart';
import 'package:seconds_fi_app/screens/transfer_tokens/transfer_tokens_page.dart';
import 'package:seconds_fi_app/screens/view_details/user_details.dart';
import 'package:seconds_fi_app/screens/view_details/user_portfolio.dart';
import 'package:seconds_fi_app/screens/view_details/view_wallet.dart';
import 'package:seconds_fi_app/utils/okto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5166EE),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(40),
              child: const Text(
                'Home Page',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 30),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserDetailsPage()));
                            },
                            child: const Text('User Details')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserPortfolioPage()));
                            },
                            child: const Text('User Portfolio')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewWalletPage()));
                            },
                            child: const Text('Get Wallet')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TransferTokensPage()));
                        },
                        child: const Text('Transfer Tokens')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RawTransactioneExecutePage()));
                        },
                        child: const Text('Raw Transaction Execute')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderHistoryPage()));
                        },
                        child: const Text('Order History')),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await okto!.logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginWithGoogle()));
                } catch (e) {
                  print(e);
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportedNetworksPage()));
              },
              child: const Text('Supported Networks'),
            ),
            ElevatedButton(
              onPressed: () async {
                await okto!.openBottomSheet(
                    context:
                        context); // you can customize the bottom sheet by passing parameters.
              },
              child: Text('Open Okto Widget'),
            ),
          ],
        ),
      ),
    );
  }
}
