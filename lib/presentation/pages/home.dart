import 'dart:async';

import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastos_app/bloc/transactions.dart';

import 'package:gastos_app/constants.dart';
import 'package:gastos_app/domain/entities/transaction.dart';
import 'package:gastos_app/presentation/bloc/home/home_bloc.dart';
import 'package:gastos_app/presentation/widgets/header.dart';
import 'package:gastos_app/presentation/widgets/nav-drawer.dart';
import 'package:intl/intl.dart';

import 'package:rect_getter/rect_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../extensions.dart';
import 'add.dart';

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
  HomeBloc _homeBloc;
  final ScrollController _monthScrollController = new ScrollController();
  final List<GlobalKey> monthKeys = [
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
  ];
  void initState() {
    super.initState();
    _homeBloc = context.read<HomeBloc>();
    _homeBloc.add(InitTransactions());
  }

  final Duration animationDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 0);

  GlobalKey rectGetterKey = RectGetter.createGlobalKey(); //<--Create a key
  Rect rect;

  List<GlobalKey> monthsKeys = [];
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return Header(
                          subHeading: 'BALANCE TOTAL',
                          heading:
                              Text('${state.currency}${state.totalAmount}'),
                          rawButton: {
                            'activated': true,
                            'icon': Icon(Icons.menu,
                                color: Colors.white, size: 20.0),
                            'onPressed': () {
                              drawerKey.currentState.openDrawer();
                            },
                            'tag': 'whateverTag'
                          });
                    },
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return Container(
                          padding: EdgeInsets.only(left: 5),
                          child: SingleChildScrollView(
                            controller: _monthScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: createMonthsChips(),
                            ),
                          ));
                    },
                  ),
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
                            BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Entradas', style: kTitleTextStyle),
                                    Text('${state.currency}${state.totalInput}')
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                        Row(
                          children: [
                            BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Salidas', style: kTitleTextStyle),
                                    Text(
                                        '${state.currency}${state.totalOutput}')
                                  ],
                                );
                              },
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
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (BuildContext context, state) {
                        if (state.transactions.length == 0) {
                          return Container();
                        }

                        List<Widget> list = <Widget>[];
                        list.add(Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: RaisedButton(
                            onPressed: () {
                              _homeBloc.add(OnGetTransactions(state.activeMonth,
                                  category: 'todos'));
                            },
                            child: Text('Todos'),
                            color: (state.activeCategory == 'todos')
                                ? secondary
                                : primary,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ));
                        state.categories.forEach((element) {
                          list.add(Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: RaisedButton(
                              onPressed: () {
                                _homeBloc.add(OnGetTransactions(
                                    state.activeMonth,
                                    category: element));
                              },
                              child: Text(element),
                              color: (state.activeCategory == element)
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
                    child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (BuildContext context, state) {
                      if (state.busy)
                        return Center(child: CircularProgressIndicator());
                      if (state.transactions.length == 0)
                        return Center(
                          child: Text('No hay informacion'),
                        );

                      final transactions = state.transactions;
                      List<Widget> list = <Widget>[];

                      transactions.forEach((element) {
                        list.add(createTransaction(element));
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
    return Padding(
      key: monthKeys[monthInt - 1],
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: RaisedButton(
        onPressed: () {
          BlocProvider.of<HomeBloc>(context).add(OnGetTransactions(monthInt));
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
      return createChip(
          e,
          index,
          (index == BlocProvider.of<HomeBloc>(context).state.activeMonth)
              ? true
              : false);
    }).toList();

    return monthsChips;
  }

  Widget createTransaction(Transaction transaction) {
    DateTime dateParsed =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(transaction.date);
    final dateString =
        DateFormat("EEEE dd LLLL").format(dateParsed).capitalize();
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
                TextButton(
                    onPressed: () {
                      _homeBloc.add(OnDeleteTransaction(transaction));
                      Navigator.of(context).pop();
                    },
                    child: const Text("ELIMINAR")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("CANCELAR"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {},
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
                Text(transaction.description, style: kTitleTextStyle),
                Text(dateString, style: kSubtitleTextSyule)
              ],
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${state.currency}${transaction.amount}",
                        style: transaction.type
                            ? kTitleTextStylePrimary
                            : kSubtitleTextSytleScondary),
                    Text(transaction.category, style: kSubtitleTextSyule)
                  ],
                );
              },
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
    var jumpTo = 0.0;
    for (var i = 0; i < DateTime.now().month - 1; i++) {
      final monthChip =
          monthKeys[i].currentContext.findRenderObject() as RenderBox;
      jumpTo += monthChip.size.width;
    }
    _monthScrollController.jumpTo(jumpTo);
  }
}
