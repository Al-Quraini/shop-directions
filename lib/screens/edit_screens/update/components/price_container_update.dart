import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_directs/utils/size_config.dart';

import 'body_update.dart';

class PriceContainer extends StatefulWidget {
  final PriceCallback callback;
  final double price;

  const PriceContainer({Key key, this.callback, this.price}) : super(key: key);
  @override
  _PriceContainerState createState() => _PriceContainerState();
}

class _PriceContainerState extends State<PriceContainer> {
  TextEditingController _priceController;

  double price;

  @override
  void initState() {
    price = widget.price;
    widget.callback(price);
    price=widget.price;
    _priceController =
        TextEditingController(text: price.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(getProportionateSize(5)),
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
