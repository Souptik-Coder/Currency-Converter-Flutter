import 'package:currency_converter/provider/currency_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/currency_selection_provider.dart';

class SelectCurrencyScreen extends StatefulWidget {
  const SelectCurrencyScreen({super.key});

  static const String route = 'select-currency';

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CurrencyDataProvider>(context, listen: false)
        .resetFilteredList();
  }

  @override
  Widget build(BuildContext context) {
    var currencies = context.watch<CurrencyDataProvider>().filteredCurrencies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select currency'),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            children: [
              SearchBar(
                elevation: const MaterialStatePropertyAll(1),
                leading: const Icon(Icons.search),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 10.0),
                ),
                hintText: 'Search currency',
                onChanged: (value) {
                  Provider.of<CurrencyDataProvider>(context, listen: false)
                      .updateFilteredCurrencies(value);
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: currencies.length,
                    itemBuilder: (context, index) {
                      final currency = currencies[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        child: InkWell(
                          onTap: () {
                            Provider.of<CurrencySelectionProvider>(context,
                                    listen: false)
                                .updateSelectedCurrency(currency.shortName);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  "https://www.countryflagicons.com/SHINY/64/${currency.shortName.substring(0, 2)}.png",
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                          size: 50,
                                          Icons.currency_exchange_sharp),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    currency.name,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Text(
                                    currency.shortName,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
