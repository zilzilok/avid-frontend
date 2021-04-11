import 'dart:io';

import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AvatarField extends StatefulWidget {
  final TextEditingController _imageController;
  final bool _network;

  const AvatarField({Key key, @required imageController, network = false})
      : _imageController = imageController,
        _network = network,
        super(key: key);

  @override
  _AvatarFieldState createState() =>
      _AvatarFieldState(this._imageController, this._network);
}

class _AvatarFieldState extends State<AvatarField> {
  TextEditingController _imageController;
  bool _network;

  _AvatarFieldState(this._imageController, this._network);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double imageRadius = size.width / 6;
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
          radius: imageRadius + 2,
          backgroundColor: kPrimaryLightColor,
          child: _imageController != null && _imageController.text.isNotEmpty
              ? _network
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(imageRadius),
                      child: Image.network(
                        _imageController.text,
                        width: 2 * imageRadius,
                        height: 2 * imageRadius,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(imageRadius),
                      child: Image.file(
                        File(_imageController.text),
                        width: 2 * imageRadius,
                        height: 2 * imageRadius,
                        fit: BoxFit.cover,
                      ),
                    )
              : Container(
                  decoration: BoxDecoration(
                    color: kLightGreyColor,
                    borderRadius: BorderRadius.circular(imageRadius),
                  ),
                  width: 2 * imageRadius,
                  height: 2 * imageRadius,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: Padding(
                          child: Text(
                            "выберите фотографию",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: kTextGreyColor),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(
                            CupertinoIcons.circle_fill,
                            size: imageRadius / 2,
                            color: kLightGreyColor,
                          )),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(
                            CupertinoIcons.add_circled,
                            size: imageRadius / 2,
                            color: kPrimaryLightColor,
                          )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        FontAwesomeIcons.images,
                        color: kPrimaryColor,
                      ),
                      title: Text(
                        'галерея',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: kTextGreyColor),
                      ),
                      onTap: () {
                        _imageFrom(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera, color: kPrimaryColor),
                    title: Text(
                      'камера',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: kTextGreyColor),
                    ),
                    onTap: () {
                      _imageFrom(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imageFrom(ImageSource imageSource) async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      setState(() {
        _imageController.text = file.path;
        _network = false;
      });
    }
  }
}
