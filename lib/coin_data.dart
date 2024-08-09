import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '501DF257-836A-4273-8CEB-5974831EB376';
const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

Map<String, double> cryptoPrices = {};

class CoinData {
  String currency;
  CoinData({required this.currency});
  Future<Map<String, double>> getCoinData() async {
    for (String crypto in cryptoList) {
      http.Response response = await http
          .get(Uri.parse('$coinApiUrl/$crypto/$currency?apikey=$apiKey'));
      if (response.statusCode == 200) {
        String data = response.body;
        var dataBeta = jsonDecode(data);
        cryptoPrices[crypto] = dataBeta['rate'];
      } else {
        print(response.statusCode);
      }
    }
    return cryptoPrices;
  }
}
