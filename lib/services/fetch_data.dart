import 'dart:convert';

import 'package:currency_converter/models/rates_model.dart';
import 'package:http/http.dart' as http;
import 'package:currency_converter/models/all_currencies_response.dart';

Future<Map<String, String>> getCurrencies() async {
  var response = await http.get(Uri.https(
      "openexchangerates.org", "/api/currencies.json", {
    "prettyprint": "false",
    "show_alternative": "false",
    "show_inactive": "false"
  }));
  print(response.body);
  return allCurrenciesFromJson(response.body);
}

Future<RatesModel> getUSDToAnyExchangeRates() async {
  var response =
      await http.get(Uri.https("openexchangerates.org", "/api/latest.json", {
    "prettyprint": "false",
    "show_alternative": "false",
    "show_inactive": "false",
    "app_id": "a64906f3a2964ab7b471a777a30e07d8"
  }));
  print(response.body);
  return RatesModel.fromJson(jsonDecode(response.body));
}

String convertAnyToAny(
    Map exchangeRates, String amount, String fromCurrency, String toCurrency) {
  var doubleVal = double.tryParse(amount);
  if (doubleVal == null) return "";
  String output =
      (doubleVal / exchangeRates[fromCurrency] * exchangeRates[toCurrency])
          .toStringAsFixed(2);
  return output;
}
