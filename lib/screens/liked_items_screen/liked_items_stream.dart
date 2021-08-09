import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';
import 'package:shop_directs/cubit/scrroll/scroll_cubit.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/detail/detail_page.dart';
import 'package:shop_directs/screens/main/components/item_card.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/size_config.dart';

class LikedItemsStream extends StatefulWidget {
  final List<String> docIds;

  LikedItemsStream({this.docIds});

  @override
  _LikedItemsStreamState createState() => _LikedItemsStreamState();
}

class _LikedItemsStreamState extends State<LikedItemsStream> {


  @override
  Widget build(BuildContext context) {
    final counterState = context.watch<CounterCubit>().state;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestoreStream().likedItemsStream(),
      builder: (context, snapshot) {
        List<String> likedItems = [];
        if (snapshot.hasData) {
          likedItems = FirebaseFirestoreRead().getLikedItems(snapshot);
          return GridView.builder(
              itemCount: likedItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,

              ),
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: getFavouriteList(likedItems),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      print(snapshot.data[0].title);
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
                            child: ItemCard(item: snapshot.data[index],
                                press: () {
                                  Navigator.pushNamed(context, DetailPage.id,
                                      arguments: snapshot.data[index]);
                                }
                            )));
                    } else
                      return CircularProgressIndicator();
                  }
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

      },
    );
  }
  Future<List<Item>> getFavouriteList(List<String> docIds) async =>
      // await Future.delayed(Duration(milliseconds: 100), () {
  await FirebaseFirestoreRead().getLikedItemsList(docIds: docIds);


}




