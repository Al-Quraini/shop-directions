import 'package:flutter/material.dart';
import 'package:shop_directs/screens/profile_screen/profile_edit.dart';
import 'package:shop_directs/utils/Constants.dart';



class BuildNameRow extends StatelessWidget {
  final Function onChange;
  final TextEditingController controller;
  final NameCallback callback;

  BuildNameRow({this.onChange, this.controller, this.callback});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: controller,
        onChanged: callback,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.drive_file_rename_outline,
              color: mainColor,
            ),
            labelText: 'Name'),
      ),
    );
  }
}
