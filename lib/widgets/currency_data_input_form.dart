import 'package:flutter/material.dart';

class CurrencyDataInputForm extends StatelessWidget {
  const CurrencyDataInputForm({
    super.key,
    required this.selectedCurrency,
    this.val,
    required this.onCurrencySelection,
    required this.title,
    required this.isInputEnabled,
    this.onInputChanged,
  });

  final String title;
  final bool isInputEnabled;
  final String selectedCurrency;
  final String? val;
  final void Function() onCurrencySelection;
  final void Function(String)? onInputChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Image.network(
                "https://www.countryflagicons.com/SHINY/64/${selectedCurrency.substring(0, 2)}.png",
                width: 64,
                height: 64,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.currency_exchange,
                  size: 64,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(4.0),
                child: Row(
                  children: [
                    Text(
                      selectedCurrency,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(Icons.expand_more)
                  ],
                ),
                onTap: () {
                  onCurrencySelection();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: TextFormField(
                    key: ValueKey(val),
                    initialValue: val,
                    keyboardType: TextInputType.number,
                    readOnly: !isInputEnabled,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    onChanged: onInputChanged,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
