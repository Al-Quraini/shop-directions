import 'package:flutter/material.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/ItemType.dart';

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    Key key,
    @required this.item,
    @required this.category,
  }) : super(key: key);

  final Item item;
  final ItemType category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:32.0
          ,vertical: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[


          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star_half_rounded,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                    Text.rich(TextSpan(children: [
                      WidgetSpan(
                          child: Icon(Icons.location_on, size: 16.0, color: Colors.grey,)
                      ),
                      TextSpan(
                          text: "within 100 meters"
                      )
                    ]), style: TextStyle(color: Colors.grey, fontSize: 12.0),)
                  ],
                ),
              ),
              Text("\$ ${item.price}", style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),)
            ],
          ),
          SizedBox(height: 20.0),
          Text(item.title, style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24.0
          ),),
          SizedBox(height: 30.0),
          Text("Description".toUpperCase(), style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0
          ),),
          SizedBox(height: 10.0),
          Text(item.description
            , textAlign: TextAlign.justify, style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14.0
            ),),
          SizedBox(height: 30.0),
          Text("Category".toUpperCase(), style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0
          ),),
          SizedBox(height: 10.0),
          Card( //                           <-- Card widget
            child: ListTile(
                leading: Icon(category.icon,
                  color: category.color,
                ),
                title: Text(category.category)
            ),
          ),

          SizedBox(height: 40.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(item.date
                , textAlign: TextAlign.justify, style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14.0
                ),)
            ],
          ),



        ],
      ),
    );
  }
}