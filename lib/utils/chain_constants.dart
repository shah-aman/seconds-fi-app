enum Chain {
  ethereum(1),
  optimism(10),
  bnbChain(56),
  polygon(137),
  arbitrumOne(42161),
  avalanche(43114),
  base(8453),
  // Add other chains as needed

  // Testnets
  goerli(5),
  mumbai(80001),
  avalancheFuji(43113);

  final int chainId;
  const Chain(this.chainId);
}

enum TokenSymbol {
  usdt,
  usdc,
  eth,
  route,
  pepe,
  pikamon,
  shibaInu,
}

class ChainTokenAddress {
  static final Map<Chain, Map<TokenSymbol, String>> _tokenAddresses = {
    // Testnet addresses
    Chain.goerli: {
      TokenSymbol.usdt: '0x2227E4764be4c858E534405019488D9E5890Ff9E',
      TokenSymbol.usdc: '0x07865c6E87B9F70255377e024ace6630C1Eaa37F',
      TokenSymbol.eth: '0xb4fbf271143f4fbf7b91a5ded31805e42b2208d6',
      TokenSymbol.route: '0x8725bfdCB8896d86AA0a6342A7e83c1565f62889',
      TokenSymbol.pepe: '0x9bAA6b58bc1fAB3619f1387F27dCC18CbA5A9ca1',
      TokenSymbol.pikamon: '0x7085f7c56Ef19043874CA3F2eA781CDa788be5E4',
      TokenSymbol.shibaInu: '0xDC17183328e81b5c619D58F6B7E480AB1c2EA152',
    },
    Chain.mumbai: {
      TokenSymbol.usdt: '0x22bAA8b6cdd31a0C5D1035d6e72043f4Ce6aF054',
      TokenSymbol.eth: '0x3C6Bb231079c1023544265f8F26505bc5955C3df',
      TokenSymbol.route: '0x908aC4f83A93f3B7145f24f906327018c9e54B3a',
      TokenSymbol.pepe: '0xFee7De539Dd346189A33E954c8A140df95F94B89',
      TokenSymbol.pikamon: '0xa78044353cB8C675E905Ce7339769872Edd8E637',
      TokenSymbol.shibaInu: '0x418049cA499E9B5B983c9141c341E1aA489d6E4d',
    },
    Chain.avalancheFuji: {
      TokenSymbol.usdt: '0xb452b513552aa0B57c4b1C9372eFEa78024e5936',
      TokenSymbol.usdc: '0x5425890298aed601595a70ab815c96711a31bc65',
      TokenSymbol.eth: '0xce811501ae59c3E3e539D5B4234dD606E71A312e',
      TokenSymbol.route: '0x0b903E66b3A54f0F7DaE605418D14f0339560D76',
      TokenSymbol.pepe: '0x669365a664E41c3c3f245779f98118CF23a20789',
      TokenSymbol.pikamon: '0x00A7318DE94e698c3683db8f78dE881de4E5d18C',
      TokenSymbol.shibaInu: '0xB94EC038E5cF4739bE757dF3cBd2e1De897fCA2e',
    },
  };

  static String? getTokenAddress(Chain chain, TokenSymbol token) {
    return _tokenAddresses[chain]?[token];
  }

  static int getChainId(Chain chain) {
    return chain.chainId;
  }

  static List<TokenSymbol> getTokenSymbols(Chain chain) {
    return _tokenAddresses[chain]?.keys.toList() ?? [];
  }
}

// Extension method for easier access
extension ChainExtension on Chain {
  String? getTokenAddress(TokenSymbol token) {
    return ChainTokenAddress.getTokenAddress(this, token);
  }
}

// GET LIST OF SUPPORTED TOKENS FOR THE CHAIN
extension ChainTokenSymbols on Chain {
  List<TokenSymbol> getTokenSymbols() {
    return ChainTokenAddress.getTokenSymbols(this);
  }
}
