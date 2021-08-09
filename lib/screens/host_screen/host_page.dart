import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_directs/Settings_screen/setting_page.dart';
import 'package:shop_directs/screens/chat/chat_page.dart';
import 'package:shop_directs/screens/liked_items_screen/liked_items_page.dart';
import 'package:shop_directs/screens/main/items_screen.dart';

class HostPage extends StatefulWidget {
static const String id = '/HostPage';
  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> with AutomaticKeepAliveClientMixin{
  int _currentPage = 0;

  final  _pages = [
    ItemsScreen(),
    LikedItemsPage(),
    ChatPage(),
    SettingsPage()
  ];

  void changePage(int i){
    setState(() {
      _currentPage = i;
      updateKeepAlive();
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          //fixedColor: Colors.greenAccent,
          //type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Items",
                backgroundColor: Colors.redAccent
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: "Liked Items",
                backgroundColor: Colors.blueAccent
            ),

            BottomNavigationBarItem(
                icon: Icon(Icons.email_outlined),
                label: "Messages",
                backgroundColor: Colors.pinkAccent
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
                backgroundColor: Colors.green
            ),

          ],
          onTap: (int index) => changePage(index)
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
