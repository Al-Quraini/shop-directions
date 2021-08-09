import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/detail/detail_page.dart';
import 'package:shop_directs/screens/liked_items_screen/liked_items_stream.dart';
import 'package:shop_directs/screens/main/components/items_stream.dart';
import 'package:shop_directs/screens/main/items_screen.dart';
import 'package:shop_directs/screens/profile_screen/components/profile_image.dart';
import 'package:shop_directs/screens/profile_screen/user/user_detail.dart';
import 'package:shop_directs/utils/size_config.dart';

class ProfilePage extends StatelessWidget {
  static const String id ='/profile_page';
  final User user;

  const ProfilePage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(left: getProportionateSize(10),
                  top: getProportionateSize(10)),
              width: getProportionateScreenWidth(50),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getProportionateSize(10)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),
 /*           Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  children: [
                    ProfileImage(user: user,),
                  ],
                )),*/
            UserDetail(user: user,),

          Container(
            margin: EdgeInsets.only(top: getProportionateSize(20),
                bottom: getProportionateSize(5)),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.07,
            decoration: BoxDecoration(
              boxShadow: [
              BoxShadow(
              color: Color(0xffadc5ce),
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: getProportionateSize(6),
            ),],
              color: Color(0xffadc5ce),
              gradient: LinearGradient(
                colors: [Color(0xffeaf4f7),Color(0xffe2e2e2)],
              ),

            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateSize(20)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Related Items',
                  style: TextStyle(
                    fontSize: getProportionateSize(20),
                    color: Colors.black54
                  ),
                ),
              ),
            ),
          ),

            Expanded(
              child: ItemsStream(
                stream : FirebaseFirestoreStream()
                    .getThisUserItemsStream(uid: user.uid),
                des: DetailPage.id,
                function: (){
                  Navigator.popAndPushNamed(context, DetailPage.id,
                      arguments: user);
                },

              ),
            )
          ],
        ),
      ),
    );
  }
}
