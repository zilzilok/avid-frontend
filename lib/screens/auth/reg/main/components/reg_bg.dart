import 'package:flutter/material.dart';

class RegBackground extends StatelessWidget {
  final Widget child;

  const RegBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/reg_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Align(
                  alignment: FractionalOffset.bottomCenter, child: child)),
        ],
      ),
    );
  }
}
