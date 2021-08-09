import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_directs/utils/size_config.dart';

import 'body.dart';

class PriceContainer extends StatefulWidget {
  final PriceCallback callback;

  const PriceContainer({Key key, this.callback}) : super(key: key);
  @override
  _PriceContainerState createState() => _PriceContainerState();
}

class _PriceContainerState extends State<PriceContainer> {
  TextEditingController _priceController;

  double price = 0;

  @override
  void initState() {
    _priceController =
        TextEditingController(text: price.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(5),
      child: ListTile(
        leading: GestureDetector(
          onTap: (){
            setState(() {
              price-5 >=0 ?
              price=price-5:
              price = 0;
              String text=price.toString();
              _priceController =
                  TextEditingController(text: text);
              widget.callback(price);
            });



          },
          child: Container(
            padding: EdgeInsets.all(getProportionateSize(10)),
            color: Color(0xffdeede6),
            child: Icon(FontAwesomeIcons.minus),
          ),
        ),
        title: TextField(
          keyboardType: TextInputType.number,
          autofocus: false,
          showCursor: false,
          onChanged: (value) {
            price = double.parse(value);
            widget.callback(price);
          },
          controller: _priceController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red,
                  width: getProportionateScreenWidth(5)),
            ),
              labelText: 'Set Price'
          ),

        ),
        trailing: GestureDetector(
          onTap: (){
            setState(() {
              price = price+5;
              _priceController =
                  TextEditingController(text: price.toString());
             widget.callback(price);
            });


          },
          child: Container(
            padding: EdgeInsets.all(getProportionateSize(10)),
            color: Color(0xffdeede6),
            child: Icon(FontAwesomeIcons.plus),
          ),
        ),
      ),
    );
  }
}
