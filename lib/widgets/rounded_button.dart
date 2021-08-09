import 'package:flutter/material.dart';
import 'package:shop_directs/utils/size_config.dart';

class RoundedButton extends StatelessWidget {

  RoundedButton({
    @required this.title,
    @required this.color,
    this.onPress});

  final String title;
  final Color color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateSize(16)),
      child: Material(
        color: color,
        elevation: 10,
        borderRadius: BorderRadius.circular(getProportionateSize(30)),
        child: MaterialButton(
          height: getProportionateScreenHeight(42.0),
          minWidth: getProportionateScreenWidth(200),
          onPressed: onPress,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
