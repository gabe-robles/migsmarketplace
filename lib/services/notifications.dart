import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationServices {

  //Declare Constructor
  NotificationServices._(){
    //Initialize Service
    init();
  }

  //Declare variables
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initializationSettings;

  //Stream Listener for notification
  final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

  //Init Function
  init() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      _requestIOSPermission();
    }
    initializePlatformSpecifics();

  }

  //Request IOS Permission
  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: false,
      badge: true,
      sound: true,
    );
  }

  //Show Notification Function
  Future<void> showNotification({String title, String body, payload}) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      "CHANNEL_ID",
      "CHANNEL_NAME",
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics,
        iOS: iosChannelSpecifics
    );
    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payload);

  }

  //Platform Specific Initialization Settings for Android and IOS
  initializePlatformSpecifics() {
    //Android
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    //IOS
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {

          //Event for Notification
          ReceivedNotification receivedNotification = ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          );

          //Add Notification to Stream
          didReceiveLocalNotificationSubject.add(receivedNotification);

        }
    );

    //Set Initialization Settings for Android and IOS into a variable
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );
  }

  //Set Listener for Lower Versions of iOS 10
  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceiveLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  //Function for user tapping on notification
  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (String payload) async {
          onNotificationClick(payload);
        }
    );
  }

  Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
    print('onBackgroundMessage: $message');
    await showNotification(
      title: message['notification']['title'],
      body: message['notification']['body'],
      payload: message['data']['data'],
    );
  }

}

NotificationServices notificationServices = NotificationServices._();

class ReceivedNotification {

  //Declare Constructor
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  //Declare needed variables
  final int id;
  final String title;
  final String body;
  final String payload;

}