import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/ItemType.dart';
import 'package:shop_directs/models/filter/filter_category.dart';
import 'package:shop_directs/models/filter/filter_sort.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:intl/intl.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'package:shop_directs/widgets/rounded_button.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';

import 'filter_compontents/choice_chip_widget.dart';
import 'filter_compontents/filter_chip.dart';

// We need satefull widget for our categories

typedef void CategoryCallback(String selectedCategories);

class Filter extends StatefulWidget {

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  double minValue =0;
  double maxValue =10000;
  var formatter = NumberFormat('###,000');
  List<FilterSortContent> filterSortContent = [
    FilterSortContent(filterSort:'Any',filterKey: '',descending: false, isSelected: true),
    FilterSortContent(filterSort:'newest to oldest',filterKey: 'dateTime', descending: true),
    FilterSortContent(filterSort:'oldest to newest',filterKey: 'dateTime', descending: false),
    FilterSortContent(filterSort:'price high to low',filterKey: 'price', descending: true),
    FilterSortContent(filterSort:'price low to high', filterKey:'price', descending: false),
  ];


  List<String> selectedCategories =[];
  FilterSortContent selectedFilterSortContent;





  void setSelectedSort(FilterSortContent value){
    selectedFilterSortContent = value;
    print(value.filterSort);
  }

  void addToCategoriesList(ItemType category){
    selectedCategories.add(category.category);
    print(selectedCategories);
  }

  void removeFromCategoriesList(ItemType category){
    selectedCategories.remove(category.category);
    print(selectedCategories);

  }

  @override
  void initState() {
    selectedFilterSortContent=filterSortContent[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    RangeValues values = RangeValues(minValue, maxValue);

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(25),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getProportionateSize(20)),
              topRight: Radius.circular(getProportionateSize(20))
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    'Sort by',
                    style: TextStyle(color: Colors.black, fontSize: getProportionateSize(18)),
                  ),
                ),
              ),
              Container(
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: <Widget>[
                      ChoiceChipWidget(sortList: filterSortContent,
                      selectedIndex: setSelectedSort,),
                    ],
                  )),
              Divider(color: Colors.blueGrey, height:
              getProportionateScreenHeight(10),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    'Categories',
                    style: TextStyle(color: Colors.black, fontSize: getProportionateSize(18)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Align
                  (
                  alignment: Alignment.centerLeft,
                  child: Container(
                    // color: Colors.green,
                    //   height: 200,
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 3.0,
                        children: <Widget>[
                       for(ItemType category
                       in kCategoriesList)
                            FilterChipWidget(
                                category: category,
                                addToList: addToCategoriesList,
                                removeFromList: removeFromCategoriesList,
                            ),


                        ],
                      )
                  ),
                ),
              ),
              Divider(color: Colors.blueGrey, height: getProportionateScreenHeight(10),),


              SizedBox(height: getProportionateScreenHeight(20),),


              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Container(
                  width: 300,
                  child: RaisedButton(
                      color: Color(0xffffbf00),
                      child: new Text(
                        'Search',
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: getProportionateSize(18),
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: (){
                        BlocProvider.of<CounterCubit>(context)
                            .updateFilter(selectedFilterSortContent,
                            selectedCategories, minValue, maxValue);

                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getProportionateSize(30)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

