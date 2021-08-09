
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_directs/firebase/firestore/firestore.dart';
import 'package:shop_directs/models/filter/filter_sort.dart';

import '../firebase_auth.dart';

class FirebaseFirestoreStream extends FirebaseFirestoreClass{

  final _firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot> getCurrentUserItemsStream() {
    try{
      var snapshotItems= _firestore
          .collection('items')
          .where('userId', isEqualTo: FirebaseAuthClass.getCurrentUserUid())
          .snapshots();




      return snapshotItems;
    }catch(e){
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getThisUserItemsStream({String uid}) {
    try{
      var snapshotItems= _firestore
          .collection('items')
          .where('userId', isEqualTo: uid)
          .snapshots();




      return snapshotItems;
    }catch(e){
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> likedItemsStream(){
    return  _firestore
        .collection('users').doc(FirebaseAuthClass.getCurrentUserUid()).collection('likedPosts')
        .snapshots();
  }

  Stream<QuerySnapshot> messageStream(){
    return  _firestore
        .collection('messages').orderBy('timeStamp').snapshots();
  }

  Stream<QuerySnapshot> messagesStream({@required String uid}){
    return  _firestore.collection('chats')
        .doc(FirebaseFirestoreClass()
        .generateChatUid(FirebaseAuthClass.getCurrentUserUid(), uid))
        .collection('messages').orderBy('timeStamp')
        .snapshots();
  }

  Stream<QuerySnapshot> chatsStream(){
      return  _firestore.collection('chats')
           .snapshots();
    }

  Stream<QuerySnapshot> getItemsStream({
    FilterSortContent filterSortContent,
    List<String> selectedCategories = const [],

  }) {
    CollectionReference collection = _firestore
        .collection('items');




    if (filterSortContent.filterKey.isNotEmpty && selectedCategories.length > 0) {

      var snapshotItems = collection
          .where('category', whereIn: selectedCategories)
      //.where('price', isGreaterThan: minValue, isLessThan: maxValue)
          .orderBy(filterSortContent.filterKey,
          descending: filterSortContent.descending)
          .snapshots();

      return snapshotItems;

    }
    else if (selectedCategories.length > 0 && filterSortContent.filterKey.isEmpty) {
      var snapshotItems =collection.where('category', whereIn: selectedCategories)
      // .where('price', isGreaterThan: minValue, isLessThan: maxValue)
          .snapshots();
      return snapshotItems;
    }
    else if (selectedCategories.length == 0 && filterSortContent.filterKey.isNotEmpty) {
      var snapshotItems =collection
      //.where('price', isGreaterThan: minValue, isLessThan: maxValue)
          .orderBy(filterSortContent.filterKey,
          descending: filterSortContent.descending).snapshots();
      return snapshotItems;

    }
    else {
      var snapshotItems =collection
      // .where('price', isGreaterThan: minValue, isLessThan: maxValue)
          .snapshots();
      return snapshotItems;
    }

    /*_firestore
        .collection('items').
        .snapshots();*/
  }

}