import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_directs/Settings_screen/setting_page.dart';
import 'package:shop_directs/cubit/internet_cubit/internet_cubit.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/dialogs/dialog_maker.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/authentication_screens/login_screen.dart';
import 'package:shop_directs/screens/liked_items_screen/liked_items_page.dart';
import 'package:shop_directs/screens/main/my_items_screen.dart';

class MainDrawer extends StatelessWidget {

/*
  MainDrawer({this.user});

  final User user;
*/


  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: BlocBuilder<UserCubit, UserState>(

          builder: (BuildContext context, state) {
          String userName='No user';
          String email='';
          ImageProvider<Object> image =
          AssetImage('assets/images/place_holder.png');
          final internetState =context.watch<InternetCubit>().state;


          if(state is UserLogged){
            userName = state.user.name;
            email= state.user.email;
            if(state.user.imageUrl != null && state.user.imageUrl.isNotEmpty)
              image= NetworkImage(state.user.imageUrl);
          }
          return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(userName),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: image,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/drawer_backgrounds.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),



          ListTile(
            title: Text('Home'),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
            if(state is UserLogged)
            ...userLoggedIn(context,state,internetState)

            else if(state is UserNull || state is UserLoading)
              ...noUserLogged(context),



          ],
      );

  })
    );
  }
  List<Widget> noUserLogged(BuildContext context){
    return [



      ListTile(
        title: Text('Sign in'),
        trailing: Icon(Icons.login),
        onTap: (){
          Navigator.popAndPushNamed(context, LoginScreen.id);
        },
      ),
    ];
  }
  List<Widget> userLoggedIn(BuildContext context, UserLogged state,
      InternetState internetState){
    return [


      ListTile(
        title: Text('Sign out'),
        trailing: Icon(Icons.logout),
        onTap: (){
          DialogMaker(
              context: context,
              title: 'SIGN OUT',
              content: 'Are you sure you want to sign out ${state.user.name}?',
              onPress: (){
                if(internetState is InternetConnected) {
                  FirebaseAuthClass().signOut();
                  context.read<UserCubit>().emitUserNull();
                  Navigator.pop(context);
                } else if (internetState is InternetDisconnected){
                  Navigator.pop(context);
                final snackBar = SnackBar(content:
                Text('No internet connection'),
                  backgroundColor: Colors.red,
                  duration: Duration(milliseconds: 500),);
                Scaffold.of(context).showSnackBar(snackBar);
              }

                //Navigator.popAndPushNamed(context, LoginScreen.id);
              }
          ).displayDialog();


        },
      ),
    ];

  }
}
