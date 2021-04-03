import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_app/constants.dart';
import 'package:gastos_app/presentation/bloc/home/home_bloc.dart';
import 'package:gastos_app/presentation/pages/home.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NavDrawerClass extends StatefulWidget {
  @override
  _NavDrawerClassState createState() => _NavDrawerClassState();
}

class _NavDrawerClassState extends State<NavDrawerClass> {
  final inputController = TextEditingController();
  HomeBloc _homeBloc;
  void initState() {
    super.initState();
    this._homeBloc = BlocProvider.of<HomeBloc>(context);
    inputController.text = _homeBloc.state.currency;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Cambiar moneda de movimientos',
              style: kHeadingextStyle,
            ),
            TextFormField(
              controller: inputController,
              textAlign: TextAlign.center,
              style: kSubtitleTextSyule,
            ),
            RaisedButton(
              onPressed: () async {
                _homeBloc.add(OnSetCurrency(inputController.text));
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HomeScreen()));
              },
              color: primary,
              child: Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
