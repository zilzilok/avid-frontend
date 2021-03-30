import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  final Widget child;

  const WelcomeBackground({
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
                image: AssetImage("assets/images/auth/backgrounds/welcome_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomCenter, child: child)),
        ],
      ),
    );
  }
}
