import 'package:avid_frontend/components/text_field_container.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenderField extends StatefulWidget {
  final TextEditingController genderController;

  const GenderField({Key key, this.genderController}) : super(key: key);

  @override
  _GenderFieldState createState() => _GenderFieldState(this.genderController);
}

class _GenderFieldState extends State<GenderField> {
  final TextEditingController genderController;
  int _genderId = 0;
  List<String> _genders = ["муж.", "жен."];

  _GenderFieldState(this.genderController);

  @override
  void initState() {
    genderController.text = _genders[_genderId];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: RadioListTile(
              value: 0,
              title: Text(
                _genders[0],
                style:
                    GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
              ),
              groupValue: _genderId,
              activeColor: kPrimaryColor,
              // tileColor: ,
              onChanged: (value) {
                setState(() {
                  _genderId = value;
                  genderController.text = _genders[_genderId];
                });
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: RadioListTile(
              value: 1,
              title: Text(
                _genders[1],
                style:
                    GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
              ),
              groupValue: _genderId,
              activeColor: kPrimaryColor,
              // tileColor: ,
              onChanged: (value) {
                setState(() {
                  _genderId = value;
                  genderController.text = _genders[_genderId];
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
