import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBackground extends StatelessWidget {
  final Widget child;

  const SearchBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/main/backgrounds/search_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
        child: Align(
          alignment: FractionalOffset.topCenter,
          child: child,
        )
    );
  }
}
