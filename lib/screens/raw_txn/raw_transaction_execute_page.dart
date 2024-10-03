import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';
import 'package:seconds_fi_app/utils/okto.dart';

class RawTransactioneExecutePage extends StatefulWidget {
  const RawTransactioneExecutePage({super.key});

  @override
  State<RawTransactioneExecutePage> createState() =>
      _RawTransactioneExecutePageState();
}

class _RawTransactioneExecutePageState
    extends State<RawTransactioneExecutePage> {
  final networkNameController = TextEditingController();
  final transactionObjectController = TextEditingController();
  Future<RawTransactionExecuteResponse>? _rawTransactionExecuted;
  Future<NetworkDetails>? _supportedNetworks;
  String? _selectedNetwork;

  Future<RawTransactionExecuteResponse> rawTransactionExecute() async {
    final transactionObject = jsonDecode(transactionObjectController.text);
    try {
      final orderHistory = await okto!.rawTransactionExecute(
          networkName: networkNameController.text,
          transaction: transactionObject);
      return orderHistory;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NetworkDetails> getSupportedNetworks() async {
    try {
      final supportedNetworks = await okto!.supportedNetworks();
      return supportedNetworks;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _supportedNetworks = getSupportedNetworks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 8, 12, 40),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(40),
              child: const Text(
                'Raw Transaction Execute',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
            FutureBuilder<NetworkDetails>(
              future: _supportedNetworks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasData) {
                  final supportedNetworks = snapshot.data!.data.network;
                  return DropdownButton<String>(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    isExpanded: true,
                    value: _selectedNetwork,
                    hint: const Text(
                      'Select a Network',
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: const Color.fromARGB(255, 11, 31, 48),
                    items: supportedNetworks.map((network) {
                      return DropdownMenuItem<String>(
                        value: network.networkName,
                        child: Text(
                          network.networkName,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedNetwork = value;
                      });
                    },
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: SizedBox(
                height: 200,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: null,
                  controller: transactionObjectController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    label: Text('Enter the transaction JSON for the network',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                setState(() {
                  _rawTransactionExecuted = rawTransactionExecute();
                });
              },
              child: const Text('Execute Raw Transaction'),
            ),
            Expanded(
              child: _rawTransactionExecuted == null
                  ? Container()
                  : FutureBuilder<RawTransactionExecuteResponse>(
                      future: _rawTransactionExecuted,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.white)));
                        } else if (snapshot.hasData) {
                          final transferNftResponse = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Job id: ${transferNftResponse.data.jobId}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              transferNftResponse.data.jobId));
                                    },
                                    child: const Text('Copy job id'))
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
