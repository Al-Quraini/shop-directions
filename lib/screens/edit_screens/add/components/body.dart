import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/ItemType.dart';
import 'package:shop_directs/screens/edit_screens/add/categories_menu.dart';
import 'package:shop_directs/screens/edit_screens/add/components/price_container.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'bottom_button.dart';
import 'package:shop_directs/widgets/rounded_button.dart';

import 'image_container.dart';


typedef void FilesCallback(List<File> val);
typedef void PriceCallback(double val);


class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<File> files = List<File>.empty(growable: true);
  bool showSpinner=false;
  double price=0;
  String description, title, date;
  List<String> images;
  ItemType selectedCategory;
  TextEditingController _titleController=TextEditingController(),
      _descriptionController=TextEditingController();
  bool _validateTitle=false, _validateDescription =false;

  String getDate(){
    var date =  DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    var formattedDate =
        "${dateParse.day}-${dateParse.month}-${dateParse.year} "
        "${dateParse.hour}:${dateParse.minute} ";

    return formattedDate;
  }



  Future<List<String>> uploadImages() async{
    List<String> imagesUrl =await FirebaseStorageClass()
        .uploadImages(files, folder: 'items/');

    return imagesUrl;
  }
  void addItem() async{
      setState(() {
        showSpinner =true;
      });

      if(files.length > 0) {
        print('______________________________;;' + files.length.toString());
        images = [];
        images = await uploadImages();
      }


      Item item = Item(
        title: title,
        date: getDate(),
        dateTime: DateTime.now(),
        price: price,
        description: description,
        category: selectedCategory.category,
        images: images,
      );

      bool success = await FirebaseFirestoreWrite().addItem(item);

      success?
      dataSentSuccess():
      setState(() {
        showSpinner = false;
      });


  }

  void dataSentSuccess(){
    Navigator.pop(context);
    setState(() {
      showSpinner =false;
    });
  }





  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              width: 50,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getProportionateSize(10)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),
           ImageContainer(callback: (value)=> files= value,),
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: getProportionateSize(10)),
              padding: EdgeInsets.all(10),

              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (value) => title = value,
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 5.0),
                      ),
                      labelText: 'Title',
                      errorText: _validateTitle?'Enter a title':null,

                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20),),
                  TextFormField(
                  maxLines: 5,
                  maxLength: 300,
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => description = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: getProportionateScreenWidth(5)),
                    ),
                  labelText: 'Description',
                    errorText: _validateDescription?'Enter a description':null,
                  ),
                  ),



                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: getProportionateSize(10)),
              //padding: EdgeInsets.all(5),
              child: FlatButton(
                onPressed: () async{
                  var response = await
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>
                      CategoriesMenu()));
                  setState(()  {
                    this.selectedCategory= response;
                  });

                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Item Category',
                      style: TextStyle(
                        color: Colors.black54
                      ),),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    if(selectedCategory !=null)
                      Container(
                        color: selectedCategory.color,
                        //padding: EdgeInsets.symmetric(vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: getProportionateSize(10)),
                        child: ListTile(
                          leading: Icon(selectedCategory.icon),
                          title: Text(selectedCategory.category),
                        ),
                      )

                  ],
                ),
              ),
            ),
            PriceContainer(callback: (value)=> price =value,),

            BottomButton(
              onTap: (){
                if(_validateForm()){
                  addItem();
                }
              },
              buttonTitle: 'Share',

            )


          ],
        ),
      ),
    );
  }
  bool _validateForm(){




      if(_titleController.text.isEmpty) {
        _validateTitle =true;
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter a title'),
          duration: Duration(milliseconds: 500),);
        Scaffold.of(context).showSnackBar(snackBar);
      } else
      _validateTitle=false;


    if(_descriptionController.text.isEmpty) {
      _validateDescription=true;
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please enter a description'),
        duration: Duration(milliseconds: 500),);
      Scaffold.of(context).showSnackBar(snackBar);
    } else
      _validateDescription=false;



      setState(() {});
      if(selectedCategory == null){
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a category'),
          duration: Duration(milliseconds: 500),);
        Scaffold.of(context).showSnackBar(snackBar);
      }

      return !_validateDescription && !_validateTitle
          && selectedCategory != null ;

  }

}

