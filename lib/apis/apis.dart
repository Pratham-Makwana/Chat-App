import 'package:chatapp/model/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class APIs {
  /// for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// to return current user
  static User get user => auth.currentUser!;

  /// for checking user is exits or not ?
  static Future<bool> userExists() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  /// for creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey, I'm using chat!",
        name: user.displayName.toString(),
        createdAt: time,
        id: user.uid,
        isOnline: false,
        lastActive: time,
        pushToken: '',
        email: user.email.toString());


    await firestore.collection('user').doc(user.uid).set(chatUser.toJson());
  }



}
