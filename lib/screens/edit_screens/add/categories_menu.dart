import 'package:flutter/material.dart';
import 'package:shop_directs/utils/Constants.dart';

class CategoriesMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _myListView(context));
  }
  Widget _myListView(BuildContext context) {

    return ListView.builder(
      itemCount: kCategoriesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.pop(context, kCategoriesList[index]);
          },
          child: Card( //                           <-- Card widget
            child: ListTile(
              leading: Icon(kCategoriesList[index].icon,
              color: kCategoriesList[index].color,),
              title: Text(kCategoriesList[index].category),
            ),
          ),
        );
      },
    );
  }
}
