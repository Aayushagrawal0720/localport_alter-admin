import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationTopicSubscription {
  static subscribe(){
    FirebaseMessaging.instance.subscribeToTopic('neworder');
  }
}