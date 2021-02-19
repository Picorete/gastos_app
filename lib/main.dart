import 'package:flutter/material.dart';
import 'package:gastos_app/constants.dart';
import 'package:gastos_app/screens/home.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'es_US';
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('es')],
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
      },
      theme: ThemeData(
          fontFamily: 'Future', primaryColor: primary, accentColor: secondary),
    );
  }
}
