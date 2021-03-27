import 'dart:developer';

import 'package:avid_frontend/components/text_field_container.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final TextEditingController dateController;
  static final DateFormat DATE_FORMAT = DateFormat("dd.MM.yyyy");

  const DateField({Key key, this.dateController}) : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState(this.dateController);
}

class _DateFieldState extends State<DateField> {
  final TextEditingController dateController;

  _DateFieldState(this.dateController);

  @override
  void initState() {
    dateController.text = DateField.DATE_FORMAT.format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(color: kPrimaryLightColor, width: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(29))),
        ),
        onPressed: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(1900, 1, 1),
            maxTime: DateTime.now(),
            onChanged: (date) {
              log('change $date');
            },
            onConfirm: (date) {
              setState(() {
                dateController.text = DateField.DATE_FORMAT.format(date);
              });
              log('confirm $date');
            },
            currentTime: DateTime.now(),
            locale: LocaleType.ru,
          );
        },
        child: Text(
          dateController.text,
          style: GoogleFonts.montserrat(fontSize: 20, color: kTextGreyColor),
        ),
      ),
    );
  }
}
