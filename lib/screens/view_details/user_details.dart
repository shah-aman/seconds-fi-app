import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:seconds_fi_app/providers/auth_state_provider.dart';
import 'package:seconds_fi_app/providers/user_provider.dart';
import 'package:seconds_fi_app/screens/auth/google_login.dart';
import 'package:seconds_fi_app/theme/app_theme.dart';
import 'package:seconds_fi_app/utils/okto.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Future<UserDetails>? _userDetails;

  Future<UserDetails> fetchUserDetails() async {
    try {
      final userDetails = await okto!.userDetails();
      return userDetails;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut(AuthStateProvider authProvider) async {
    authProvider.signOut();
    await okto!.logout();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginWithGoogle()));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    final authProvider = Provider.of<AuthStateProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.whiteBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello, ${userData?.name ?? 'User'}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined,
                            color: AppTheme.primaryTextColor),
                        onPressed: () {/* Handle notifications */},
                      ),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData?.profileImage ?? ''),
                        radius: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(child: _buildBalanceCard(context)),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
              _buildWalletAddressCard(context, userProvider),
              const SizedBox(height: 40),
              Text(
                'Transactions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildTransactionList()),
              const SizedBox(height: 20),
              _buildLogoutButton(context, () => signOut(authProvider)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletAddressCard(
      BuildContext context, UserProvider userProvider) {
    String walletAddress = 'No wallet available';
    String displayAddress = 'No wallet available';

    if (userProvider.userData != null &&
        userProvider.userData!.wallets.isNotEmpty) {
      walletAddress = userProvider.userData!.wallets.first.address;
      if (walletAddress.length > 13) {
        displayAddress =
            '${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}';
      } else {
        displayAddress = walletAddress;
      }
    }

    debugPrint('Wallet address widget: $walletAddress');

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.primaryTextColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet Address',
                  style: TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  displayAddress as String,
                  style: TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: AppTheme.primaryTextColor),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: walletAddress as String));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Wallet address copied to clipboard')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppTheme.primaryTextColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppTheme.primaryTextColor),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryTextColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Balance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.whiteBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$3,460,348',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.highlightColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '↑ \$670 • 2%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
            icon: Icons.add,
            label: 'Add Money',
            backgroundColor: AppTheme.highlightColor,
            iconColor: AppTheme.primaryTextColor,
            onTap: () {}),
        _buildActionButton(
            icon: Icons.swap_horiz,
            label: 'Trade',
            backgroundColor: Colors.orange,
            iconColor: AppTheme.primaryTextColor,
            onTap: () {}),
        _buildActionButton(
            icon: Icons.download,
            label: 'Withdraw',
            backgroundColor: Colors.blue,
            iconColor: AppTheme.primaryTextColor,
            onTap: () {}),
      ],
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required Color backgroundColor,
      required Color iconColor,
      required Function() onTap}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 48,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final transactions = [
      {'name': 'Matteo', 'amount': '€100', 'date': 'Aug 25, 2022'},
      {'name': 'Bitcoin', 'amount': '\$300', 'date': 'Aug 25, 2022'},
      {'name': 'Solana', 'amount': '\$900', 'date': 'Aug 25, 2022'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.highlightColor.withOpacity(0.2),
            child: Text(transaction['name']![0],
                style: TextStyle(color: AppTheme.primaryTextColor)),
          ),
          title: Text(transaction['name']!,
              style: TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(transaction['date']!,
              style:
                  TextStyle(color: AppTheme.primaryTextColor.withOpacity(0.7))),
          trailing: Text(transaction['amount']!,
              style: TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
