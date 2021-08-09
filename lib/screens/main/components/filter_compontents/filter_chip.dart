import 'package:flutter/material.dart';
import 'package:shop_directs/models/ItemType.dart';
import 'package:shop_directs/models/filter/filter_category.dart';
import 'package:shop_directs/utils/size_config.dart';


class FilterChipWidget extends StatefulWidget {
  final ItemType category;
  final ValueChanged<ItemType> addToList;
  final ValueChanged<ItemType> removeFromList;


  FilterChipWidget({Key key, this.category,this.addToList,this.removeFromList})
      : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(widget.category.icon
      ,color:widget.category.color ,),
      label: Text(widget.category.category),
      labelStyle: TextStyle(color: Color(0xff6200ee),fontSize: getProportionateSize(16),fontWeight: FontWeight.bold),
      selected: _isSelected,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            getProportionateSize(30)),),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
        if(_isSelected==true)
          widget.addToList(widget.category);
        else if(_isSelected==false)
          widget.removeFromList(widget.category);
      },
      selectedColor: Color(0xffeadffd),);
  }
}

