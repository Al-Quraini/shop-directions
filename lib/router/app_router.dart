import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_directs/Settings_screen/setting_page.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/authentication_screens/login_screen.dart';
import 'package:shop_directs/screens/authentication_screens/registeration_screen.dart';
import 'package:shop_directs/screens/chat/chat_detail_page.dart';
import 'package:shop_directs/screens/chat/chat_page.dart';
import 'package:shop_directs/screens/detail/detail_page.dart';
import 'package:shop_directs/screens/edit_screens/add/add_item_page.dart';
import 'package:shop_directs/screens/edit_screens/update/update_item_page.dart';
import 'package:shop_directs/screens/host_screen/host_page.dart';
import 'package:shop_directs/screens/liked_items_screen/liked_items_page.dart';
import 'package:shop_directs/screens/main/items_screen.dart';
import 'package:shop_directs/screens/main/my_items_screen.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';
import 'package:shop_directs/screens/profile_screen/profile_edit.dart';
import 'package:shop_directs/screens/profile_screen/profile_page.dart';
import 'package:shop_directs/screens/profile_screen/user/user_detail.dart';

class AppRouter{
  final counterCubit = CounterCubit();

  AppRouter();
  Route onGenerateRoute(RouteSettings routeSettings){
    switch(routeSettings.name){
      case LoginScreen.id:
        return  MaterialPageRoute(builder: (context) =>
            LoginScreen());
        break;

      case RegisterScreen.id :
        return  MaterialPageRoute(builder: (context) =>
            RegisterScreen());
        break;

      case ItemsScreen.id  :
        return  MaterialPageRoute(builder: (_) =>
          ItemsScreen()
          );
        break;

        case HostPage.id  :
        return  MaterialPageRoute(builder: (_) =>
            HostPage()
          );
        break;


        case ChatPage.id  :
        return  MaterialPageRoute(builder: (_) =>
            ChatPage()
          );
        break;

        case ChatDetailPage.id  :
          final arg = routeSettings.arguments;
        return  MaterialPageRoute(builder: (_) =>
            ChatDetailPage(argument: arg,)
          );
        break;


      case DetailPage.id:
        Item arg = routeSettings.arguments;
      return MaterialPageRoute(builder: (context) =>
          DetailPage(argument: arg,));
      break;

      case MyItemsScreen.id :
        return  MaterialPageRoute(builder: (context) =>
            MyItemsScreen());
        break;

        case AddItemPage.id :
        return  MaterialPageRoute(builder: (context) =>
            AddItemPage());
        break;

        case LikedItemsPage.id :
        return  MaterialPageRoute(builder: (context) =>
            LikedItemsPage());
        break;

        case UserDetail.id :
        return  MaterialPageRoute(builder: (context) =>
            UserDetail());
        break;
        
        case ProfileUpdate.id:
        return  MaterialPageRoute(builder: (context) =>
            ProfileUpdate());
        break;

        case ProfilePage.id:
          User arg = routeSettings.arguments;
          return  MaterialPageRoute(builder: (context) =>
            ProfilePage(user: arg));
        break;

        case SettingsPage.id :
        return  MaterialPageRoute(builder: (context) =>
            SettingsPage());
        break;


        case UpdateItemPage.id :
        Item arg = routeSettings.arguments;
        //print(arg.id);
        return MaterialPageRoute(builder: (context) =>
            UpdateItemPage(argument: arg,));
        break;

      default : return null;


    }
  }
}