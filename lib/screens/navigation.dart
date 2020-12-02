import 'package:flutter/material.dart';
import 'package:migsmarketplace/constants.dart';
import 'package:migsmarketplace/services/notifications.dart';
import 'package:migsmarketplace/screens/home.dart';
import 'package:migsmarketplace/screens/inbox.dart';
import 'package:migsmarketplace/screens/cart.dart';
import 'package:migsmarketplace/screens/account.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';

class NavigationScreen extends StatefulWidget {
  //Declare id as named route
  static const String id = '/navigation';
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  StreamSubscription iosSubscription;

  List<Widget> _screens = [
    HomeScreen(),
    InboxScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  //Initialize Controllers
  PageController _pageController = PageController();

  //Initialize Local Variables
  int _selectedIndex = 0;

  //function to change selected page index
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Function to change page based on index
  void _onItemTap(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      //final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      notificationServices.showNotification(
        title: notification['title'],
        body: notification['body'],
        payload: notification['data'],
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    notificationServices.setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationServices.setOnNotificationClick(onNotificationClick);

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');

        final _snackBar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Okay',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );

        Scaffold.of(context).showSnackBar(_snackBar);
      },

      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');

      },

      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },

      onBackgroundMessage: myBackgroundMessageHandler,
    );
    super.initState();
  }

  _saveDeviceToken() async {
    String uid;
    _auth.authStateChanges().listen((auth.User user) {
      uid = user != null ? user.uid : null;
    });

    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      DocumentReference tokenRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(fcmToken);

      await tokenRef.set({
        'token' : fcmToken,
        'createdAt' : FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {}

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    if (iosSubscription != null) {
      iosSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kNavBarBGColor,
        onTap: _onItemTap,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0,
        items: [

          //Home Tab
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? kMainThemeColor : kInactiveNavItemColor,
            ),
            label: 'Home',
            backgroundColor: Colors.white,
          ),

          //Store Tab
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded,
              color: _selectedIndex == 1 ? kMainThemeColor : kInactiveNavItemColor,
            ),
            label: 'My Store',
            backgroundColor: Colors.white,
          ),

          //Deals Tab
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.shoppingCart,
              size: 18,
              color: _selectedIndex == 2 ? kMainThemeColor : kInactiveNavItemColor,
              //color: Colors.grey,
            ),
            label: 'Feedback',
            backgroundColor: Colors.white,
          ),

          //Account Tab
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: _selectedIndex == 3 ? kMainThemeColor : kInactiveNavItemColor,
            ),
            label: 'Account',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}