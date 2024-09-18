
import 'dart:io';
import 'dart:math';

import 'package:chat_nest/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/message.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for accessing cloud firesteore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
  // for storing self information
  static late ChatUser me;
  // to return current user
  static User get user => auth.currentUser!;
  // for checking if user exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection('user').doc(user.uid).get())
        .exists;
  }
  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('user').doc(user.uid).get().then((user) async {
      if(user.exists){
        me = ChatUser.fromJson(user.data()!);
        // log('My data: ${user.data()}');
      }
      else{
        await createUser().then((value) => getSelfInfo());
      }
    });
  }
  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email:user.email.toString(),
        about:"hey,iam using chartnest",
        image:user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken:''
    );
    return await firestore.collection('user').doc(user.uid).set(chatUser.toJson());
  }
  // for getting all users from database
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllUsers(){
    return firestore.collection('user').where('id' , isNotEqualTo: user.uid).snapshots();
  }
  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('user').doc(user.uid).update({
      'name' : me.name,
      'about' : me.about,
    });
  }
  // update profile picture of user
  // static Future<void> updateProfilePicture(File file) async{
  //   // getting image file extension
  //   final ext = file.path.split('.').last;
  //   log('Extension: $ext');
  //   // storage file ref with path
  //   final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
  //   // uploading image
  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0){
  //     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //   });
  //   // update image in firestore database
  //   me.image = await ref.getDownloadURL();
  //   await firestore.collection('user').doc(user.uid).update({
  //     'image' : me.image,
  //   });
  // }

// ================= chat screen related apis ===================//

  // chats (collection) --> conversation_id (doc) --> messages (collection)  --> message (doc)

  // useful for getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  // for getting all messages of a specific conversation from database
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllMessages(
      ChatUser user){
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent',descending: true)
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async{
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // message to send
    final Message message = Message(
        told: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);
    final ref = firestore.collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  // update read status of message
  static Future<void> updateReadMessageStatus(Message message) async{
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/').doc(message.sent).update(
        {'read' : DateTime.now().millisecondsSinceEpoch.toString()});
  }
  // get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String,dynamic>>> getLastMessage(
      ChatUser user ){
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
  }
  // send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
      // getting image file extension
      final ext = file.path.split('.').last;
      // storage file ref with path
      final ref = storage.ref().child('images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
      // uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'image/$ext'))
          .then((p0){
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb' as num);
      });
      // update image in firestore database
      final imageUrl = await ref.getDownloadURL();
      await APIs.sendMessage(chatUser, imageUrl, Type.image);
  }
}

