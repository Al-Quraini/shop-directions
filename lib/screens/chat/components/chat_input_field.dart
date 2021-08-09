import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/firebase/firestore/firestore.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/chat/models/chat_message.dart';
import 'package:shop_directs/screens/chat/models/send_menu_items.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/enums.dart';

class ChatInputField extends StatefulWidget {
  final User user;
  const ChatInputField({
    Key key, this.user,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  String message='';
  TextEditingController messageTextController = TextEditingController();

  List<SendMenuItems> menuItems = [
    SendMenuItems(text: "Photos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(text: "Document", icons: Icons.insert_drive_file,
        color: Colors.blue),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];


  void chooseFile() async {
    FilePickerResult result =
    await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['pdf'],);

    if(result != null) {
      File file = File(result.files.single.path,);
      String fileUrl = await FirebaseStorageClass().uploadPdf(file);
      final chatMessage = ChatMessage(
          url: fileUrl,
          message: file.path.split('/').last,
          type: MessageFrom.Sender,
          chatMessageType : ChatMessageType.file,
          dateTime: DateTime.now(),
          sentBy: FirebaseAuthClass.getCurrentUserUid());

      await FirebaseFirestoreWrite()
          .sendMessage(messageTo: widget.user,
          message: chatMessage);
      messageTextController.clear();
      message ='';

    } else {
      return;
    }
  }




  void showModal(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height/2,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16,),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: chooseFile,
                        child: Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: menuItems[index].color.shade50,
                              ),
                              height: 50,
                              width: 50,
                              child: Icon(menuItems[index].icons,size: 20,color: menuItems[index].color.shade400,),
                            ),
                            title: Text(menuItems[index].text),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 3,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: (){
               sendData(ChatMessageType.audio);
              },
                child: Icon(Icons.mic, color: kPrimaryColor)),
            SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    /*Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.64),
                    ),*/
                    SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        controller: messageTextController,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        showModal();
                      },
                      child: Icon(
                        Icons.attach_file,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.64),
                      ),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    GestureDetector(
                      onTap:  uploadImage,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.64),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                final chatMessage = ChatMessage(
                    message: messageTextController.text,
                    type: MessageFrom.Sender,
                    chatMessageType : ChatMessageType.text,
                    dateTime: DateTime.now(),
                    sentBy: FirebaseAuthClass.getCurrentUserUid());

                FirebaseFirestoreWrite()
                    .sendMessage(messageTo: widget.user,
                    message: chatMessage);
                messageTextController.clear();
                message ='';
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.send,color: kPrimaryColor,),

              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> uploadImage() async {
    final _picker = ImagePicker();
    PickedFile image;
    image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      // file=File(image.path);
    });

    final imageUrl =
    await FirebaseStorageClass().uploadImage(File(image.path), folder: 'messages');

    sendData(ChatMessageType.image, url : imageUrl);

  }

  void sendData(ChatMessageType chatMessageType ,
      {String url=''}){
    final chatMessage = ChatMessage(
        message:
        messageTextController.text ,
        url: url,
        type: MessageFrom.Sender,
        chatMessageType : chatMessageType,
        dateTime: DateTime.now(),
        sentBy: FirebaseAuthClass.getCurrentUserUid());

    FirebaseFirestoreWrite().sendMessage(messageTo: widget.user,message: chatMessage);
    messageTextController.clear();
  }
}
