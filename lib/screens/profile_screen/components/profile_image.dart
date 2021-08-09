import 'package:flutter/material.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/utils/size_config.dart';

class ProfileImage extends StatelessWidget {
  final User user;

  const ProfileImage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child:  Container(
            width: MediaQuery.of(context).size.height*0.12,
            height: MediaQuery.of(context).size.height*0.12,
            child:  user !=null  && user.imageUrl !=null &&
            user.imageUrl.isNotEmpty
              ?
            Image.network(user.imageUrl,
              fit: BoxFit.cover,
            ) :
            Image.asset('assets/images/place_holder.png'),
          ),
        ),
        Positioned(child: Container(
          height: getProportionateScreenHeight(30),
          width: getProportionateScreenWidth(30),

          decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(
                  width: getProportionateSize(2.5),
                  color: Theme.of(context).scaffoldBackgroundColor
              )
          ),
          child: null,
          // Icon(Icons.circle, color: Colors.white,),
        ),
          bottom: 0,
          right: 0,)
      ],
    );
  }
}
