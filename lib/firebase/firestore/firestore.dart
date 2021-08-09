
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_directs/models/user.dart';

class FirebaseFirestoreClass{
  final _firestore = FirebaseFirestore.instance;



  CollectionReference _getCollectionReference({String path}){
    return  _firestore.collection(path);
  }

  DocumentReference getDocRef({String path}){
    return _getCollectionReference(path: path).doc(path);
  }


  String generateChatUid( String id1,  String id2){
    List<int> maxArr= [];

    List<int> uid1 = id1.codeUnits;
    List<int> uid2 = id2.codeUnits;

    for(int i =0; i< uid1.length && i<uid2.length ; i++){
      if(uid1[i] > uid2[i]){
        maxArr.add(uid1[i]);
      }
      else if( uid1[i] < uid2[i]){
        maxArr.add(uid2[i]);
      }
    }
    return String.fromCharCodes(maxArr);
  }

  // List<User> senders(List<dynamic> senders, ){
  //   List<User> sendersFromMap =[];
  //   for(var sender in senders){
  //     sendersFromMap.add(User.fromMap(sender, documentId))
  //   }
  // }


}