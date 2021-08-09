import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_directs/models/ItemType.dart';


const kTextFieldDecoration =InputDecoration(

  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.deepPurple, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);


const kTextFieldPriceDecoration =InputDecoration(

  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    //borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.deepPurple, width: 1.0),
    //borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
   // borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);



const kBottomContainerHeight = 80.0;
const kActiveCardColor =Color(0xff1d1e33);
const kInActiveCardColor =Color(0xff111328);
const kTextColor = Color(0xFF535353);
const kAppbarColor = Color(0xFFb2c1c0);
const kTextLightColor = Color(0xFF5f6e75);
const mainColor = Color(0xff2470c7);
const kBottomContainerColor =Color(0xffeb1555);

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;



const kLargeButtonText =TextStyle(
    fontSize: 25.0,
    color: Colors.white,
);


const List<ItemType> kCategoriesList =[
  const ItemType(category: 'Vehicles', icon: FontAwesomeIcons.car, color: Colors.greenAccent),
  const ItemType(category: 'Housing', icon: FontAwesomeIcons.home, color: Colors.redAccent),
  const ItemType(category: 'Phones', icon: FontAwesomeIcons.mobileAlt,color: Colors.amberAccent),
  const ItemType(category: 'Electronic Devices ', icon: FontAwesomeIcons.desktop, color: Colors.blueAccent),
  const ItemType(category: 'Food ', icon: FontAwesomeIcons.utensils,color: Colors.orangeAccent),
  const ItemType(category: 'Toys & Games ', icon: FontAwesomeIcons.gamepad, color: Colors.purpleAccent),
  const ItemType(category: 'Sport ', icon: FontAwesomeIcons.running,color: Colors.lime),
  const ItemType(category: 'Books ', icon: FontAwesomeIcons.book,color: Color(0xffa0d6d5)),
];


const List<String> kCategoriesLists =[
  'ELECTRONICS', 'FOOD', 'BOOKS', 'SPORT', 'TOYS & GAMES', 'CARS'
];


