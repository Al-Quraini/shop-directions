import 'package:flutter/material.dart';
import 'package:shop_directs/screens/authentication_screens/registeration_screen.dart';
import 'package:shop_directs/utils/Constants.dart';



class BuildLocationRow extends StatelessWidget {
  final LocationCallback callback;
  final TextEditingController controller;


  BuildLocationRow({this.callback, this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.streetAddress,
        onChanged: callback,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.location_on,
              color: mainColor,
            ),
            labelText: 'Location'),
      ),
    );
  }
}
