import 'package:flutter/material.dart';
import 'package:shop_directs/models/filter/filter_sort.dart';
import 'package:shop_directs/utils/size_config.dart';

class ChoiceChipWidget extends StatefulWidget {
  final List<FilterSortContent> sortList;
  final ValueChanged<FilterSortContent> selectedIndex;

  ChoiceChipWidget({this.sortList, this.selectedIndex});

  @override
  _ChoiceChipWidgetState createState() =>  _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    int index =0;
    for(FilterSortContent item in widget.sortList) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.filterSort),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: getProportionateSize(14), fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Color(0xffededed),
          selectedColor: Color(0xffffc107),
          selected: selectedChoice == item.filterSort,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item.filterSort;
            });
            widget.selectedIndex(item);
          },
        ),
      ));
      index++;
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
