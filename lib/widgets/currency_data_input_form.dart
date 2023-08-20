import 'package:flutter/material.dart';

class CurrencyDataInputForm extends StatefulWidget {
  const CurrencyDataInputForm(
      {super.key,
      required this.selectedCurrency,
      required this.currencies,
      this.val,
      required this.onCurrencyChange,
      required this.title,
      required this.isInputEnabled,
      this.onInputChanged});

  final String title;
  final bool isInputEnabled;
  final String selectedCurrency;
  final String? val;
  final Map<String, String> currencies;
  final void Function(String) onCurrencyChange;
  final void Function(String)? onInputChanged;

  @override
  State<CurrencyDataInputForm> createState() => _CurrencyDataInputFormState();
}

class _CurrencyDataInputFormState extends State<CurrencyDataInputForm> {
  @override
  Widget build(BuildContext context) {
    print("Building Form");
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
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
                  "https://www.countryflagicons.com/SHINY/64/${widget.selectedCurrency.substring(0, 2)}.png",
                  width: 64,
                  height: 64,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.selectedCurrency,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: const Icon(Icons.expand_more),
                    items: widget.currencies.keys
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(growable: false),
                    onChanged: (String? newValue) {
                      widget.onCurrencyChange(newValue!);
                    },
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: TextFormField(
                    key: ValueKey(widget.val),
                    initialValue: widget.val,
                    keyboardType: TextInputType.number,
                    readOnly: !widget.isInputEnabled,
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
                    onChanged: widget.onInputChanged,
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
