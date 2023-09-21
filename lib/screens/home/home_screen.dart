import 'package:currency_converter/provider/currency_selection_provider.dart';
import 'package:currency_converter/provider/currency_data_provider.dart';
import 'package:currency_converter/utils/utils.dart' as utils;
import 'package:currency_converter/widgets/currency_data_input_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../select_currency/select_currency_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CurrencyDataProvider>(context, listen: false).getAllData();
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<CurrencyDataProvider>();
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30.0),
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.white30, Colors.blue.shade50],
            center: Alignment.topLeft,
            radius: 1.0,
          )),
          child: Center(
            child: Builder(builder: (context) {
              if (data.isLoading) {
                return _buildLoading();
              } else if (data.errorMsg != null) {
                return _buildError(data.errorMsg!);
              } else {
                return _buildChild(data);
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(CurrencyDataProvider data) {
    var exchangeRates = data.exchangeRates;
    return Column(
      children: <Widget>[
        const Text(
          'Currency Converter',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Check live exchange rates and convert currencies',
        ),
        const SizedBox(height: 35.0),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 3.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Consumer<CurrencySelectionProvider>(
                  builder: (context, selections, child) =>
                      CurrencyDataInputForm(
                    title: 'Amount',
                    isInputEnabled: true,
                    selectedCurrency: selections.selectedFromCurrency,
                    onCurrencySelection: () {
                      Provider.of<CurrencySelectionProvider>(context,
                              listen: false)
                          .updatingCurrencyType = CurrencyInputType.from;
                      Navigator.pushNamed(
                        context,
                        SelectCurrencyScreen.route,
                      );
                    },
                    onInputChanged: (val) {
                      selections.amount = val;
                    },
                  ),
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
                        Provider.of<CurrencySelectionProvider>(context,
                                listen: false)
                            .swapFromAndTo();
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
                Consumer<CurrencySelectionProvider>(
                  builder: (context, selections, child) =>
                      CurrencyDataInputForm(
                    title: 'Converted Amount',
                    val: utils.convertAnyToAny(
                        exchangeRates,
                        selections.amount,
                        selections.selectedFromCurrency,
                        selections.selectedToCurrency),
                    isInputEnabled: false,
                    selectedCurrency: selections.selectedToCurrency,
                    onCurrencySelection: () {
                      Provider.of<CurrencySelectionProvider>(context,
                              listen: false)
                          .updatingCurrencyType = CurrencyInputType.to;
                      Navigator.pushNamed(
                        context,
                        SelectCurrencyScreen.route,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        const Text("Exchange Rates"),
        Consumer<CurrencySelectionProvider>(
          builder: (context, selections, child) {
            return Text(
              '1 ${selections.selectedFromCurrency} = ${utils.convertAnyToAny(exchangeRates, "1", selections.selectedFromCurrency, selections.selectedToCurrency)} ${selections.selectedToCurrency}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildLoading() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16.0),
        Text("Getting latest exchange rates")
      ],
    );
  }

  Widget _buildError(String errorMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          errorMsg,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () =>
              Provider.of<CurrencyDataProvider>(context, listen: false)
                  .getAllData(),
          child: const Text(
            "Retry",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
