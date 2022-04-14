import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:localport_alter_admin/pages/Landingpage.dart';
import 'package:localport_alter_admin/services/LocalportApiService/LocalportDermandDetailService.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_alldemand_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_allpartners_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_alluser_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_delpartner_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_detail_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_history_services.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_payment_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_status_update_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_specialuser_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_vendor_user_detailbyid_service.dart';
import 'package:localport_alter_admin/services/allusers_page_service.dart';
import 'package:localport_alter_admin/services/order_history_page_service.dart';
import 'package:localport_alter_admin/services/order_status_button_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_select_delivery_partner_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => localportOrderHistoryServices()),
        ChangeNotifierProvider(create: (_) => LocalportOrderDetailsServce()),
        ChangeNotifierProvider(create: (_) => OrderHistoryPageService()),
        ChangeNotifierProvider(create: (_) => OrderStatusButtonService()),
        ChangeNotifierProvider(
            create: (_) => LocalportOrderStatusUpdateService()),
        ChangeNotifierProvider(create: (_) => LocalportOrderPaymentService()),
        ChangeNotifierProvider(create: (_) => LocalportVendorUserDetailById()),
        ChangeNotifierProvider(create: (_) => LocalportAllUserService()),
        ChangeNotifierProvider(create: (_) => AlluserPageService()),
        ChangeNotifierProvider(create: (_) => LocalportAllPartnersService()),
        ChangeNotifierProvider(create: (_) => SelectDeliveryPartnerService()),
        ChangeNotifierProvider(
            create: (_) => LocalportOrderDelPartnerService()),
        ChangeNotifierProvider(create: (_) => LocalportSpecialUserService()),
        ChangeNotifierProvider(create: (_) => LocalportAllDemandService()),
        ChangeNotifierProvider(create: (_) => LocalportDemandDetailService()),
      ],
      child: MaterialApp(
        title: 'LP Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage(),
      ),
    );
  }
}
