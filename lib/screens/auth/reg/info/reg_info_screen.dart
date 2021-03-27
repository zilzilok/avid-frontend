import 'package:avid_frontend/screens/auth/reg/info/components/reg_info_body.dart';
import 'package:flutter/material.dart';


class RegInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: RegInfoBody(),
      ),
    );
  }
}
