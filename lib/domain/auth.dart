import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// /---------------signUp---------------------------

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // ... other methods ...

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Store user details in Firestore collection 'users'
        await _usersCollection.doc(user.uid).set({
          'email': email,
          'username': username,
          // Add more user details as needed
        });
      }

      return user;
    } catch (e) {
      print('Error during signup: $e');
      return null;
    }
  }

  // ... other methods ...

// ---------------signIn---------------------------------------

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("some error ocurred");
    }
    return null;
  }
}
