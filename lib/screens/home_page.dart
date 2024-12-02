import 'package:flutter/material.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:seconds_fi_app/data/models/vault_data.dart';
import 'package:seconds_fi_app/screens/transfer_tokens/deposit_money_from_wallet.dart';
import 'package:seconds_fi_app/screens/view_details/user_details.dart';
import 'package:seconds_fi_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:seconds_fi_app/providers/wallet_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 5014.42;
  double profit = 14.42;
  String profitPeriod = '1D';
  List<VaultData> vaults = [
    VaultData('High Yield Lending',
        'Optimised for the least risk, with the most returns', '12%'),
    VaultData('Structured Options',
        'High returns. You only lose if the BTC goes down by 90%', '25%'),
    VaultData('DCA', 'Best for the 6-12 months horizon.', 'Long-term'),
    VaultData('Private companies', 'Available for accredited investors.',
        'Long-term'),
  ];
  int? selectedVaultIndex;

  void addMoney(double amount) {
    setState(() {
      balance += amount;
    });
  }

  void updateProfit() {
    setState(() {
      profit = balance * 0.01;
    });
  }

  void selectVault(int index) {
    setState(() {
      selectedVaultIndex = (selectedVaultIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.whiteBackgroundColor,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    Text(
                      'Vaults',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryTextColor,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: vaults.length,
                        itemBuilder: (context, index) {
                          return _buildVaultCard(vaults[index], index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedVaultIndex != null) _buildStickyButton(),
          ],
        ));
  }

  Widget _buildStickyButton() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: NeoPopTiltedButton(
          isFloating: true,
          onTapUp: () {
            // Add your onTap functionality here
            debugPrint(
                'Button tapped for vault: ${vaults[selectedVaultIndex!].title}');
          },
          decoration: const NeoPopTiltedButtonDecoration(
            color: AppTheme.primaryTextColor,
            plunkColor: AppTheme.highlightColor,
            shadowColor: Colors.black,
            border: Border.fromBorderSide(
              BorderSide(color: AppTheme.primaryTextColor, width: 1),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25,
                vertical: 15),
            child: const Text('Invest Now',
                style: TextStyle(
                    color: AppTheme.whiteBackgroundColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppTheme.highlightColor,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserDetailsPage()),
                  );
                },
                child: const Icon(Icons.remove_red_eye,
                    color: AppTheme.primaryTextColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Text(
              '\$5014.42',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Positioned(
              top: 0,
              right: -50,
              child: Transform.translate(
                offset: const Offset(0,
                    -20), // Adjust this value to fine-tune the vertical position
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '+\$14.42',
                      style: TextStyle(
                        color: AppTheme.greenSecondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Adjust size as needed
                      ),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.highlightColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '1D',
                        style: TextStyle(
                          color: AppTheme.primaryTextColor,
                          fontSize: 12, // Adjust size as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        NeoPopTiltedButton(
          isFloating: true,
          onTapUp: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DepositMoneyFromWalletPage()),
            );
          },
          decoration: const NeoPopTiltedButtonDecoration(
            color: AppTheme.highlightColor,
            plunkColor: AppTheme.highlightColor,
            shadowColor: AppTheme.primaryTextColor,
            showShimmer: true,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 70.0,
              vertical: 15,
            ),
            child: Text(
              'Add Money',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVaultCard(VaultData vault, int index) {
    bool isSelected = selectedVaultIndex == index;
    return GestureDetector(
      onTap: () => selectVault(index),
      child: Card(
        color: isSelected
            ? AppTheme.secondaryWhiteBackgroundColor
            : AppTheme.whiteBackgroundColor,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vault.title,
                    style: TextStyle(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.highlightColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vault.tag,
                      style: TextStyle(color: AppTheme.primaryTextColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                vault.description,
                style: TextStyle(
                    color: AppTheme.primaryTextColor.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
