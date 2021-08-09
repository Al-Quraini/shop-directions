import 'package:flutter/material.dart';
import 'package:shop_directs/screens/chat/models/chat_message.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/enums.dart';


class AudioMessage extends StatelessWidget {
  final ChatMessage message;


  const AudioMessage({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.8,
        vertical: kDefaultPadding / 5,
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(30),
      //   color: kPrimaryColor.withOpacity(message.type == MessageFrom.Sender ? 1 : 0.1),
      // ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: message.type == MessageFrom.Sender ? Colors.blueGrey : kPrimaryColor,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: message.type == MessageFrom.Sender
                        ? Colors.blueGrey
                        : kPrimaryColor.withOpacity(0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: message.type == MessageFrom.Sender ? Colors.blueGrey : kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "0.37",
            style: TextStyle(
                fontSize: 12, color: message.type == MessageFrom.Sender ? Colors.blueGrey : null),
          ),
        ],
      ),
    );
  }
}
