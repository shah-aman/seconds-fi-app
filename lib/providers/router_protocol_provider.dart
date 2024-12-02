import 'package:flutter/foundation.dart';
import '../services/router_protocol_service.dart';

class RouterProtocolProvider extends ChangeNotifier {
  final RouterProtocolService _service = RouterProtocolService();
  Map<String, dynamic>? _currentQuote;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  String? get error => _error;
  RouterTransactionStatus? transactionStatus;
  Future<void> fetchQuote({
    required String fromTokenAddress,
    required String toTokenAddress,
    required String amount,
    required String fromTokenChainId,
    required String toTokenChainId,
    int? slippageTolerance,
    required int partnerId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentQuote = await _service.getQuote(
        fromTokenAddress: fromTokenAddress,
        toTokenAddress: toTokenAddress,
        amount: amount,
        fromTokenChainId: fromTokenChainId,
        toTokenChainId: toTokenChainId,
        slippageTolerance: slippageTolerance,
        partnerId: partnerId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // example quote request
  Future<void> exampleFetchQuote() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _currentQuote = await _service.exampleQuoteRequest();
      //print the quote
      debugPrint(_currentQuote.toString());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Example usage method
  Future<Map<String, dynamic>?> exampleNitroSwapRequest() async {
    try {
      final swapDetails = await _service.getSwapOnNitro(
        fromTokenAddress:
            '0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d', // USDC on BSC
        toTokenAddress:
            RouterProtocolService.getNativeTokenAddress(), // Native token
        amount: '1000000000000000000', // Amount in smallest unit
        fromTokenChainId: "56", // BSC
        toTokenChainId: "698", // Your destination chain
        refundAddress: "0x46c5a13490076cE77a285E9E38FA8818AC2915Aa",
        slippageTolerance: 2,
        destFuel: 0,
        partnerId: 1,
      );
      transactionStatus = RouterTransactionStatus.PENDING;
      return swapDetails;
    } catch (e) {
      print('Error getting Nitro swap details: $e');
      return null;
    }
  }

  // Nitro swap request
  Future<Map<String, dynamic>?> nitroSwapRequest({
    required String fromTokenAddress,
    required String toTokenAddress,
    required String amount,
    required String fromTokenChainId,
    required String toTokenChainId,
    required String refundAddress,
    int slippageTolerance = 2,
    int destFuel = 0,
    int partnerId = 1,
  }) async {
    final swapDetails = await _service.getSwapOnNitro(
      fromTokenAddress: fromTokenAddress,
      toTokenAddress: toTokenAddress,
      amount: amount,
      fromTokenChainId: fromTokenChainId,
      toTokenChainId: toTokenChainId,
      refundAddress: refundAddress,
      slippageTolerance: slippageTolerance,
      destFuel: destFuel,
      partnerId: partnerId,
    );
    return swapDetails;
  }

  // Example of how to use the polling mechanism
  // Example of how to use the polling mechanism
  void startStatusPolling(String depositAddress, String chainId) {
    RouterTransactionStatus txStatus = RouterTransactionStatus.PENDING;
    _service
        .pollTransactionStatus(
      depositAddress: depositAddress,
      chainId: chainId,
    )
        .listen(
      (status) {
        txStatus = status;
        switch (status) {
          case RouterTransactionStatus.PENDING:
            debugPrint('Transaction is pending...');

            break;
          case RouterTransactionStatus.SUCCESS:
            debugPrint('Transaction succeeded!');
            break;
          case RouterTransactionStatus.FAILED:
            debugPrint('Transaction failed');
            break;
          case RouterTransactionStatus.NOT_FOUND:
            debugPrint('Transaction not found');
            break;
          case RouterTransactionStatus.REVERTED:
            debugPrint('Transaction reverted');
            break;
          case RouterTransactionStatus.UNKNOWN:
            debugPrint('Unknown status');
            break;
        }
      },
      onError: (error) {
        transactionStatus = txStatus;
        notifyListeners();
        debugPrint('Error polling status: $error');
      },
      onDone: () {
        transactionStatus = txStatus;
        notifyListeners();
        debugPrint('Status polling completed');
      },
    );
  }
}
