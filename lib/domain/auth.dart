import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// /---------------------------------------------------------signUp---------------------------

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password, String username) async {
    log("print 4");
    try {
      final CollectionReference adminCollection =
          FirebaseFirestore.instance.collection('admin');

//------------------------------------------------------------signup function----------------------

      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

// ------------------------------------------------Store user details in Firestore collection 'users'
      User? user = userCredential.user;

      if (user != null) {
        await adminCollection
            .doc(user.uid)
            .set({'email': email, 'username': username});
      }

      return user;
    } catch (e) {
      log('Error during signup: $e');
      return null;
    }
  }

// ----------------------------------------------------------------signIn---------------------------------------

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      log("some error ocurred");
    }
    return null;
  }
}
