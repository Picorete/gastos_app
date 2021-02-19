import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastos_app/bloc/transactions.dart';
import 'package:gastos_app/constants.dart';
import 'package:gastos_app/models/transaction.dart';
import 'package:gastos_app/providers/db.dart';
import 'package:gastos_app/widgets/header.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final transactionsBloc = new TransactionsBloc();
  DateTime selectedDate = DateTime.now();
  String selectedDateString = DateFormat("EEEE dd LLLL").format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        locale: const Locale("es", "ES"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      transaction.date = picked.toString();
      setState(() {
        selectedDateString = DateFormat("EEEE dd LLLL").format(picked);
      });
    }
  }

  TransactionModel transaction =
      new TransactionModel(type: false, date: DateTime.now().toString());
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                subHeading: "TRANSACCIONES",
                heading: Text(
                  'AÑADIR',
                  style: kHeadingextStyle,
                ),
                rawButton: {
                  'activated': true,
                  'icon': SvgPicture.asset(
                    "assets/images/cancel.svg",
                    width: 20.0,
                  ),
                  'onPressed': () {
                    Navigator.pop(context);
                  },
                  'tag': 'null'
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Color(0xFFF2F2F2),
                  child: Text(
                    selectedDateString,
                    style: kSubheadingextStyle,
                  ),
                ),
              ),
              Container(
                color: Color(0xFFF9F9F9),
                height: 10,
              ),
              Container(
                color: Color(0xFFF9F9F9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        transaction.type = true;
                        setState(() {});
                      },
                      color: transaction.type ? primary : textLightgray,
                      child: Text(
                        "Entrada",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        transaction.type = false;
                        setState(() {});
                      },
                      color: !transaction.type ? secondary : textLightgray,
                      child: Text(
                        "Salida",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Color(0xFFF9F9F9),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripcion',
                      style: kSubtitleTextSyule,
                    ),
                    TextFormField(
                      onChanged: (string) => {transaction.description = string},
                      style: kHeadingextStyle,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Pizza'),
                    )
                  ],
                ),
              ),
              Container(
                color: Color(0xFFF9F9F9),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cantidad',
                      style: kSubtitleTextSyule,
                    ),
                    TextFormField(
                      focusNode: focus,
                      onChanged: (string) =>
                          {transaction.amount = double.parse(string)},
                      style: kHeadingextStyle,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: '2.54'),
                    )
                  ],
                ),
              ),
              Container(
                color: Color(0xFFF9F9F9),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categoria',
                      style: kSubtitleTextSyule,
                    ),
                    DropdownButton(
                      style: kTitleTextStyle,
                      value: transaction.category,
                      isExpanded: true,
                      onChanged: (value) {
                        transaction.category = value;
                        setState(() {});
                      },
                      items: [
                        'Factura',
                        'Suscripcion',
                        'Entretenimiento',
                        'Comida & Bebida',
                        'Expensa',
                        'Salud & Bienestar',
                        'Compras',
                        'Transporte',
                        'Viajes',
                        'Negocios',
                        'Regalos',
                        'Otros'
                      ].map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  onPressed: () => addTransaction(context),
                  color: primary,
                  child: Text(
                    "Agregar",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addTransaction(context) async {
    if (transaction.description == null ||
        transaction.amount == null ||
        transaction.category == null) {
      return showDialog(
        context: context,
        builder: (context) => Dialog(
          elevation: 0,
          child: Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(Icons.cancel, color: secondary),
                Text('Todos los valores son requeridos',
                    style: TextStyle(color: secondary, fontSize: 20)),
              ],
            ),
          ),
        ),
      );
    }

    try {
      await DBProvider.db.insertTransaction(transaction);
      transactionsBloc.getTransactions(DateTime.now().month);
      transactionsBloc.getEntradasByMonth(DateTime.now().month, 1);
      transactionsBloc.getEntradasByMonth(DateTime.now().month, 0);
      transactionsBloc.getTotalByMonth(DateTime.now().month);
      Navigator.pop(context);
    } catch (e) {
      return showDialog(
        context: context,
        builder: (context) => Dialog(
          elevation: 0,
          child: Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(Icons.cancel, color: secondary),
                Text('Parece algo salio mal... Intenta nuevamente',
                    style: TextStyle(color: secondary, fontSize: 20)),
              ],
            ),
          ),
        ),
      );
    }
  }
}
