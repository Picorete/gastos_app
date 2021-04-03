import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastos_app/constants.dart';
import 'package:gastos_app/domain/entities/transaction.dart';
import 'package:gastos_app/presentation/bloc/add/add_bloc.dart';
import 'package:gastos_app/presentation/widgets/header.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final focus = FocusNode();
  AddBloc _addBloc;

  @override
  void initState() {
    super.initState();
    this._addBloc = context.read<AddBloc>();
  }

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
              BlocListener<AddBloc, AddState>(
                listener: (context, state) async {
                  if (state.datePickerPanel.isOpen) {
                    final DateTime picked = await showDatePicker(
                        locale: const Locale("es", "ES"),
                        context: context,
                        initialDate: state.datePickerPanel.date,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101));
                    if (picked != null &&
                        picked != state.datePickerPanel.date) {
                      _addBloc.add(OnChangeTransactionDate(
                          transactionDate: picked.toString(),
                          pickerDate: picked));
                      _addBloc.add(OnChangeisOpenDatePicker(false));
                    }
                  }

                  if (state.error != null && state.error.isLeft()) {
                    // TODO: SHOW DIALIOG
                  }

                  if (state.success) {
                    _addBloc.add(OnResetState());
                    Navigator.pushNamed(context, 'home');
                  }
                },
                child: BlocBuilder<AddBloc, AddState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () => _addBloc.add(OnChangeisOpenDatePicker(true)),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        color: Color(0xFFF2F2F2),
                        child: Text(
                          DateFormat("EEEE dd LLLL")
                              .format(_addBloc.state.datePickerPanel.date),
                          style: kSubheadingextStyle,
                        ),
                      ),
                    );
                  },
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
                    BlocBuilder<AddBloc, AddState>(
                      builder: (context, state) {
                        return RaisedButton(
                          elevation: 0,
                          onPressed: () {
                            _addBloc.add(OnChangeTransactionType(true));
                          },
                          color:
                              state.transaction.type ? primary : textLightgray,
                          child: Text(
                            "Entrada",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<AddBloc, AddState>(
                      builder: (context, state) {
                        return RaisedButton(
                          elevation: 0,
                          onPressed: () {
                            _addBloc.add(OnChangeTransactionType(false));
                          },
                          color: !state.transaction.type
                              ? secondary
                              : textLightgray,
                          child: Text(
                            "Salida",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
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
                      onChanged: (string) =>
                          _addBloc.add(OnChangeTransactionDescription(string)),
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
                      onChanged: (string) => _addBloc
                          .add(OnChangeTransactionAmount(double.parse(string))),
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
                    BlocBuilder<AddBloc, AddState>(
                      builder: (context, state) {
                        return DropdownButton(
                          style: kTitleTextStyle,
                          value: state.transaction.category,
                          isExpanded: true,
                          onChanged: (value) =>
                              _addBloc.add(OnChangeTransactionCategory(value)),
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
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  onPressed: () => _addBloc.add(OnAddTransaction()),
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
}
