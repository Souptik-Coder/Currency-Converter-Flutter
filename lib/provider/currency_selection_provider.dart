import 'package:currency_converter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CurrencyInputType { to, from }

class CurrencySelectionProvider extends ChangeNotifier {
  SharedPreferences? _prefs;

  CurrencySelectionProvider() {
    SharedPreferences.getInstance().then((pref) {
      _prefs = pref;

      // Refresh values from Shared Preferences rather than using default ones
      notifyListeners();
    });
  }

  String _amount = "";

  String get amount => _amount;

  String get selectedFromCurrency =>
      _prefs?.getString(fromCurrencyPrefName) ?? defaultFromCurrencyValue;

  String get selectedToCurrency =>
      _prefs?.getString(toCurrencyPrefName) ?? defaultToCurrencyValue;

  CurrencyInputType? updatingCurrencyType;

  set amount(String value) {
    if (value != _amount) {
      _amount = value;
      notifyListeners();
    }
  }

  set selectedFromCurrency(String value) {
    if (value != selectedFromCurrency) {
      _prefs
          ?.setString(fromCurrencyPrefName, value)
          .whenComplete(() => notifyListeners());
    }
  }

  set selectedToCurrency(String value) {
    if (value != selectedToCurrency) {
      _prefs
          ?.setString(toCurrencyPrefName, value)
          .whenComplete(() => notifyListeners());
    }
  }

  swapFromAndTo() {
    final temp = selectedFromCurrency;
    selectedFromCurrency = selectedToCurrency;
    selectedToCurrency = temp;
    notifyListeners();
  }

  updateSelectedCurrency(String currency) {
    if (updatingCurrencyType == CurrencyInputType.to) {
      selectedToCurrency = currency;
    } else {
      selectedFromCurrency = currency;
    }
  }
}
