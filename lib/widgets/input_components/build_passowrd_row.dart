import 'package:flutter/material.dart';
import 'package:shop_directs/utils/Constants.dart';



class BuildPasswordRow extends StatelessWidget {
  final Function onChange;

  BuildPasswordRow({this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        onChanged: onChange,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: mainColor,
          ),
          labelText: 'Password',
        ),
      ),
    );
  }
}
