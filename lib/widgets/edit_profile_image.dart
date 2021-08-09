import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/utils/size_config.dart';

class EditProfileImage extends StatelessWidget {
  final File file;
  final Function onPress;
  final UserLogged state;

  const EditProfileImage({Key key, this.file, this.onPress, this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateSize(10)),
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            ClipOval(
              child:  Container(
                width: MediaQuery.of(context).size.height*0.185,
                height: MediaQuery.of(context).size.height*0.185,
                child: (file!=null) ?Image.file(
                  file,
                  fit: BoxFit.fill,
                ): state !=null && state.user != null && state.user.imageUrl !=null ?
                    Image.network(state.user.imageUrl,
                    fit: BoxFit.cover,
                    ) :
                Image.asset('assets/images/place_holder.png'),
              ),
            ),
            Positioned(child: GestureDetector(
              onTap: onPress,
              child: Container(
                height: 40,
                width: 40,

                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Theme.of(context).scaffoldBackgroundColor
                  )
                ),
                child: Icon(Icons.edit, color: Colors.white,),
              ),
            ),
            bottom: 0,
            right: 0,)
          ],
        ),
      ),
    );
  }
}
