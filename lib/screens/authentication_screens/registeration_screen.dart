import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/user.dart' as u;
import 'package:shop_directs/utils/enums.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'package:shop_directs/widgets/edit_profile_image.dart';
import 'authentication_widgets/build_container.dart';
import 'authentication_widgets/build_logo.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

typedef void NameCallback(String val);
typedef void EmailCallback(String val);
typedef void PhoneNumberCallback(String val);
typedef void LocationCallback(String val);

class RegisterScreen extends StatefulWidget {
  static const String id ='/register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File file;
  bool showSpinner =false;
  String name;
  String email;
  String password;
  String phone;
  String location;

  u.User userData;



  void registerUser() async{
    String imageUrl;
    //BlocProvider.of<CounterCubit>(context).showSpinner();
    setState(() {
      showSpinner= true;
    });
    //BlocProvider.of<CounterCubit>(context).placeImage(file);



    final user =await FirebaseAuthClass()
        .createNewUser(email, password);

    if(user != null)
      {
        if(file != null)
      imageUrl= await FirebaseStorageClass().uploadImage(file);
    else
      print('No Path Received');

    userData = u.User(
        name : name,
        email : email,
        imageUrl : imageUrl,
        phoneNumber : phone,
        location : location,
    );

      await FirebaseFirestoreWrite().addUser(
          userData,
              (){
            Navigator.pop(context);
          }
      );}
    else
      print('error');

    setState(() {
      showSpinner= false;
    });


  }

  Future<void> uploadImage() async {
    final _picker = ImagePicker();
    PickedFile image;
    //Select Image
    image = await _picker.getImage(source: ImageSource.gallery);
    //BlocProvider.of<CounterCubit>(context).placeImage(file);
    setState(() {
      file=File(image.path);

    });

  }

  void setPassword(String value){
    password =value;
  }

  void setEmail(String value){
    email =value;
  }

  void setName(String value){
    name =value;
  }

  void setPhoneNumber(String value){
    phone =value;
  }



  @override
  void initState() {
    print(FirebaseAuthClass.getCurrentUserUid());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          title: Text('login Screen'),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white70,

        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            reverse: true,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.7,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(getProportionateSize(70)),
                            bottomRight: Radius.circular(getProportionateSize(70))
                        )
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BuildLogo(),
                    BuildContainer(
                        authPage: AuthPage.RegistrationPage,
                        label: 'Register',
                        authFunction: registerUser,
                        emailCallback: (value) => email = value,
                        passwordFunction: setPassword,
                        cardRatio: 1,
                        nameCallback: (value) => name = value,
                        phoneCallback: setPhoneNumber,
                        locationCallback: (value) => location=value,
                        profileImage: EditProfileImage(
                          file: file,
                          onPress: () async{
                            await uploadImage();
                          },
                        ) ,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),

              ],
            ),
          ),

        ),
      ),
    );
  }
  Widget profileImage(){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(200),
            width: getProportionateScreenWidth(50),),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: getProportionateSize(86),
              backgroundColor: Color(0xff476cfb),
              child: ClipOval(
                child: new SizedBox(
                  width: getProportionateSize(160),
                  height: getProportionateSize(160),
                  child: (file!=null)?Image.file(
                    file,
                    fit: BoxFit.fill,
                  ):Image.asset(
                      'assets/images/place_holder.png'
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: getProportionateSize(60)),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.solidFileImage,
                size: getProportionateSize(30),

              ),
              hoverColor: Colors.blueGrey,
              onPressed: uploadImage,
            ),
          )
        ],
      ),
    );
  }

}

