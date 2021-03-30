import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileBackground extends StatelessWidget {
  final Widget child;

  const ProfileBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/main/backgrounds/profile_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: child,
      ),
    );
  }
}
