import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
import 'package:shop_directs/models/ItemType.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/authentication_screens/login_screen.dart';
import 'package:shop_directs/screens/profile_screen/profile_page.dart';
import 'package:shop_directs/screens/profile_screen/user/user_detail.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'components/image_slider_card.dart';
import 'components/item_info.dart';

class DetailPage extends StatefulWidget {
  DetailPage({@required this.argument});

  final Item argument;


  static const String id ='/detail_page';

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _current =0;
  bool isLiked =false;
  ItemType category;
  List<dynamic> imageUrl;

  @override
  void initState() {
    if(widget.argument.images == null)
      imageUrl =[1];


    category =kCategoriesList.firstWhere((element)
    => element.category == widget.argument.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Item item =widget.argument;
    return Scaffold(
      backgroundColor: Color(0xffcfdddd),
      body:SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  width: 50,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                CarouselSlider.builder(
                  /*NetworkImage('https://lunawood.com/wp-content/'
                      'uploads/2018/02/placeholder-image.png',
                  ),*/

                  itemCount: item.images != null ?item.images.length :
                  1,
                  itemBuilder: (BuildContext context, int index) {
                    return LimitedBox(
                        maxHeight: 300,
                        child: PageView(
                            children: [
                          ImageSliderCard(item: item,index: index,)

                    ]),
                    );
                  }, options: CarouselOptions(height: 300.0,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 2,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                   ),
                ),

             Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: item.images != null ?item.images.map((url) {
              int index = item.images.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList():
                  imageUrl.map((url) {
                    int index = imageUrl.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList()
               ,
          ),

                FutureBuilder(
                    future: getUserData(item.userId),
                    builder:(context, snapshot) {
                      if(snapshot.hasData){
                        User user = snapshot.data;
                        return GestureDetector(
                          onTap: (){
                            // showBottomSheet(user);
                            Navigator.pushNamed(context, ProfilePage.id,
                                arguments: user);
                          },
                          child: Card(
                            child: ListTile(
                              tileColor: Color(0xdd4bbdf2),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:user.imageUrl == null?
                                    AssetImage('assets/images/place_holder.jpg'):
                                    NetworkImage(user.imageUrl),
                                  ),
                                  Positioned(child: Container(
                                    height: 15,
                                    width: 15,

                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        // border: Border.all(
                                        //     width: 2.5,
                                        //     color: Theme.of(context).scaffoldBackgroundColor
                                        // )
                                    ),
                                    child: null,
                                    // Icon(Icons.circle, color: Colors.white,),
                                  ),
                                    bottom: 0,
                                    right: 0,)
                                ],
                              ),
                              title: Text(user.name,
                                style: TextStyle(color: Colors.white,),
                              ),
                            ),
                          ),
                        );
                      }else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                ),
                ItemInfo(item: item, category: category),


              ]),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(8),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestoreStream().likedItemsStream(),
          builder: (context, snapshot) {
            List<String> docsId=[];
            if(snapshot.hasData) {
              docsId =
                  FirebaseFirestoreRead().getLikedItems(snapshot);
              print(docsId);
              isLiked =docsId.contains(item.id);
            }
            return BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                final internetState =context.watch<InternetCubit>().state;
                return FloatingActionButton(
                  onPressed: () async {
                    if(internetState is InternetConnected) {
                      if(state is UserLogged) {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        // if(liked)
                        await FirebaseFirestoreWrite()
                            .likeItem(
                            context: context,
                            docId: item.id,
                            isLiked: isLiked,
                            userId: FirebaseAuthClass.getCurrentUserUid());
                      } else {
                        if(state is UserNull)
                          Navigator.pushNamed(context, LoginScreen.id);
                      }

                    }

                  },
                  backgroundColor: isLiked ? Colors.red:
                  Color(0x99f4c6c6),
                  child: isLiked ?
                  Icon(FontAwesomeIcons.solidHeart,color: Colors.white,):
                  Icon(FontAwesomeIcons.heart,color: Colors.red,),
                );
              }
            );
          }
        ),
      ),

    );
  }
  Future<User> getUserData(String userId) async =>
      // await Future.delayed(Duration(milliseconds: 100), () {
  await FirebaseFirestoreRead().loadUserData(userUid: userId);

  void showBottomSheet(User user){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
            child:Container(

              height: MediaQuery.of(context).size.height*0.8,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: UserDetail(user: user,),
            )
        )
    );
  }
}





