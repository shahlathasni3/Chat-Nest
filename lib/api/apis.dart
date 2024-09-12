
import 'package:chat_nest/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // accessing cloud firesteore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // accessing firebase storage
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

  // for all getting all users from database
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
}
