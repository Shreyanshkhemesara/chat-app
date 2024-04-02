import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kittie_chat/main.dart';
import 'package:kittie_chat/model/chat_user.dart';
import 'package:kittie_chat/screens/chat_screen.dart';

String hexColor = "#734F96"; // dark lavender
Color semiTransparentColor =
    Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0x80000000);

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.user.image);
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
        },
        child: Card(
          child: ListTile(
            // leading: CircleAvatar(
            //   child: Icon(CupertinoIcons.person),
            // ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .5),
              child: CachedNetworkImage(
                width: mq.height * 0.055,
                height: mq.height * 0.055,
                imageUrl: widget.user.image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            title: Text(widget.user.name),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            // trailing: Text(
            //   '12:00AM',
            //   style: TextStyle(color: Colors.black54),
            // ),
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: semiTransparentColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}
