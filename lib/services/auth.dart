import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:migsmarketplace/models/user.dart';
import 'package:migsmarketplace/modals/modal_custom.dart';

class AuthService extends ChangeNotifier {

  //Declare Firebase Instances
  final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool showSpinner = false;

  //User from Firebase
  User _userFromFirebaseUser(firebaseAuth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {

    return _auth.authStateChanges().map(_userFromFirebaseUser);

  }

  //Login function
  logIn({
    BuildContext context,
    String email,
    String password,
  }) async {

    try {

      showSpinner = true;
      notifyListeners();

      firebaseAuth.UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('users')
          .doc(credential.user.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        String userType = snapshot.data()['userType'];

        if (userType == 'merchant') {
          showSpinner = false;
          notifyListeners();
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          showSpinner = false;
          notifyListeners();
          unauthorizedSignOut();
          showDialog(context: context, builder: (_) {
            return CustomModal(
              title: 'Unauthorized Access',
              content: 'Sorry. You do not have access to this app.',
              enableSecondaryAction: false,
              mainAction: 'Okay',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          });
        }

      });

    } on firebaseAuth.FirebaseAuthException catch (e) {

      showSpinner = false;
      notifyListeners();

      if(e.code == 'user-not-found') {
        showDialog(context: context, builder: (context) =>
            CustomModal(
              title: 'User Not Found',
              content: 'Please try again.',
              enableSecondaryAction: false,
              mainAction: 'Okay',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            )
        );

      } else if (e.code == 'wrong-password') {
        showDialog(context: context, builder: (context) =>
            CustomModal(
              title: 'Incorrect Credentials',
              content: 'Please try again.',
              enableSecondaryAction: false,
              mainAction: 'Okay',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            )
        );
      }

    }

  }

  //Update User Phone Number
  Future updateUserPhone(String updatedPhoneNumber) async {
    final user = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc('${user.uid}')
        .update({'phone' : updatedPhoneNumber})
        .then((value) => print('Phone Number Updated.'));
  }

  //Set Rider Availability Status
  setStoreStatus(index) async {

    //If toggle button INACTIVE was pressed
    if (index == 0) {

      final user = _auth.currentUser;
      _firestore
          .collection('users')
          .doc(user.uid)
          .update({'open': false});

      //If toggle button ACTIVE was pressed
    } else {

      final user = _auth.currentUser;
      _firestore
          .collection('users')
          .doc(user.uid)
          .update({'open': true});

    }

  }//setRiderAvailability

  unauthorizedSignOut() async {
    _auth.signOut();
    notifyListeners();
  }

  //Sign Out
  Future signOut(context) async {

    final user = _auth.currentUser;

    try {

      //Update rider availability to false
      _firestore
          .collection('users')
          .doc(user.uid)
          .update({'open': false});

      //Ask for logout confirmation (Use different widget per platform)
      showDialog(context: context, builder: (_) =>
          CustomModal(
            title: 'Log Out',
            content: 'Are you sure you want to log out?',
            enableSecondaryAction: true,
            mainAction: 'Yes',
            secondaryAction: 'No',
            onPressed: () async {
              await _auth.signOut();
              //Notify Listeners that user is signed out and is null
              notifyListeners();
              Navigator.of(context).pop();
            },
          )
      );

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}