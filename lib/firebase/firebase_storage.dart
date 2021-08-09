import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:path/path.dart' as Path;

class FirebaseStorageClass{

  final _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, {String folder = ''}) async{

    String imageName =
        'userImages${DateTime.now().millisecondsSinceEpoch}.'
        '${_mimeType(file)}';

    //Upload to Firebase
        try{
      Reference ref =  _storage
          .ref()
          .child(
          '${FirebaseAuthClass.getCurrentUserUid()}/'
          '$folder'
          '$imageName');

      UploadTask task =  ref.putFile(file);
      TaskSnapshot snapshot = await task.whenComplete(() => task.snapshot);

      String downloadUrl = await snapshot.ref
          .getDownloadURL();


      print(downloadUrl);
      return downloadUrl;
    }catch(e){
          print('The error message is $e');
          return null;
        }
  }

  Future<List<String>> uploadImages(List<File> files, {String folder = ''}) async{
    List<String> imagesUrl = [];
    for(File file in files){
      String imageUrl = await uploadImage(file, folder: folder);
      imagesUrl.add(imageUrl);
    }
    return imagesUrl;
  }

  Future<String> uploadPdf(File file, {String folder = ''}) async{

    String pdfName = '${file.path.split('/').last}';

    //Upload to Firebase
    try{
      Reference ref =  _storage
          .ref()
          .child(
          '${FirebaseAuthClass.getCurrentUserUid()}/'
              '$folder'
              '$pdfName');

      UploadTask task =  ref.putFile(file);
      TaskSnapshot snapshot = await task.whenComplete(() => task.snapshot);

      String downloadUrl = await snapshot.ref
          .getDownloadURL();


      print(downloadUrl);
      return downloadUrl;
    }catch(e){
      print('The error message is $e');
      return null;
    }
  }


  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');


    final Reference firebaseStorageRef =
    _storage.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }


  String _mimeType(File file){

    String mimeT = mime(file.path);
    // print(file.);
    List<String> pathString = (mimeT).split('/');
    print(pathString);
    String mimeType = pathString[pathString.length - 1];
    print(pathString);

    return mimeType;
  }
}