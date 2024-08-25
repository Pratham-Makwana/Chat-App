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

  /// for storing self info
  static late ChatUser me;

  /// for checking user is exits or not ?
  static Future<bool> userExists() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  /// for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('user').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
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

  /// for getting all users from firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.firestore
        .collection("user")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }


  /// for updating user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('user')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }
}
