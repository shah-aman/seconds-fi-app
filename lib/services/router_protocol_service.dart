import 'package:http/http.dart' as http;
import 'dart:convert';

// First, let's add the TransactionStatus enum
enum RouterTransactionStatus {
  PENDING, // Waiting for funds to be deposited
  SUCCESS, // Funds deposited, relaying in progress
  FAILED, // Simulation failed or transaction receipt failed
  NOT_FOUND, // No funds sent before address expiration
  REVERTED, // Transaction reverted
  UNKNOWN; // For handling any unexpected status

  static RouterTransactionStatus fromString(String status) {
    try {
      return RouterTransactionStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => RouterTransactionStatus.UNKNOWN,
      );
    } catch (_) {
      return RouterTransactionStatus.UNKNOWN;
    }
  }
}

class RouterProtocolService {
  static const String PATH_FINDER_API_URL =
      "https://k8-testnet-pf.routerchain.dev/api";

  Future<Map<String, dynamic>> getQuote({
    required String fromTokenAddress,
    required String toTokenAddress,
    required String amount,
    required String fromTokenChainId,
    required String toTokenChainId,
    int? slippageTolerance,
    int? partnerId,
  }) async {
    const endpoint = "v2/quote";

    // Build query parameters
    final queryParams = {
      'fromTokenAddress': fromTokenAddress,
      'toTokenAddress': toTokenAddress,
      'amount': amount,
      'fromTokenChainId': fromTokenChainId.toString(),
      'toTokenChainId': toTokenChainId.toString(),
    };

    // Add optional slippageTolerance if provided
    if (slippageTolerance != null) {
      queryParams['slippageTolerance'] = slippageTolerance.toString();
    }

    // Create URL with query parameters
    final quoteUrl = Uri.parse('$PATH_FINDER_API_URL/$endpoint')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        quoteUrl,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to get quote: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching quote from pathfinder: $e');
    }
  }

  // Helper method to handle native token address
  static String getNativeTokenAddress() {
    return "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee";
    //
  }

  // Example usage method
  Future<Map<String, dynamic>?> exampleQuoteRequest() async {
    try {
      final quote = await getQuote(
        fromTokenAddress:
            '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174', // USDC on Polygon
        toTokenAddress:
            'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v', // USDC on Fantom
        amount: '10000000', // 10 USDC (6 decimals)
        fromTokenChainId: "137", // Polygon
        toTokenChainId: "solana", // Fantom
        slippageTolerance: 2,
      );
      return quote;
    } catch (e) {
      print('Error getting quote: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getSwapOnNitro({
    required String fromTokenAddress,
    required String toTokenAddress,
    required String amount,
    required String fromTokenChainId,
    required String toTokenChainId,
    required String refundAddress,
    int? slippageTolerance,
    int? partnerId,
    int? destFuel,
  }) async {
    const baseUrl = "https://api.pay.routerprotocol.com";
    const endpoint = "swap-on-nitro";

    // Build query parameters
    final queryParams = {
      'fromTokenAddress': fromTokenAddress,
      'toTokenAddress': toTokenAddress,
      'amount': amount,
      'fromTokenChainId': fromTokenChainId,
      'toTokenChainId': toTokenChainId,
      'refundAddress': refundAddress,
      'destFuel': (destFuel ?? 0).toString(),
      'slippageTolerance': (slippageTolerance ?? 2).toString(),
      'partnerId': (partnerId ?? 1).toString(),
    };

    // Create URL with query parameters
    final nitroUrl =
        Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        nitroUrl,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to get Nitro swap details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching Nitro swap details: $e');
    }
  }

  Future<Map<String, dynamic>> getTransactionStatus({
    required String depositAddress,
    required String chainId,
    int limit = 20,
    int page = 1,
  }) async {
    const baseUrl = "https://api.pay.routerprotocol.com";
    const endpoint = "get-status-by-deposit-address";

    final queryParams = {
      'depositAddress': depositAddress,
      'chainId': chainId,
      'limit': limit.toString(),
      'page': page.toString(),
    };

    final statusUrl =
        Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        statusUrl,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to get status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching transaction status: $e');
    }
  }

  Stream<RouterTransactionStatus> pollTransactionStatus({
    required String depositAddress,
    required String chainId,
    Duration pollInterval = const Duration(minutes: 1),
  }) async* {
    bool shouldContinue = true;

    while (shouldContinue) {
      try {
        final statusResponse = await getTransactionStatus(
          depositAddress: depositAddress,
          chainId: chainId,
        );

        // Assuming the status is in the response as 'status' field
        // Adjust this according to the actual API response structure
        final status = RouterTransactionStatus.fromString(
            statusResponse['status'] as String);

        yield status;

        // Stop polling if we reach a final state
        if (status == RouterTransactionStatus.SUCCESS ||
            status == RouterTransactionStatus.FAILED ||
            status == RouterTransactionStatus.NOT_FOUND ||
            status == RouterTransactionStatus.REVERTED) {
          shouldContinue = false;
        }

        if (shouldContinue) {
          await Future.delayed(pollInterval);
        }
      } catch (e) {
        yield RouterTransactionStatus.UNKNOWN;
        await Future.delayed(pollInterval);
      }
    }
  }
}
