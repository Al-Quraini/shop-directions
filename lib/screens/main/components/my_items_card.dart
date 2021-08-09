import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/size_config.dart';


class MyItemsCard extends StatefulWidget {
  final Item item;
  final Function press;
  const MyItemsCard({
    Key key,
    this.item,
    this.press,
  }) : super(key: key);

  @override
  _MyItemsCardState createState() => _MyItemsCardState();
}

class _MyItemsCardState extends State<MyItemsCard> {
  bool liked =false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(

              borderRadius: BorderRadius.all(
                  Radius.circular(getProportionateSize(10)))
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateSize(50)),
              height: 100,
              width: 100,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(width: 1),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:widget.item.images != null && widget.item.images.isNotEmpty?
                  NetworkImage(widget.item.images[0]):
                  NetworkImage('https://lunawood.com/wp-content/'
                      'uploads/2018/02/placeholder-image.png',
                  ),
                )
              ),

            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                  child: Text(
                    // products is out demo list
                    widget.item.title,
                    style: TextStyle(color: kTextLightColor),
                  ),
                ),
                Text(
                  "\$${widget.item.price}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
