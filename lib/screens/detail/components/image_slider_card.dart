import 'package:flutter/material.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/utils/size_config.dart';

class ImageSliderCard extends StatelessWidget {
  final Item item;
  final int index;

  ImageSliderCard({this.item, this.index});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius:
      BorderRadius.circular(getProportionateSize(10))),
      child: Container(
          height: getProportionateScreenHeight(200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(getProportionateSize(10)),
            child: item !=null && item.images!= null &&
              item.images.isNotEmpty?
                imageHero():
            Image.network('https://lunawood.com/wp-content/'
                'uploads/2018/02/placeholder-image.png',
                fit: BoxFit.cover),
          )),
    );

  }

  Widget imageHero(){
    if(index ==0)
     return Hero(
          tag: item.id,
          child: Image.network(item.images[index], fit: BoxFit.cover));
    else return Image.network(item.images[index], fit: BoxFit.cover);
  }
}
