import 'package:flutter/material.dart';
import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';
import 'package:seconds_fi_app/utils/okto.dart';

class ViewWalletPage extends StatefulWidget {
  const ViewWalletPage({super.key});

  @override
  State<ViewWalletPage> createState() => _ViewWalletPageState();
}

class _ViewWalletPageState extends State<ViewWalletPage> {
  Future<WalletResponse>? _wallets;

  Future<WalletResponse> fetchWallets() async {
    try {
      final wallets = await okto!.createWallet();
      return wallets;
    } catch (e) {
      throw Exception(e);
    }
  }

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
                'Get Wallet',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 30),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _wallets = fetchWallets();
                });
              },
              child: const Text('Get Wallet'),
            ),
            Expanded(
              child: _wallets == null
                  ? Container()
                  : FutureBuilder<WalletResponse>(
                      future: _wallets,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final wallets = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Wallet created successfully',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.6,
                                  child: ListView.builder(
                                      itemCount: wallets.data.wallets.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          color: const Color(0xff5166EE),
                                          margin: const EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SelectableText(
                                                'Wallet adress: ${wallets.data.wallets[index].address}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              SelectableText(
                                                'Network name: ${wallets.data.wallets[index].networkName}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
