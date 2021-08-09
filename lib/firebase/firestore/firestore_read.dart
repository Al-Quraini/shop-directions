
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firestore/firestore.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart' as u;
import 'package:shop_directs/screens/chat/chat_detail_page.dart';
import 'package:shop_directs/screens/chat/models/chat_message.dart';
import 'package:shop_directs/screens/chat/models/chat_users.dart';
import 'package:shop_directs/utils/enums.dart';

class FirebaseFirestoreRead extends FirebaseFirestoreClass{

  final _firestore = FirebaseFirestore.instance;

  Future<u.User> loadUserData({String userUid = ''}) async {
    u.User user;
    try {
      await _firestore
          .collection('users')
          .doc(userUid)
          .get().then((DocumentSnapshot snapshot) async {
        //print('sanpppppppp shoooooot ${snapshot.data()['phoneNumber']}');
        user = u.User(

          name : snapshot.data()['name'],
          email :snapshot.data()['email'],
          imageUrl: snapshot.data()['imageUrl'],
          phoneNumber : snapshot.data()['phoneNumber'],
          location :snapshot.data()['location'],
          uid :snapshot.id,
        );
      }).then((value) => print('data loaded successfully'))
          .catchError((onError) => print(onError));

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Item>> getItems() async {
    List<Item> items = [];
    try {
      await _firestore
          .collection('items')
          .get().
      then((QuerySnapshot snapshots) async {
        Item item;
        for (var snapshot in snapshots.docs) {
          var data = snapshot.data();
          item = Item(
              title: data['title'],
              description: data['description'],
              category: data['category'],
              userId: data['userId'],
              images: data['images'],
              date: data['date'],
              price: data['price']
          );
          items.add(item);
        }
      }).then((value) => print('data fetched successfully'))
          .catchError((onError) => print(onError));

      return items;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<Item> getListStream(AsyncSnapshot<QuerySnapshot> snapshots) {
    List<Item> items = [];
    Item item;
    for (QueryDocumentSnapshot snapshot in snapshots.data.docs) {
      var data = snapshot.data();
      item = Item(
        id: snapshot.id,
        title: data['title'],
        description: data['description'],
        category: data['category'],
        userId: data['userId'],
        images: data['images'],
        date: data['date'],
        price: data['price'],
      );
      items.add(item);
    }
    return items;
  }

  Future<List<Item>> getLikedItemsList({List<String> docIds}) async{
    List<Item> items = [];
    List<String> likedItems = docIds;
    Item item;
    try {
      await _firestore
          .collection('items')
          .get().
      then((QuerySnapshot snapshots) async {
        Item item;

        for (var snapshot in snapshots.docs) {
          var data = snapshot.data();
          if (likedItems.contains(snapshot.id)) {
            item = Item(
                id: snapshot.id,
                title: data['title'],
                description: data['description'],
                category: data['category'],
                userId: data['userId'],
                images: data['images'],
                date: data['date'],
                price: data['price']
            );
            items.add(item);
          }
        }
      }).then((value) => print('data fetched successfully'))
          .catchError((onError) => print(onError));

      return items;
    } catch (e) {
      print(e);
      return null;
    }


  }

  List<String> getLikedItems(AsyncSnapshot<QuerySnapshot> snapshots) {
    List<String> likedItems = [];
    for (QueryDocumentSnapshot snapshot in snapshots.data.docs) {

      likedItems.add(snapshot.id);
    }
    print(likedItems.length);
    return likedItems;
  }

  List<ChatMessage> getMessages(AsyncSnapshot<QuerySnapshot> snapshots) {
    List<ChatMessage> messages =[];
    try {


      ChatMessage chatMessage;
        for (QueryDocumentSnapshot snapshot in snapshots.data.docs) {
          var data = snapshot.data();
          Timestamp timeStamp =data['timeStamp'];

          chatMessage = ChatMessage(
              message: data['text'],
              type: data['sentBy'] == FirebaseAuthClass.getCurrentUserUid() ?
              MessageFrom.Sender :
              MessageFrom.Receiver,
              url: data['url'],
              dateTime: timeStamp.toDate(),
              sentBy: data['sentBy'],
            isRead: data['isRead'],
            chatMessageType: EnumToString.fromString(ChatMessageType.values,
                data['messageType']),
          );
          messages.add(chatMessage);
        }



      return messages;

    } catch (e) {
      print(e);
      return null;
    }
  }
  Future<List<ChatMessage>> getMessageList(String uid) async {
    List<ChatMessage> messages =[];
    try {
      await _firestore.collection('chats')
        .doc(FirebaseFirestoreClass()
        .generateChatUid(FirebaseAuthClass.getCurrentUserUid(), uid))
        .collection('messages').orderBy('timeStamp').get()
          .then((QuerySnapshot snapshots) {
        ChatMessage chatMessage;
        for (QueryDocumentSnapshot snapshot in snapshots.docs) {
          var data = snapshot.data();
          Timestamp timeStamp =data['timeStamp'];

          chatMessage = ChatMessage(
            message: data['text'],
            type: data['sentBy'] == FirebaseAuthClass.getCurrentUserUid() ?
            MessageFrom.Sender :
            MessageFrom.Receiver,
            isRead: data['isRead'],
            dateTime: timeStamp.toDate(),
            sentBy: data['sentBy'],
            chatMessageType: EnumToString.fromString(ChatMessageType.values,
                data['messageType']),
          );
          messages.add(chatMessage);
        }
          });




      return messages;

    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<ChatUsers>> getChats() async{
    List<ChatUsers> chatUsers =[];
    try {
      await _firestore.collection('chats').get()
      .then((QuerySnapshot snapshots) async{
        ChatUsers chatUser;
        for (QueryDocumentSnapshot snapshot in snapshots.docs) {
          var data = snapshot.data();
          Timestamp timeStamp =data['timeStamp'];

          chatUser = ChatUsers(
            chatId: snapshot.id,
            senders: data['contacts'],

            chatMessage: await getMessageList(data['contacts'].where((element)
            => element
                != FirebaseAuthClass.getCurrentUserUid())
                .first)

          );
          if(chatUser.senders.contains(FirebaseAuthClass.currentUser.uid))
          chatUsers.add(chatUser);

          print(chatUsers.length);
        }
        print('mamamamamamamamamama ${chatUsers[0].chatMessage.length}');

        return chatUsers;


      });

      return chatUsers;
    } catch (e) {
      print(e);
      return null;
    }
  }





}