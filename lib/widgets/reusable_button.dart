import 'package:flutter/material.dart';
import 'package:shop_directs/utils/size_config.dart';

class ReusableButton extends StatelessWidget {

  ReusableButton({
    @required this.title,
    @required this.color,
    this.onPress, this.icon, this.width});

  final String title;
  final Color color;
  final IconData icon;
  final Function onPress;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateSize(10)),
      child: Material(
        color: color,
        elevation: 10,
        borderRadius: BorderRadius.circular(getProportionateSize(10)),
        child: MaterialButton(
          height: 42.0,
          minWidth: width,
          onPressed: onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white54,),
              SizedBox(width: getProportionateScreenWidth(10),),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
