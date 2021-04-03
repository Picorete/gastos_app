import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_app/constants.dart';
import 'package:gastos_app/presentation/bloc/add/add_bloc.dart';
import 'package:gastos_app/presentation/bloc/home/home_bloc.dart';
import 'package:gastos_app/presentation/pages/home.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'di/bloc_register.dart';
import 'di/repositories_register.dart';

void main() {
  RepositoriesRegister();
  BlocRegister();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'es_US';
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => Injector.appInstance.get<AddBloc>()),
        BlocProvider(create: (context) => Injector.appInstance.get<HomeBloc>())
      ],
      child: MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('es')],
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (_) => HomeScreen(),
        },
        theme: ThemeData(
            fontFamily: 'Future',
            primaryColor: primary,
            accentColor: secondary),
      ),
    );
  }
}
