import 'package:flutter/material.dart';
import 'package:gastos_app/constants.dart';

class Header extends StatelessWidget {
  final String subHeading;
  final Widget heading;
  Map rawButton = {};

  Header({this.subHeading, this.heading, this.rawButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1)),
          color: Colors.white),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.0,
          ),
          createRawButton(),
          SizedBox(
            height: 30.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              this.subHeading,
              style: kSubheadingextStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: this.heading,
          ),
        ],
      ),
    );
  }

  Widget createRawButton() {
    if (this.rawButton['activated']) {
      return Hero(
        tag: this.rawButton['tag'],
        child: RawMaterialButton(
            onPressed: this.rawButton['onPressed'],
            fillColor: primary,
            child: this.rawButton['icon'],
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder()),
      );
    } else {
      return Container();
    }
  }
}
