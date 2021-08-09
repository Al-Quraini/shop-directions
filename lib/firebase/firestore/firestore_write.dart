
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/firebase/firestore/firestore.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart'  as u;
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/chat/models/chat_message.dart';

import '../firebase_auth.dart';
import '../firebase_storage.dart';

class FirebaseFirestoreWrite extends FirebaseFirestoreClass{
  final _firestore = FirebaseFirestore.instance;

  Future<void> addUser(u.User user, Function callback) async {
    // Call the user's CollectionReference to add a new user
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuthClass.getCurrentUserUid())
          .set({
        'name': user.name, // John Doe
        'email': user.email, // Stokes and Sons
        'phoneNumber': user.phoneNumber, // Stokes and Sons
        'imageUrl': user.imageUrl,
        'location': user.location,
      })
          .then((value) => print('Data sen successfully'))
          .catchError((error) => print("Failed to add user: $error"));
      callback();
      FirebaseAuthClass().signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addItem(Item item) async {
    try {

      await _firestore
          .collection('items')
          .doc()
          .set({
        'title': item.title, // John Doe
        'description': item.description, // Stokes and Sons
        'date': item.date, // Stokes and Sons
        'userId': FirebaseAuthClass.getCurrentUserUid(),
        'images': item.images,
        'category': item.category,
        'price': item.price,
        'dateTime': item.dateTime
      })
          .then((value) {
        print('Data sent successfully');
        return true;
      })
          .catchError((error) {
        print("Failed to add item: $error");
        return false;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

    Future<DocumentReference> addChat(String messageTo, ChatMessage chatMessage) async {
        try {
          DocumentReference documentReference = _firestore
              .collection('chats')
              .doc();

        await documentReference
              .set({
            'contact1': chatMessage.sentBy,
            'contact2': messageTo,
          });

          return documentReference;
        } catch (e) {
          print(e);
          return null;
        }
      }

  Future<bool> sendMessage({User messageTo, ChatMessage message}) async {
    try {
      DocumentReference documentReference = _firestore
          .collection('chats')
          .doc(FirebaseFirestoreClass().generateChatUid(messageTo.uid, message.sentBy));

      await documentReference
          .set({
        'contacts': [FirebaseAuthClass.currentUser.uid,messageTo.uid],
      }).then((value) {
        documentReference.collection('messages')
            .doc()
            .set({
          'text' : message.message,
          'timeStamp' : message.dateTime,
          'sentBy' : message.sentBy,
          'url' : message.url,
          'isRead' : false,
          'messageType': EnumToString.convertToString(message.chatMessageType)
          // 'type' : message.type
        })
            .then((value) {
          print('Data sent successfully');
          return true;
        })
            .catchError((error) {
          print("Failed to add item: $error");
          return false;
        });
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> readMessage({User user}) async{
    List<String> messageIds=[];
    try {
      await _firestore
          .collection('chats')
          .doc(FirebaseFirestoreClass().generateChatUid(user.uid,
          FirebaseAuthClass.currentUser.uid)).collection('messages')
          .where('sentBy', isNotEqualTo: FirebaseAuthClass.currentUser.uid)
          .get().then((QuerySnapshot snapshots) async {
            for(var snapshot in snapshots.docs){
              messageIds.add(snapshot.id);
            }
            await markRead(messageIds, user);
            print(messageIds);
            })

            .then((value) {
          print('Data sent by reading successfully');
          return true;
        })
            .catchError((error) {
          print("Failed to add item: $error");
          return false;
        });


      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> markRead(List<String> mIds, user) async{
    try{
      for(String mId in mIds){
      await _firestore
    .collection('chats')
        .doc(FirebaseFirestoreClass().generateChatUid(user.uid,
    FirebaseAuthClass.currentUser.uid))
          .collection('messages').doc(mId)
      .update({
        'isRead' : true
      }
      );
      }
    } catch (e){

    }
  }


  Future<bool> updateItem(
      {@required Map<String, dynamic> item,
        @required String docId}
      ) async {
    try {
      await _firestore
          .collection('items')
          .doc(docId).update(item)
          .then((value) {
        print('Data updated successfully');
        return true;
      })
          .catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUser({
    @required Map<String, dynamic> user,
    @required String uid
  }) async{
    try {
      await _firestore
          .collection('users')
          .doc(uid).update(user)
          .then((value) {
        print('Data user updated successfully');
        return true;
      })
          .catchError((error) {
        print("Failed to update user: $error");
        return false;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> likeItem({
    BuildContext context,
    @required String docId,
    @required bool isLiked,
    @required String userId}) async {
    print(docId);
    try {
      if(isLiked)
        await _firestore.collection('users').doc(userId).collection('likedPosts')
            .doc(docId).set({
          'isLiked': isLiked
        })
            .then((value) {
          print('Successfully add like');
          final snackBar = SnackBar(content: Text('successfully liked!'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.pink,
            elevation: 3,);
          Scaffold.of(context).showSnackBar(snackBar);
        })
            .catchError((onError) => print(onError));
      else
        await _firestore.collection('users').doc(userId).collection('likedPosts')
            .doc(docId).delete()
            .then((value) => print('Successfully add like'))
            .catchError((onError) => print(onError));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteUser({@required String uid,UserLogged state}) async{
    if(state.user.imageUrl != null)
      await FirebaseStorageClass().deleteImage(state.user.imageUrl);

    await deleteCurrentUserItems(uid: uid);

    await _firestore.collection('users').doc(uid).delete()
        .then((value) async => print('User deleted successfully'))
        .catchError((onError) => print(onError));
  }


  Future<bool> deleteItem({@required String docId}) async{
    try {
      await _firestore.collection('items').doc(docId).delete()
          .then((value) async =>batchDelete(docId: docId))
          .catchError((onError) => print(onError));



      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteCurrentUserItems({
    @required String uid,}) async{
    try {
      await _firestore.collection('items').where('userId', isEqualTo: uid)
          .get()
          .then((QuerySnapshot snapshot) async{
        print( '----------()()()()()(#############)'+snapshot.docs.length.toString());
        List<String> docIdsToBeDeleted =[];
        for(QueryDocumentSnapshot snapshot in snapshot.docs){
          var data = snapshot.data();

          docIdsToBeDeleted.add(snapshot.id);

          List<dynamic> images =data['images'];
          if(images != null){
            if(images.length > 0){

              images.forEach((image) async{
                await FirebaseStorageClass().deleteImage(image);
                print('----------?><><><><><'+image);


              });
            }
          }
          print(snapshot.id+ '----------_____----__--?_?_');

        }
        for(String docId in docIdsToBeDeleted){
          await deleteItemFromFavourite(docId);

          await deleteItem(docId: docId);
        }
      }
      )
          .catchError((onError) => print(onError));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteItemFromFavourite(String docId) async{
    {
      await _firestore.collection('users').get()
          .then((QuerySnapshot snapshots) async =>
      {
        for (var snapshot in snapshots.docs){
          likeItem(docId: docId, isLiked: false, userId: snapshot.id)
        }
      });
    }
  }

  Future<void> batchDelete({String docId, String userId =''}) {
    WriteBatch batch = _firestore.batch();

    return _firestore.collection('users').
    doc(userId)
        .collection('likedPosts').get().then((querySnapshot) {
      print('l_______________________________${querySnapshot.docs.length}');
      querySnapshot.docs.forEach((document) {
        if(document.id == docId)
          batch.delete(document.reference);
      });

      return batch.commit();
    });
  }


  

}