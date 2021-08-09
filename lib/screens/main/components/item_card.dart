import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_directs/cubit/internet_cubit/internet_cubit.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/screens/authentication_screens/login_screen.dart';
import 'package:shop_directs/utils/Constants.dart';


class ItemCard extends StatefulWidget {
  final Item item;
  final Function press;
  const ItemCard({
    Key key,
    this.item,
    this.press,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool liked =false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(

              borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: widget.item.id,
                child: Container(
                  padding: EdgeInsets.all(kDefaultPadding),

                  decoration: BoxDecoration(
                    color: Colors.black12,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        //fit: BoxFit.fill,
                        image: widget.item.images != null && widget.item.images.isNotEmpty?
                        NetworkImage(widget.item.images[0]):
                        NetworkImage('https://lunawood.com/wp-content/'
                            'uploads/2018/02/placeholder-image.png',
                        )
                    ),
                    //color: product.color,
                    //borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
              child: Text(
                // products is out demo list
                widget.item.title,
                style: TextStyle(color: kTextLightColor),
              ),
            ),
            Text(
              "\$${widget.item.price}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestoreStream().likedItemsStream(),
                  builder: (context, snapshot) {

                    List<String> docsId=[];
                    if(snapshot.hasData) {
                        docsId =
                            FirebaseFirestoreRead().getLikedItems(snapshot);
                        print(docsId);
                        liked =docsId.contains(widget.item.id);
                      }

                      return BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                            final internetState =context.watch<InternetCubit>().state;

                            return GestureDetector(
                            onTap:() async {

                              if(internetState is InternetConnected) {
                              if(state is UserLogged) {
                                setState(() {
                                  liked = !liked;
                                });
                                 if(!liked)
                                   await FirebaseFirestoreWrite()
                                   .batchDelete(docId: widget.item.id,
                                   userId: FirebaseAuthClass.getCurrentUserUid()
                                   );

                                 else
                                await FirebaseFirestoreWrite()
                                    .likeItem(
                                    context: context,
                                    docId: widget.item.id,
                                    isLiked: liked,
                                    userId: FirebaseAuthClass.getCurrentUserUid());
                              } else {
                              if(state is UserNull)
                              Navigator.pushNamed(context, LoginScreen.id);
                              }

                            }},
                            child: Icon(!liked ?
                            FontAwesomeIcons.heart:
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                            ));
                        }
                      );
                  }
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
