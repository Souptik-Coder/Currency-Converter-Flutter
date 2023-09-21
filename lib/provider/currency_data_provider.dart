import 'dart:core';
import 'dart:developer';

import 'package:currency_converter/models/Currency.dart';
import 'package:currency_converter/services/currency_services.dart';
import 'package:currency_converter/utils/api_result.dart';
import 'package:flutter/foundation.dart';

class CurrencyDataProvider extends ChangeNotifier {
  final _service = CurrencyServices();
  bool isLoading = false;
  String? errorMsg;

  Map<String, double> _exchangeRates = Map.fromIterable(const Iterable.empty());
  List<Currency> _currencies = List.empty();

  List<Currency> filteredCurrencies = List.empty();

  List<Currency> get currencies => _currencies;

  Map<String, double> get exchangeRates => _exchangeRates;

  getAllData() async {
    errorMsg = null;
    isLoading = true;
    notifyListeners();

    await _getAllCurrencies();
    await _getAllRates();

    isLoading = false;
    notifyListeners();
  }

  _getAllCurrencies() async {
    final response = await _service.getCurrencies();
    if (response is ApiResultSuccess) {
      _currencies = List.from(response.data!);
      filteredCurrencies = List.from(response.data!);
    } else if (response is ApiResultFailure) {
      errorMsg = response.message!;
      log(response.message!);
    }
  }

  _getAllRates() async {
    final response = await _service.getUSDToAnyExchangeRates();
    if (response is ApiResultSuccess) {
      _exchangeRates = response.data!.rates;
    } else if (response is ApiResultFailure) {
      errorMsg = response.message!;
      log(response.message!);
    }
  }

  updateFilteredCurrencies(String searchQuery) {
    filteredCurrencies.clear();
    filteredCurrencies.addAll(_currencies);
    if (searchQuery.isNotEmpty) {
      filteredCurrencies.removeWhere((currency) =>
          !currency.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
          !currency.shortName
              .toLowerCase()
              .startsWith(searchQuery.toLowerCase()));
    }
    notifyListeners();
  }

  resetFilteredList() {
    filteredCurrencies.clear();
    filteredCurrencies.addAll(_currencies);
  }
}
