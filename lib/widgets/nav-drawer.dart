import 'package:flutter/material.dart';
import 'package:gastos_app/constants.dart';
import 'package:gastos_app/screens/home.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NavDrawerClass extends StatefulWidget {
  @override
  _NavDrawerClassState createState() => _NavDrawerClassState();
}

class _NavDrawerClassState extends State<NavDrawerClass> {
  final inputController = TextEditingController();

  void initState() {
    super.initState();
    cargarMoneda();
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('moneda', inputController.text);
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

  void cargarMoneda() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    inputController.text = prefs.getString('moneda');
    if (inputController.text == null) {
      inputController.text = '\$';
    }
    setState(() {});
  }
}
