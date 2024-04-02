import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kittie_chat/main.dart';
import 'package:kittie_chat/model/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded)),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              width: mq.height * 0.045,
              height: mq.height * 0.045,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'Last seen not available',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  // fontWeight: FontWeight.w400
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
