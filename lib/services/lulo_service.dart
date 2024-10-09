import 'package:solana/solana.dart';
import 'dart:typed_data';

// lulo_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class LuloService {
  final String apiKey;
  final String baseUrl = 'https://api.flexlend.fi';

  LuloService({required this.apiKey});

  Future<Ed25519HDPublicKey> getLuloUserAccountAddress(
      Ed25519HDPublicKey owner, Ed25519HDPublicKey programId) async {
    final seeds = [
      Uint8List.fromList('lulo'.codeUnits),
      owner.bytes,
    ];

    final address = await Ed25519HDPublicKey.findProgramAddress(
      seeds: seeds,
      programId: programId,
    );

    return address;
  }

  Map<String, String> _headers(String walletPubKey) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-wallet-pubkey': walletPubKey,
      'x-api-key': apiKey,
    };
  }

  Future<Map<String, dynamic>> getAccountInfo(String walletPubKey) async {
    final url = Uri.parse('$baseUrl/account');
    final response = await http.get(
      url,
      headers: _headers(walletPubKey),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch account info');
    }
  }

  Future<List<dynamic>> generateDepositTransaction({
    required String owner,
    required String mintAddress,
    required String depositAmount,
    required String walletPubKey,
    int priorityFee = 50000,
  }) async {
    final url =
        Uri.parse('$baseUrl/generate/account/deposit?priorityFee=$priorityFee');
    final body = json.encode({
      'owner': owner,
      'mintAddress': mintAddress,
      'depositAmount': depositAmount,
    });

    final response = await http.post(
      url,
      headers: _headers(walletPubKey),
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['transactionMeta'];
    } else {
      throw Exception('Failed to generate deposit transaction');
    }
  }
}
