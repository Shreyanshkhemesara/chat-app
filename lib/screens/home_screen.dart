import "dart:convert";
import "dart:developer";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:kittie_chat/model/chat_user.dart";
import "package:kittie_chat/screens/api.dart";
import "package:kittie_chat/screens/auth/login_scren.dart";
import "package:kittie_chat/screens/profile_screen.dart";
import "package:kittie_chat/widgets/chat_user_card.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<ChatUser> list = [];
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  final List<ChatUser> _searchList = [];
  bool _searchOn = false;
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        onPopInvoked: (context) {
          if (_searchOn) {
            setState(() {
              log('turning the switch @ swithcon');
              _searchOn = !_searchOn;
            });
          } else {}
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(IconData(0xe4a1, fontFamily: 'MaterialIcons')),
            title: _searchOn
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name or email',
                    ),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: .5),
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text('KitChat'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _searchOn = !_searchOn;
                    });
                  },
                  icon: Icon(_searchOn
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 1,
                      child: const Text('Profile'),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: const Text('Log Out'),
                    ),
                  ];
                },
                onSelected: (value) async {
                  if (value == 1) {
                    // final user = APIs.getMyUser();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  } else if (value == 2) {
                    await APIs.auth.signOut();
                    // await GoogleSignIn.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  }
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.message_rounded),
          ),
          body: StreamBuilder(
            stream: APIs.getAllUser(),
            builder: (context, snapshot) {
              print('snapshot: ${jsonEncode(snapshot.hasData)}');
              if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
              }
              if (list.isNotEmpty) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _searchOn ? _searchList.length : list.length,
                    itemBuilder: (context, index) {
                      print('here');
                      print(list);
                      return ChatUserCard(
                        user: _searchOn ? _searchList[index] : list[index],
                      );
                    });
              } else {
                return const Text('No connections found');
              }
            },
          ),
        ),
      ),
    );
  }
}
