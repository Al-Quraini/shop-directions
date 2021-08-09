import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/size_config.dart';
import 'body.dart';


class ImageContainer extends StatefulWidget {
  const ImageContainer({
    Key key, this.callback
  }) : super(key: key);

  final FilesCallback callback;

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  //File file;
  List<File> files=[];

  void chooseImage() async {
    final _picker = ImagePicker();
    PickedFile image;
    //Select Image
    image = await _picker.getImage(source: ImageSource.gallery);
    setState(()  {
      files.add( File(image.path));
      //file =  files[0];

      widget.callback(files);

      //print(files.length);
    });


  }

  @override
  void initState() {
   // files = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: SizeConfig.screenHeight*0.2,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please selected images for your item',
            ),
            SizedBox(height: getProportionateScreenHeight(5),),
            Row(
              children: [
                GestureDetector(

                    child: Container(
                      //color: Colors.grey,
                      height: getProportionateSize(100),
                      width: getProportionateSize(100),
                      child: Image.asset('assets/icons/add_image.svg',
                        fit: BoxFit.fill,),
                    ),
                    onTap: chooseImage
                ),



                for(File f in files) Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: getProportionateSize(10)),
                      height: getProportionateSize(100),
                      width: getProportionateSize(100),
                      child: Image.file(f, fit: BoxFit.cover),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          files.remove(f);
                        });},
                      child: Container(
                        padding: EdgeInsets.all(getProportionateSize(1)),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        //color: Color(0xcfe33f23),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(getProportionateSize(5)),
                          color: Color(0xcfe33f23)
                        ),
                        child: Icon(Icons.cancel,
                        color: Colors.white70,),
                       /* height: 20,
                        width: 35,*/
                      ),
                    )
                  ],
                )

              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
}
