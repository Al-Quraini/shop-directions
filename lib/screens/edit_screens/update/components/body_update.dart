import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/dialogs/dialog_maker.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/ItemType.dart';
import 'package:shop_directs/screens/edit_screens/add/categories_menu.dart';
import 'package:shop_directs/screens/edit_screens/update/components/price_container_update.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'package:shop_directs/widgets/rounded_button.dart';

import 'image_container_update.dart';


typedef void FilesCallback(List<File> val);
typedef void PriceCallback(double val);


class Body extends StatefulWidget {
  final Item item;

  const Body({Key key, this.item}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<File> files = [];
  bool showSpinner=false;
  double price=0;
  String description, title, date;
  List<dynamic> images;
  ItemType selectedCategory;
  TextEditingController _titleController,
      _descriptionController;
  bool _validateTitle=false, _validateDescription =false;

  String getDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    var formattedDate =
        "${dateParse.day}-${dateParse.month}-${dateParse.year} "
        "${dateParse.hour}:${dateParse.minute} ";

    return formattedDate;
  }

  void deleteItem() async{
    setState(() {
      showSpinner =true;
    });
    bool success = await FirebaseFirestoreWrite().deleteItem(docId: widget.item.id);

    success ? itemDeletedSuccess(): print('error while deleting');

    setState(() {
      showSpinner =false;
    });
  }



  Future<List<String>> uploadImages() async{
    List<String> imagesUrl =await FirebaseStorageClass()
        .uploadImages(files, folder: 'items/');

    return imagesUrl;
  }
  void updateItem() async{
      setState(() {
        showSpinner =true;
      });

      if(files.length > 0) {
        List<dynamic> imagesUrl = await uploadImages();
        imagesUrl.forEach((element) {
          images.add(element);
        });
        print(images.length);
      }


      Map<String, dynamic> item = {
        'title': title,
        'price': price,
        'description': description,
        'category': selectedCategory.category,
        'images': images
      };


      bool success = await FirebaseFirestoreWrite()
          .updateItem(item: item,docId: widget.item.id);

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
  void itemDeletedSuccess(){
    Navigator.pop(context);
  }


  @override
  void initState() {
    title=widget.item.title;
    description=widget.item.description;
    selectedCategory = kCategoriesList.firstWhere((element)
    => element.category == widget.item.category);
    print(selectedCategory.category);
    widget.item.images == null?
    images= List():
    images = widget.item.images;
    _titleController = TextEditingController(text: widget.item.title);
    _descriptionController=TextEditingController(text: widget.item.description);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                width: getProportionateScreenWidth(50),
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
            ),
           ImageContainer(callback: (value)=> files= value,
            images: widget.item.images,
           ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(getProportionateSize(10)),

              child: Column(
                children: [
                  TextFormField(

                    keyboardType: TextInputType.text,
                    onChanged: (value) => title = value,
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: getProportionateScreenWidth(5)),
                      ),
                      labelText: 'Title',
                      errorText: _validateTitle?'Enter a title':null,

                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                  maxLines: 5,
                  maxLength: 300,
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => description = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red,
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
              margin: EdgeInsets.symmetric(vertical: 10),
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
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Icon(selectedCategory.icon),
                          title: Text(selectedCategory.category),
                        ),
                      )

                  ],
                ),
              ),
            ),
            PriceContainer(callback: (value)=> price =value,
            price: widget.item.price,),

            RoundedButton(
              title: 'Update Item',
              color: Colors.lightBlueAccent,
             onPress: (){
               _validateForm() ? updateItem() : null;
             },
            ),
            SizedBox(width: getProportionateScreenWidth(30),),
            RoundedButton(
              title: 'Delete',
              color: Colors.red,
              onPress: (){
                DialogMaker(
                    context: context,
                    title: 'Delete $title',
                    content: 'Are you sure you want to delete $title',
                    onPress: deleteItem
                )
                    .displayDialog();
              },
            ),


          ],
        ),
      ),
    );
  }
  bool _validateForm(){



    setState(() {
      if(_titleController.text.isEmpty) {
        _validateTitle =true;
/*        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter a title'),
          duration: Duration(milliseconds: 500),);
        Scaffold.of(context).showSnackBar(snackBar);*/
      } else
      _validateTitle=false;


    if(_descriptionController.text.isEmpty) {
      _validateDescription=true;
      /*final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please enter a description'),
        duration: Duration(milliseconds: 500),);
      Scaffold.of(context).showSnackBar(snackBar);*/
    } else
      _validateDescription=false;



      });
      if(selectedCategory == null){
/*        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a category'),
          duration: Duration(milliseconds: 500),);
        Scaffold.of(context).showSnackBar(snackBar);*/
      }

      return !_validateDescription && !_validateTitle
          && selectedCategory != null ;

  }

}

