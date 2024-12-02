import 'package:flutter/material.dart';
import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';
import 'package:seconds_fi_app/utils/okto.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seconds_fi_app/theme/app_theme.dart';
import 'package:seconds_fi_app/utils/chain_constants.dart';

class DepositMoneyFromWalletPage extends StatefulWidget {
  const DepositMoneyFromWalletPage({super.key});

  @override
  State<DepositMoneyFromWalletPage> createState() =>
      _DepositMoneyFromWalletPageState();
}

class _DepositMoneyFromWalletPageState
    extends State<DepositMoneyFromWalletPage> {
  final networkNameController = TextEditingController();
  final tokenAddressController = TextEditingController();
  final quantityController = TextEditingController();
  final recipientAddressController = TextEditingController();

  Future<TransferTokenResponse>? _transferToken;
  List<Network>? _supportedNetworks;
  Chain? _selectedSourceChain;
  String? _selectedDestinationNetwork;
  Chain? _selectedDestinationChain;
  TokenSymbol? _selectedSourceToken;
  String? _selectedDestinationToken;
  List<String>? _supportedTokens;

  @override
  void initState() {
    super.initState();
    _loadSupportedChains();
    _loadSupportedTokens();
  }

  Future<void> _loadSupportedTokens() async {
    try {
      final tokens = await okto!.supportedTokens();
      setState(() {
        _supportedTokens =
            tokens.data.tokens.map((token) => token.tokenName).toList();
      });
    } catch (e) {
      debugPrint('Error loading supported tokens: $e');
    }
  }

  Future<void> transferToken() async {
    // if (_selectedSourceChain == null ||
    //     _selectedSourceToken == null ||
    //     _selectedDestinationToken == null) {
    //   throw Exception('Please select chain and tokens');
    // }

    // try {
    //   final transferToken = await okto!.transferTokens(
    //     networkName: _selectedDestinationChain?.name ?? '',
    //     tokenAddress:
    //         _selectedSourceChain!.getTokenAddress(_selectedSourceToken!) ?? '',
    //     quantity: quantityController.text,
    //     recipientAddress: recipientAddressController.text,
    //     sourceChain: _selectedSourceChain?.chainId.toString() ?? '',
    //   );
    //   return transferToken;
    // } catch (e) {
    //   throw Exception(e);
    // }
  }

  Future<void> _loadSupportedChains() async {
    try {
      final networks = await okto!.supportedNetworks();
      setState(() {
        _supportedNetworks = networks.data.network;
      });
    } catch (e) {
      debugPrint('Error loading supported chains: $e');
    }
  }

  Widget _buildChainAndTokenSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Source Chain Dropdown
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: GoogleFonts.newsCycle(
                  color: AppTheme.primaryTextColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Chain>(
                    isExpanded: true,
                    value: _selectedSourceChain,
                    hint: const Text('Select Chain'),
                    // chains supported by router protocol
                    items: Chain.values.map((chain) {
                      return DropdownMenuItem<Chain>(
                        value: chain,
                        child: Text(chain.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (Chain? newValue) {
                      setState(() {
                        _selectedSourceChain = newValue;
                        _selectedSourceToken = null;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Source Token Dropdown - Always visible
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Token',
                style: GoogleFonts.newsCycle(
                  color: AppTheme.primaryTextColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TokenSymbol>(
                    isExpanded: true,
                    value: _selectedSourceToken,
                    hint: const Text('Select Token'),
                    items: (_selectedSourceChain?.getTokenSymbols() ??
                            [
                              TokenSymbol.usdt,
                              TokenSymbol.usdc,
                              TokenSymbol.eth
                            ])
                        .map((token) {
                      return DropdownMenuItem(
                        value: token,
                        child: Text(token.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: _selectedSourceChain == null
                        ? null
                        : (TokenSymbol? newValue) {
                            setState(() {
                              _selectedSourceToken = newValue;
                            });
                          },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Destination Chain Dropdown
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To',
                style: GoogleFonts.newsCycle(
                  color: AppTheme.primaryTextColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Chain>(
                    isExpanded: true,
                    value: _selectedDestinationChain,
                    hint: const Text('Select Chain'),
                    items: (_supportedNetworks
                            ?.map((network) {
                              // Convert network name to Chain enum if possible
                              try {
                                return DropdownMenuItem<Chain>(
                                  value: Chain.values.firstWhere(
                                    (chain) =>
                                        chain.name.toLowerCase() ==
                                        network.networkName.toLowerCase(),
                                  ),
                                  child: Text(network.networkName),
                                );
                              } catch (e) {
                                debugPrint(
                                    'Could not map network: ${network.networkName}');
                                return null;
                              }
                            })
                            .whereType<DropdownMenuItem<Chain>>()
                            .toList() ??
                        []),
                    onChanged: (Chain? newValue) {
                      setState(() {
                        _selectedDestinationChain = newValue;
                        _selectedDestinationToken = null;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Destination Token Dropdown - Always visible
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Token',
                style: GoogleFonts.newsCycle(
                  color: AppTheme.primaryTextColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedDestinationToken,
                    hint: const Text('Select Token'),
                    items: (_supportedTokens ?? []).toSet().map((token) {
                      return DropdownMenuItem(
                        value: token,
                        child: Text(token),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDestinationToken = newValue;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Money',
                style: GoogleFonts.newsCycle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFEEEEEE),
                            radius: 24,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crypto',
                                style: GoogleFonts.newsCycle(
                                  fontSize: 24,
                                  color: AppTheme.primaryTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Send from wallet or exchange',
                                style: GoogleFonts.newsCycle(
                                  color: AppTheme.primaryTextColor
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(height: 32),

                      // Currency Section
                      Text(
                        'Currency',
                        style: GoogleFonts.newsCycle(
                          color: AppTheme.primaryTextColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: quantityController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '500.00',
                            hintStyle: TextStyle(
                              color: AppTheme.primaryTextColor.withOpacity(0.5),
                            ),
                          ),
                          style: TextStyle(
                            color: AppTheme.primaryTextColor,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      // const SizedBox(height: 24),

                      // Source and Destination Network Selection
                      // Row(
                      //   children: [
                      //     // Source Chain Dropdown
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             'From',
                      //             style: GoogleFonts.newsCycle(
                      //               color: AppTheme.primaryTextColor
                      //                   .withOpacity(0.7),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           Container(
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 16, vertical: 8),
                      //             decoration: BoxDecoration(
                      //               border:
                      //                   Border.all(color: Colors.grey.shade300),
                      //               borderRadius: BorderRadius.circular(8),
                      //             ),
                      //             child: DropdownButton<Chain>(
                      //               isExpanded: true,
                      //               value: _selectedSourceChain,
                      //               hint: Text('Select Chain',
                      //                   style: TextStyle(
                      //                       color: AppTheme.primaryTextColor)),
                      //               underline: Container(),
                      //               items: Chain.values.map((chain) {
                      //                 return DropdownMenuItem<Chain>(
                      //                   value: chain,
                      //                   child: Text(chain.name.toUpperCase()),
                      //                 );
                      //               }).toList(),
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   _selectedSourceChain = value;
                      //                 });
                      //               },
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     const SizedBox(width: 16),
                      //     // Destination Network Dropdown
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             'To',
                      //             style: GoogleFonts.newsCycle(
                      //               color: AppTheme.primaryTextColor
                      //                   .withOpacity(0.7),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           FutureBuilder<NetworkDetails>(
                      //             future: _supportedNetworks,
                      //             builder: (context, snapshot) {
                      //               return Container(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     horizontal: 16, vertical: 8),
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(
                      //                       color: Colors.grey.shade300),
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //                 child: DropdownButton<String>(
                      //                   isExpanded: true,
                      //                   value: _selectedDestinationNetwork,
                      //                   hint: Text('Select Network',
                      //                       style: TextStyle(
                      //                           color:
                      //                               AppTheme.primaryTextColor)),
                      //                   underline: Container(),
                      //                   items: snapshot.hasData
                      //                       ? snapshot.data!.data.network
                      //                           .map((network) {
                      //                           return DropdownMenuItem<String>(
                      //                             value: network.networkName,
                      //                             child:
                      //                                 Text(network.networkName),
                      //                           );
                      //                         }).toList()
                      //                       : [],
                      //                   onChanged: (value) {
                      //                     setState(() {
                      //                       _selectedDestinationNetwork = value;
                      //                     });
                      //                   },
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 12),
                      _buildChainAndTokenSelectors(),
                      // Transfer Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryTextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              // _transferToken = transferToken();
                            });
                          },
                          child: Text(
                            'Swipe to Send',
                            style: GoogleFonts.newsCycle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
