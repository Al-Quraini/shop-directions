import 'package:flutter/material.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/chat/chat_detail_page.dart';
import 'package:shop_directs/screens/profile_screen/components/profile_image.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'package:shop_directs/widgets/reusable_button.dart';
import 'package:shop_directs/widgets/rounded_button.dart';

class UserDetail extends StatelessWidget {
  static const String id ='/user_detail';

  final User user;

  const UserDetail({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        borderRadius: BorderRadius.only(

            topLeft: Radius.circular(getProportionateSize(5)),
            topRight: Radius.circular(getProportionateSize(5))
        ),),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(getProportionateSize(20)),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(

                  children: [
                    ProfileImage(user: user,),
                    Container(
                      margin: EdgeInsets.only(left: getProportionateSize(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              // fontFamily: 'MarckScript',
                                fontSize: getProportionateSize(30),
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            ) ,
                          ),

                          SizedBox(height: getProportionateScreenHeight(10),),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                              ),
                              Text(
                                user.location,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'SourceSansPro',
                                    fontSize: getProportionateSize(20)
                                ),
                              ) ,
                            ],
                          )

                        ],
                      ),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
            width: getProportionateScreenWidth(150),
            child: Divider(
              color: Colors.teal.shade100,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateSize(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReusableButton(title: 'Message',
                    icon: Icons.messenger_outlined,
                    color: Colors.blue,
                    onPress: (){
                  if(user.uid != FirebaseAuthClass.getCurrentUserUid()) {

                    Navigator.pushNamed(context,
                      ChatDetailPage.id,
                      arguments: user);
                  }
                    },
                    width :MediaQuery.of(context).size.width*0.4),

                ReusableButton(title: 'Call',
                    icon: Icons.call,
                    color: Colors.green,
                    width :MediaQuery.of(context).size.width*0.4),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateSize(30)),

            child: ReusableButton(title: 'Email',
                icon: Icons.email_outlined,
                color: Colors.orangeAccent,
                width :MediaQuery.of(context).size.width*0.8,
              onPress: (){

              },),
          ),

        ],

      ),
    );
  }
}
