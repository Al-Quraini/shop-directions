import 'package:flutter/material.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/utils/size_config.dart';

class Dots extends StatefulWidget {
  const Dots({
    Key key,
    @required this.item,
    @required int current,
  }) : _current = current, super(key: key);

  final Item item;
  final int _current;

  @override
  _DotsState createState() => _DotsState();
}

class _DotsState extends State<Dots> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.item.images.map((url) {
        int index = widget.item.images.indexOf(url);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: getProportionateSize(10),
              horizontal: getProportionateSize(2)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget._current == index
                ? Color.fromRGBO(0, 0, 0, 0.9)
                : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        );
      }).toList(),
    );
  }
}
