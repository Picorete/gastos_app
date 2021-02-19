import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastos_app/bloc/transactions.dart';

import 'package:gastos_app/constants.dart';
import 'package:gastos_app/models/transaction.dart';
import 'package:gastos_app/providers/db.dart';
import 'package:gastos_app/screens/add.dart';
import 'package:gastos_app/widgets/header.dart';
import 'package:gastos_app/widgets/nav-drawer.dart';
import 'package:intl/intl.dart';
import '../extensions.dart';

import 'package:rect_getter/rect_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

String moneda;

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    cargarMoneda();
  }

  final Duration animationDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 0);

  GlobalKey rectGetterKey = RectGetter.createGlobalKey(); //<--Create a key
  Rect rect;

  final transactionsBloc = new TransactionsBloc();
  int monthActive = DateTime.now().month;
  String activeCategory = 'todos';
  bool onlyOnce = false;
  List<GlobalKey> monthsKeys = [];
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    transactionsBloc.getTransactions(monthActive);
    transactionsBloc.getEntradasByMonth(monthActive, 1);
    transactionsBloc.getEntradasByMonth(monthActive, 0);
    transactionsBloc.getTotalByMonth(monthActive);

    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            key: drawerKey,
            drawer: NavDrawerClass(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Header(
                      subHeading: 'BALANCE TOTAL',
                      heading: StreamBuilder(
                        stream: transactionsBloc.totalStream,
                        builder: (BuildContext c, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return Text(
                                '$moneda${snapshot.data.toStringAsFixed(2)}',
                                style: kSubtitleTextSyule);
                          }
                        },
                      ),
                      rawButton: {
                        'activated': true,
                        'icon':
                            Icon(Icons.menu, color: Colors.white, size: 20.0),
                        'onPressed': () {
                          drawerKey.currentState.openDrawer();
                        },
                        'tag': 'whateverTag'
                      }),
                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: createMonthsChips(),
                          ))),
                  Container(
                    alignment: Alignment(-1.0, 0.0),
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'Selecciona un mes',
                      style: kSubtitleTextSyule,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width * 0.98,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: primary),
                              child: SvgPicture.asset(
                                  "assets/images/wallet_up.svg",
                                  width: 15.0,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Entradas', style: kTitleTextStyle),
                                StreamBuilder(
                                  stream: transactionsBloc.entradasStream,
                                  builder:
                                      (BuildContext c, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                          '$moneda${snapshot.data.toStringAsFixed(2)}',
                                          style: kSubtitleTextSyule);
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Salidas', style: kTitleTextStyle),
                                StreamBuilder(
                                  stream: transactionsBloc.salidasStream,
                                  builder:
                                      (BuildContext c, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                          '$moneda${snapshot.data.toStringAsFixed(2)}',
                                          style: kSubtitleTextSyule);
                                    }
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: secondary),
                              child: SvgPicture.asset(
                                  "assets/images/wallet_down.svg",
                                  width: 15.0,
                                  color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5.0),
                    alignment: Alignment.centerLeft,
                    child: StreamBuilder(
                      stream: transactionsBloc.categoriesStream,
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        List<Widget> list = new List<Widget>();
                        list.add(Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: RaisedButton(
                            onPressed: () {
                              transactionsBloc.getTransactions(monthActive);
                              activeCategory = 'todos';
                              setState(() {});
                            },
                            child: Text('Todos'),
                            color: (activeCategory == 'todos')
                                ? secondary
                                : primary,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ));
                        snapshot.data.forEach((element) {
                          list.add(Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: RaisedButton(
                              onPressed: () {
                                transactionsBloc.getTransactionsByCategory(
                                    monthActive,
                                    element['category'].toString());
                                activeCategory = element['category'].toString();
                                setState(() {});
                              },
                              child: Text(element['category'].toString()),
                              color: (activeCategory ==
                                      element['category'].toString())
                                  ? secondary
                                  : primary,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ));
                        });

                        return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: list,
                            ));
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: StreamBuilder(
                        stream: transactionsBloc.transactionStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TransactionModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final transactions = snapshot.data;

                          if (transactions.length == 0) {
                            return Center(
                              child: Text('No hay informacion'),
                            );
                          }
                          List<Widget> list = new List<Widget>();

                          transactions.forEach((element) {
                            DateTime date = DateFormat("yyyy-MM-dd hh:mm:ss")
                                .parse(element.date);

                            list.add(createTransaction(
                                id: element.id,
                                description: element.description,
                                amount: element.amount.toString(),
                                date: DateFormat("EEEE dd LLLL")
                                    .format(date)
                                    .capitalize(),
                                categorie: element.category,
                                type: element.type));
                          });

                          list.add(SizedBox(
                            height: 50.0,
                            width: double.infinity,
                          ));

                          return Column(
                            children: list,
                          );
                        }),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: RectGetter(
              key: rectGetterKey,
              child: FloatingActionButton(
                heroTag: "heroTag",
                onPressed: () {
                  setState(
                      () => rect = RectGetter.getRectFromKey(rectGetterKey));
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    //<-- on the next frame...
                    setState(() => rect = rect.inflate(1.3 *
                        MediaQuery.of(context)
                            .size
                            .longestSide)); //<-- set rect to be big
                    Future.delayed(animationDuration + delay,
                        _goToNextPage); //<-- after delay, go to next page
                  });
                },
                child: SvgPicture.asset(
                  "assets/images/add.svg",
                  width: 20.0,
                ),
                backgroundColor: primary,
                elevation: 0,
              ),
            ),
          ),
        ),
        _ripple()
      ],
    );
  }

  Widget createChip(String month, int monthInt, bool active) {
    final key = GlobalKey();
    monthsKeys.add(key);
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: RaisedButton(
        onPressed: () {
          monthActive = monthInt;

          setState(() {});
        },
        child: Text(month),
        color: !active ? primary : secondary,
        textColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  List<Widget> createMonthsChips() {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    final List<Widget> monthsChips = months.map((e) {
      int index = months.indexOf(e);
      index = index + 1;
      return createChip(e, index, (index == monthActive) ? true : false);
    }).toList();

    return monthsChips;
  }

  Widget createTransaction(
      {int id,
      String description,
      String date,
      bool type,
      String amount,
      String categorie}) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmacion"),
              content:
                  const Text("¿Seguro que deseas eliminar esta transaccion?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("ELIMINAR")),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCELAR"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        transactionsBloc.deleteTransactionByID(id);
        transactionsBloc.getTransactions(monthActive);
        transactionsBloc.getEntradasByMonth(monthActive, 1);
        transactionsBloc.getEntradasByMonth(monthActive, 0);
        transactionsBloc.getTotalByMonth(monthActive);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xFFDDDDDD)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: kTitleTextStyle),
                Text(date, style: kSubtitleTextSyule)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(type ? "+$moneda$amount" : "- $moneda$amount",
                    style: type
                        ? kTitleTextStylePrimary
                        : kSubtitleTextSytleScondary),
                Text(categorie, style: kSubtitleTextSyule)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      //<--replace Positioned with AnimatedPositioned
      duration: animationDuration, //<--specify the animation duration
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary,
        ),
      ),
    );
  }

  FutureOr _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: AddScreen()))
        .then((_) => setState(() => rect = null));
  }

  void afterBuild(context) {
    if (!onlyOnce) {
      Scrollable.ensureVisible(monthsKeys[monthActive - 1].currentContext);
      onlyOnce = true;
    }
  }

  void cargarMoneda() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    moneda = prefs.getString('moneda');
    if (moneda == null) {
      moneda = '\$';
    }
    setState(() {});
  }
}
