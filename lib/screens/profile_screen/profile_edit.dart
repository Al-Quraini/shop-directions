import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/cubit/internet_cubit/internet_cubit.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/router/app_router.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'package:shop_directs/widgets/edit_profile_image.dart';
import 'package:shop_directs/widgets/input_components/build_auth_button.dart';
import 'package:shop_directs/widgets/input_components/build_email_row.dart';
import 'package:shop_directs/widgets/input_components/build_location_row.dart';
import 'package:shop_directs/widgets/input_components/build_name_row.dart';
import 'package:shop_directs/widgets/input_components/build_passowrd_row.dart';
import 'package:shop_directs/widgets/input_components/build_phone_row.dart';
import 'package:shop_directs/widgets/rounded_button.dart';

typedef void NameCallback(String val);
typedef void EmailCallback(String val);
typedef void PhoneNumberCallback(String val);
typedef void LocationCallback(String val);


class ProfileUpdate extends StatefulWidget {
  static const String id = '/profile_update';

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  File file;
  String name, email, phoneNumber,location, imageUrl;
  bool showSpinner =false;
  UserLogged state;


  Future<void> uploadImage() async {
    final _picker = ImagePicker();
    PickedFile image;
    image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      file=File(image.path);

    });

  }

  Future<String> uploadImageToStorage() async{
    if(state.user.imageUrl != null)
    await FirebaseStorageClass().deleteImage(state.user.imageUrl);


    String imageUrl =await FirebaseStorageClass()
        .uploadImage(file,);

    return imageUrl;
  }

  void updateUserData() async{
    if(file != null)
      imageUrl = await uploadImageToStorage();

    Map<String, dynamic> user = {
      'imageUrl': imageUrl,
      'name': name,
      'phoneNumber': phoneNumber,
      'location': location
    };

    bool success = await FirebaseFirestoreWrite().updateUser(user: user,
        uid: FirebaseAuthClass.getCurrentUserUid());

    if(success) {
      userDataUpdatedSuccess();
    }
  }

  void userDataUpdatedSuccess(){
    Navigator.pop(context);
    context.read<UserCubit>().emitUserLogged(User(
       name : name, email : email, imageUrl : imageUrl
        , phoneNumber : phoneNumber, location : location
    ));
  }

  Future<void> deleteAccount() async {
    setState(() {
      showSpinner =true;
    });
    await FirebaseFirestoreWrite().deleteUser(uid:
    FirebaseAuthClass.getCurrentUserUid(), state: state);
    await FirebaseAuthClass().deleteUser();

    setState(() {
      showSpinner =false;
    });
    Navigator.pop(context, true);



  }

  void initializeData(UserLogged state){
    name = state.user.name;
    email = state.user.email;
    phoneNumber = state.user.phoneNumber;
    location = state.user.location;
    imageUrl = state.user.imageUrl;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon : Icon(Icons.arrow_back_ios),
        color: Colors.grey, onPressed: () {
            Navigator.pop(context);
        },),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: BlocBuilder<UserCubit, UserState>(

          builder: (context, state)
                 {
                   this.state =state;
                   if(state is UserLogged) {
                     initializeData(state);
                return Padding(
                  padding: EdgeInsets.only(top: getProportionateSize(20)),
                  child: SingleChildScrollView(
                    child: Column(
                          children: [
                          Column(
                           // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                          children: [
/*                        Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            width: 50,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.arrow_back_ios,
                                  ),
                                ),

                              ),
                            ),
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              EditProfileImage(
                                file: file,
                                onPress: () async {
                                  await uploadImage();
                                },
                                state: state,
                              )


                            ],
                          ),
                          BuildNameRow(controller: TextEditingController(
                              text: state.user.name,
                          ),
                            callback: (value)=> name =value,
                          ),
                          BuildPhoneRow(controller: TextEditingController(
                              text: state.user.phoneNumber),
                          callback: (value)=> phoneNumber =value,),
                          BuildLocationRow(controller: TextEditingController(
                              text: state.user.location),
                          callback: (value)=> location =value,),
                          SizedBox(height: getProportionateScreenHeight(20),),
                            RoundedButton(title: 'Update',color: Colors.blue,
                          onPress: updateUserData,),
                            RoundedButton(title: 'Delete', color: Colors.red,
                            onPress: deleteAccount,)
                        ],
                      )
            ],
          ),
                  ),
                );
                   } else return null;
    }),
        ),
      ),
      );
    }
  }
