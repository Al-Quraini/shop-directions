import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_directs/cubit/scrroll/scroll_cubit.dart';
import 'package:shop_directs/dialogs/dialog_maker.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/main/components/item_card.dart';
import 'package:shop_directs/screens/main/components/my_items_card.dart';

import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/size_config.dart';

class MyItemsStream extends StatefulWidget {

  final Stream<QuerySnapshot> stream;
  final String des;


  MyItemsStream({@required this.stream,@required this.des});

  @override
  _MyItemsStreamState createState() => _MyItemsStreamState();
}

class _MyItemsStreamState extends State<MyItemsStream> {
  ScrollController _scrollController;
  double _scrollPosition,
      minValue = 0,
      maxValue = 0,
      difference = 0;
  bool hideAppbar = false;

  _scrollListener() {
    _scrollPosition = _scrollController.position.pixels;

    setValues();
  }

  void setValues() {
    if (_scrollPosition == 0) {
      maxValue = 0;
      minValue = 0;
    }
    if (maxValue < _scrollPosition) {
      maxValue = _scrollPosition;
      difference = maxValue + minValue;
      if (difference >= 200 && !hideAppbar) {
        hideAppbar = true;
        BlocProvider.of<ScrollCubit>(context).emitScrollDown();
      }
      //BlocProvider.of<ScrollCubit>(context).emitScrollDown();
    } else if (_scrollPosition < maxValue) {
      minValue = _scrollPosition;
      difference = minValue - maxValue;
      if (difference <= -100) {
        maxValue = _scrollPosition;
        hideAppbar = false;
        BlocProvider.of<ScrollCubit>(context).emitScrollUp();
      }
    }
  }


  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.stream,
      //FirebaseFirestoreClass().getItemsStream(),
      builder: (context, snapshot) {
        List<Item> items = [];
        if (snapshot.hasData) {
          items = FirebaseFirestoreRead().getListStream(snapshot);
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        return ListView.builder(
            itemCount: items.length,
            controller: _scrollController,
            itemBuilder: (context, index) =>
                Padding(
                  padding: EdgeInsets.symmetric(vertical: getProportionateSize(5)),
                  child: Slidable(
                    key: ValueKey(index),
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async{
                          bool deleted =false;
                           await DialogMaker(context: context,
                            onPress:
                                () async{
                              deleted = await FirebaseFirestoreWrite().deleteItem(
                                  docId: items[index].id);

                              if(deleted){
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Deleted successfully!'),
                                  duration: Duration(milliseconds: 500),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                              }

                                },
                          title: 'Delete',
                          content: 'Are you sure you want to delete ${items[index].title}?'

                            ).displayDialog();


                        },
                      ),
                    ],
                    actionExtentRatio: 0.25,
                    child: Container(
                        height: SizeConfig.screenHeight*0.18,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            // color:kActiveCardColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                //BoxShadow(color: Colors.red,spreadRadius: 3,blurRadius: 10),
                                BoxShadow(color: Colors.blueGrey,
                                    spreadRadius: getProportionateSize(3),
                                    blurRadius: getProportionateSize(15)),
                              ],
                              gradient: LinearGradient(
                                colors: [Colors.white70, Colors.white60],
                                stops: [0.2, 0.9],

                              )
                          ),
                          child: MyItemsCard(item: items[index],
                              press: () {
                                Navigator.pushNamed(context, widget.des,
                                    arguments: items[index]);
                              }
                            // arguments: items[index]
                          )),
                  ),
                ));
      },
    );
  }


}



    /*Padding(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding,
          horizontal: kDefaultPadding),
        child: GridView.builder(
            itemCount: categoriesList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: kDefaultPadding,
              crossAxisSpacing: kDefaultPadding,
              childAspectRatio: 0.75,

            ),
          itemBuilder: (context, index) => Text(categoriesList[index]),
          *//*  itemBuilder: (context, index) => ItemCard(
              product: SemanticsFlag.isTextField[index],*//*
              *//*press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      product: products[index],
                    ),
                  )),*//*
        ),

    );*/

