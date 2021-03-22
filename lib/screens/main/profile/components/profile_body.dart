
import 'package:avid_frontend/components/rounded_button.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ProfileBody extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return SingleChildScrollView(
  //     child: Column(
  //       verticalDirection: VerticalDirection.down,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         SizedBox(height: size.height * 0.02),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Flexible(
  //               flex: 1,
  //               child: Container(
  //                 margin: EdgeInsets.only(left: 10, right: 10),
  //                 child: Column(
  //                   children: [
  //                     ImageButton(
  //                       margin: EdgeInsets.only(bottom: 5),
  //                       label: "Друзья",
  //                       icon: Icons.accessibility_new,
  //                       onPressed: () {},
  //                     ),
  //                     ImageButton(
  //                       margin: EdgeInsets.only(top: 5),
  //                       label: "Мои настолки",
  //                       icon: Icons.videogame_asset_rounded,
  //                       onPressed: () {},
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Flexible(
  //               flex: 1,
  //               child: CircleNetworkImage(
  //                 src:
  //                     "https://sun9-14.userapi.com/impg/eGMAL214yWu74DwgpRKDl-AFqnWsbpMJZhVvXQ/xiRSCpCrGwE.jpg?size=2560x1920&quality=96&sign=f044137362a4ce8eb6db0716a695adf8&type=album",
  //               ),
  //             ),
  //             Flexible(
  //               flex: 1,
  //               child: Container(
  //                 margin: EdgeInsets.only(left: 10, right: 10),
  //                 child: Column(
  //                   children: [
  //                     ImageButton(
  //                       margin: EdgeInsets.only(bottom: 5),
  //                       label: "Редактировать",
  //                       icon: Icons.sticky_note_2_rounded,
  //                       onPressed: () {},
  //                     ),
  //                     ImageButton(
  //                       margin: EdgeInsets.only(top: 5),
  //                       label: "Настройки",
  //                       icon: Icons.settings,
  //                       onPressed: () {},
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         ProfileInfo(),
  //         SizedBox(height: size.height * 0.05),
  //         SingleChildScrollView(
  //             child: Column(
  //           children: [
  //             Align(
  //               child: Container(
  //                 margin: EdgeInsets.only(left: 10),
  //                 child: Text("Последние действия:"),
  //               ),
  //               alignment: Alignment.centerLeft,
  //             ),
  //           ],
  //         ))
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RoundedButton(
        text: "Выйти из аккаунта",
        onPressed: () {
          AuthUtils.deleteJwt();
          Phoenix.rebirth(context);
        },
      ),
    );
  }
}
