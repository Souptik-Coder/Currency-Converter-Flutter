import 'package:currency_converter/provider/currency_selection_provider.dart';
import 'package:currency_converter/provider/currency_data_provider.dart';
import 'package:currency_converter/screens/home/home_screen.dart';
import 'package:currency_converter/screens/select_currency/select_currency_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrencyDataProvider()),
        ChangeNotifierProvider(
          create: (context) => CurrencySelectionProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (context) => const HomeScreen(),
        SelectCurrencyScreen.route: (context) => const SelectCurrencyScreen()
      },
    );
  }
}
