import 'dart:convert';
import 'package:okto_flutter_sdk/okto_flutter_sdk.dart';
import 'lulo_service.dart';

class LuloController {
  final LuloService luloService;
  final String walletPubKey;
  final Okto okto;

  LuloController({
    required this.luloService,
    required this.walletPubKey,
    required this.okto,
  });

  Future<void> deposit({
    required String owner,
    required String mintAddress,
    required String depositAmount,
  }) async {
    try {
      // Generate the deposit transaction from Lulo API
      List<dynamic> transactionMeta =
          await luloService.generateDepositTransaction(
        owner: owner,
        mintAddress: mintAddress,
        depositAmount: depositAmount,
        walletPubKey: walletPubKey,
      );

      // Iterate over each transaction meta
      for (var txMeta in transactionMeta) {
        String base64Tx = txMeta['transaction'];
        String protocol = txMeta['protocol'];

        // Prepare transaction object for Okto SDK
        Map<String, dynamic> transactionObject = {
          'transaction': base64Tx, // Assuming Okto SDK accepts base64 string
        };

        // Execute the transaction using Okto SDK
        final rawTransactionResponse = await okto.rawTransactionExecute(
          networkName: 'solana',
          transaction: transactionObject,
        );

        print(
            'Transaction sent for protocol $protocol with job id: ${rawTransactionResponse.data.jobId}');
      }
    } catch (e) {
      print('Error during deposit: $e');
    }
  }
}
