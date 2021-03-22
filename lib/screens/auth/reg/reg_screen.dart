import 'package:avid_frontend/screens/auth/reg/components/reg_body.dart';
import 'package:flutter/material.dart';

class RegScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RegBody(),
      ),
    );
  }
}