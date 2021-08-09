
import 'package:flutter/material.dart';

class DialogMaker {
  final BuildContext context;
  final String title;
  final String content;
  final Function onPress;

  DialogMaker({
    @required this.context,
    this.title,
    this.content,
    this.onPress
  });

  Future<Widget> displayDialog(){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
            child: Text("CANCEL"),
          ),
          FlatButton(
            onPressed: (){
              Navigator.of(ctx).pop();
              onPress();

              },
            child: Text("YES",
            style: TextStyle(
              color: Colors.red
            ),),
          ),
        ],
      ),
    );
  }


}