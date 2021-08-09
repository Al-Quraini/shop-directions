import 'package:flutter/material.dart';
import 'package:shop_directs/screens/profile_screen/profile_edit.dart';
import 'package:shop_directs/utils/Constants.dart';



class BuildPhoneRow extends StatelessWidget {
  final Function onChange;
  final TextEditingController controller;
  final PhoneNumberCallback callback;


  BuildPhoneRow({this.onChange, this.controller, this.callback});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        onChanged: callback,
        controller: controller,

        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: mainColor,
            ),
            labelText: 'Phone Number'),
      ),
    );
  }
}
