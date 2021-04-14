import 'package:flutter/material.dart';

class FeedBackground extends StatelessWidget {
  final Widget child;

  const FeedBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/main/backgrounds/feed_bg.png"),
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
