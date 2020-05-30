// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:recipetap/pages/favourites_screen.dart';

// class PushNotificationsManager {
//   PushNotificationsManager._();

//   factory PushNotificationsManager() => _instance;

//   static final PushNotificationsManager _instance =
//       PushNotificationsManager._();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;

//   Future<void> init() async {
//     if (!_initialized) {
//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions();
//       _firebaseMessaging.configure(
//         // Foreground Notif
//         onMessage: (Map<String, dynamic> message) async {
//           print(message.toString());
//         },
//         // Closed
//         onLaunch: (Map<String, dynamic> message) async {
//           print(message.toString());
//         },
//         // Background
//         onResume: (Map<String, dynamic> message) async {
//           print(message.toString());
//         },
//       );

//       // For testing purposes print the Firebase Messaging token
//       String token = await _firebaseMessaging.getToken();
//       print("FirebaseMessaging token: $token");

//       _initialized = true;
//     }
//   }

//   void serialiseAndNavigate(Map<String, dynamic> message) {
//     var notificationData = message['data'];
//     var view = notificationData['view'];

//     if (view != null) {
//       // Navigate to any view
//       if (view == "fav") {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => FavouritesScreen()));
//       }
//     }
//   }
// }
