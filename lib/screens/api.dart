import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kittie_chat/model/chat_user.dart';

class APIs {
  static ChatUser me = ChatUser(
      id: user.uid,
      username: user.displayName.toString(),
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  static FirebaseAuth auth = FirebaseAuth.instance;
  // to store data in firestore api
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static get user => auth.currentUser!;
  // function to create user if dne:
  static Future<bool> userExists() async {
    return (await firestore.collection('chatUser').doc(user!.uid).get()).exists;
  }

  // craete a new user if dne : ( In firestore and not auth wala )
  static Future<void> createuser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      username: user.email.toString(),
      email: user.email.toString(),
      about: "hey i am at kittiechat",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: true,
      lastActive: time,
      pushToken: '',
    );
    return await firestore
        .collection('chatUser')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('chatUser').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        createuser().then(((value) {
          getSelfInfo();
        }));
      }
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('chatUser')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo(var name, var about) async {
    await firestore.collection('chatUser').doc(me.id).update({
      'name': name,
      'about': about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    print(me.toJson());
    var image = await ref.getDownloadURL();
    await firestore.collection('chatUser').doc(me.id).update({'image': image});
    me = me.copyWith(image: image);
  }
}
