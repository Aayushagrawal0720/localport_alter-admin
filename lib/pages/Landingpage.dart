import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localport_alter_admin/pages/orders/AllOrders.dart';
import 'package:localport_alter_admin/pages/demands/demand_box.dart';
import 'package:localport_alter_admin/pages/users/AllUsers.dart';
import 'package:localport_alter_admin/services/notification/firebase_notification_services.dart';
import 'package:localport_alter_admin/services/notification/local_notification_setup.dart';
import 'package:localport_alter_admin/services/notification/notification_topic_subscription.dart';

import 'deliverypartners/all_partners.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    FirebaseNotificationService().setupInteractedMessage();
    LocalNotificationSetup().initializeLocalNotifications();
    NotificationTopicSubscription.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AllOrders()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          offset: Offset(1, 1),
                          blurRadius: 3)
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Orders"), Icon(Icons.chevron_right)],
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AllUsers()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          offset: Offset(1, 1),
                          blurRadius: 3)
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Users"), Icon(Icons.chevron_right)],
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AllPartners()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          offset: Offset(1, 1),
                          blurRadius: 3)
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery partners"),
                      Icon(Icons.chevron_right)
                    ],
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => DemandBoxPage()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          offset: Offset(1, 1),
                          blurRadius: 3)
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Demand box"),
                      Icon(Icons.chevron_right)
                    ],
                  )),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
