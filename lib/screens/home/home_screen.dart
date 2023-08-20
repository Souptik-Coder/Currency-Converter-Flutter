import 'package:currency_converter/models/rates_model.dart';
import 'package:currency_converter/widgets/currency_data_input_form.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter/services/fetch_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, String>> currenciesFuture;
  late Future<RatesModel> exchangeRatesFuture;
  late Future<List<Object>> allFutures;
  String selectedFromCurrency = "USD";
  String selectedToCurrency = "INR";
  String amount = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      currenciesFuture = getCurrencies();
      exchangeRatesFuture = getUSDToAnyExchangeRates();
      allFutures = Future.wait([currenciesFuture, exchangeRatesFuture]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: FutureBuilder(
          future: allFutures,
          builder: (ctx, AsyncSnapshot<List<Object>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var currencies = snapshot.data?[0] as Map<String, String>;
              var exchangeRates = snapshot.data?[1] as RatesModel;
              return Container(
                padding: const EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.white30, Colors.blue.shade50],
                    center: Alignment.topRight,
                    radius: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Currency Converter',
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Check live exchange rates and convert currencies',
                      ),
                      Card(
                        margin: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CurrencyDataInputForm(
                                title: 'Amount',
                                isInputEnabled: true,
                                selectedCurrency: selectedFromCurrency,
                                currencies: currencies,
                                onCurrencyChange: (currency) {
                                  setState(() {
                                    selectedFromCurrency = currency;
                                  });
                                },
                                onInputChanged: (val) {
                                  setState(() {
                                    amount = val;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 1.0,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  IconButton.filled(
                                    onPressed: () {
                                      setState(() {
                                        var temp = selectedFromCurrency;
                                        selectedFromCurrency =
                                            selectedToCurrency;
                                        selectedToCurrency = temp;
                                      });
                                    },
                                    icon: const Icon(Icons.swap_vert),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 1.0,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                              CurrencyDataInputForm(
                                title: 'Converted Amount',
                                isInputEnabled: false,
                                selectedCurrency: selectedToCurrency,
                                currencies: currencies,
                                val: convertAnyToAny(
                                    exchangeRates.rates,
                                    amount,
                                    selectedFromCurrency,
                                    selectedToCurrency),
                                onCurrencyChange: (currency) {
                                  setState(() {
                                    selectedToCurrency = currency;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '1 $selectedFromCurrency = ${convertAnyToAny(exchangeRates.rates, "1", selectedFromCurrency, selectedToCurrency)} $selectedToCurrency',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
