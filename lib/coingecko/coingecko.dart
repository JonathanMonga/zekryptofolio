import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/coin_history.dart';
import 'package:coingecko_api/data/market.dart';
import 'package:coingecko_api/data/market_chart_data.dart';
import 'package:coingecko_api/coingecko_api.dart';

class Coingecko {
  Coingecko._();
  static final Coingecko coingecko = Coingecko._();

  static final CoinGeckoApi _api = CoinGeckoApi();

  Future<List<Market>> fetchMarketData({List? coins}) async {
    String query = "";
    if (coins != null) {
      if (coins.isEmpty) return [];
      coins.asMap().forEach((index, coin) {
        query += coin!;
        if (index != coins.length - 1) query += ",";
      });
    } else {
      supportedCoins.asMap().forEach((index, coin) {
        query += coin["id"]!;
        if (index != supportedCoins.length - 1) query += ",";
      });
    }

    CoinGeckoResult<List<Market>> coinGeckoResult = await _api.coins
        .listCoinMarkets(coinIds: query.split(','), vsCurrency: "usd");

    if (!coinGeckoResult.isError) {
      return coinGeckoResult.data;
    }

    return [];
  }

  Future<List<MarketChartData>> getCoinHistory(String id, int days) async {
    CoinGeckoResult<List<MarketChartData>> coinGeckoResult = await _api.coins
        .getCoinMarketChart(id: id, days: days, vsCurrency: "usd");

    if (!coinGeckoResult.isError) {
      return coinGeckoResult.data;
    }

    return [];
  }

  Future<CoinHistory> getCoinAtDateTime(String id, DateTime date) async {
    CoinGeckoResult<CoinHistory?> coinGeckoResult =
        await _api.coins.getCoinHistory(id: id, date: date);

    return coinGeckoResult.data!;
  }
}

final supportedCoins = [
  {"id": "wrapped-bitcoin", "symbol": "wbtc", "name": "Wrapped Bitcoin"},
  {"id": "bitcoin", "symbol": "btc", "name": "Bitcoin"},
  {"id": "bitcoin-bep2", "symbol": "btcb", "name": "Bitcoin BEP2"},
  {"id": "ethereum", "symbol": "eth", "name": "Ethereum"},
  {"id": "binancecoin", "symbol": "bnb", "name": "Binance Coin"},
  {
    "id": "binance-peg-bitcoin-cash",
    "symbol": "bch",
    "name": "Binance-Peg Bitcoin Cash"
  },
  {"id": "elrond-erd-2", "symbol": "egld", "name": "Elrond"},
  {"id": "monero", "symbol": "xmr", "name": "Monero"},
  {"id": "solana", "symbol": "sol", "name": "Solana"},
  {
    "id": "binance-peg-litecoin",
    "symbol": "ltc",
    "name": "Binance-Peg Litecoin"
  },
  {"id": "axie-infinity", "symbol": "axs", "name": "Axie Infinity"},
  {"id": "avalanche-2", "symbol": "AVAX", "name": "Avalanche"},
  {"id": "terra-luna", "symbol": "luna", "name": "Terra"},
  {"id": "ftx-token", "symbol": "ftt", "name": "FTX Token"},
  {"id": "ethereum-classic", "symbol": "etc", "name": "Ethereum Classic"},
  {
    "id": "binance-peg-filecoin",
    "symbol": "fil",
    "name": "Binance-Peg Filecoin"
  },
  {"id": "helium", "symbol": "hnt", "name": "Helium"},
  {"id": "internet-computer", "symbol": "icp", "name": "Internet Computer"},
  {
    "id": "binance-peg-polkadot",
    "symbol": "dot",
    "name": "Binance-Peg Polkadot"
  },
  {"id": "cosmos", "symbol": "atom", "name": "Cosmos"},
];
