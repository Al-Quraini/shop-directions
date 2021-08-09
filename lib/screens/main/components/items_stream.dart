import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_directs/cubit/scrroll/scroll_cubit.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/main/components/item_card.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/size_config.dart';

class ItemsStream extends StatefulWidget {

  final Stream<QuerySnapshot> stream;
  final String des;
  final Function function;


  ItemsStream({@required this.stream,@required this.des, this.function});

  @override
  _ItemsStreamState createState() => _ItemsStreamState();
}

class _ItemsStreamState extends State<ItemsStream> {
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
        return GridView.builder(
            itemCount: items.length,
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // mainAxisSpacing: kDefaultPadding,
              // crossAxisSpacing: kDefaultPadding,
              childAspectRatio: 0.8,

            ),
            itemBuilder: (context, index) {
              return Padding(
                    padding: EdgeInsets.all(getProportionateSize(10)),
                    child: Container(

                        padding: EdgeInsets.all(getProportionateSize(5)),
                        decoration: BoxDecoration(
                          // color:kActiveCardColor,
                            borderRadius: BorderRadius.all(Radius.circular(getProportionateSize(10))),
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
                        child: ItemCard(item: items[index],
                            press: () {
                            if(widget.function != null)
                                widget.function();

                            else
                              Navigator.pushNamed(context, widget.des,
                                  arguments: items[index]);
                            }
                          // arguments: items[index]
                        )));
            });
      },
    );
  }


}



