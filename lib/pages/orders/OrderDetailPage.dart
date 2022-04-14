import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_admin/DataClasses/delivery_charge_class.dart';
import 'package:localport_alter_admin/pages/deliverypartners/select_delivery_partner_page.dart';
import 'package:localport_alter_admin/resources/MyColors.dart';
import 'package:localport_alter_admin/resources/Strings.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_delpartner_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_detail_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_history_services.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_payment_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_status_update_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_vendor_user_detailbyid_service.dart';
import 'package:localport_alter_admin/services/order_history_page_service.dart';
import 'package:localport_alter_admin/services/order_status_button_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  fetchUserDetails() {
    Provider.of<LocalportVendorUserDetailById>(context, listen: false)
        .fetchDetails(
            Provider.of<LocalportOrderDetailsServce>(context, listen: false)
                .getOrder()
                .id)
        .then((value) {
      if (value == '') {
      } else {
        showFailMessage("can't fetch user details right now");
      }
    });
  }

  fetchPartnerDetails() {
    Provider.of<LocalportOrderDelPartnerService>(context, listen: false)
        .fetchDelPartner(
            Provider.of<LocalportOrderDetailsServce>(context, listen: false)
                .getOrder()
                .oid);
  }

  updateStatus() {
    String oid =
        Provider.of<LocalportOrderDetailsServce>(context, listen: false)
            .getOrder()
            .oid;
    String uid =
        Provider.of<LocalportVendorUserDetailById>(context, listen: false)
            .getUserData()['uid'];
    if (uid == null) {
      showFailMessage("Try Again");
      return;
    }
    String status =
        Provider.of<OrderStatusButtonService>(context, listen: false)
            .getStatus();

    Provider.of<LocalportOrderStatusUpdateService>(context, listen: false)
        .updateStatus(oid, status, uid)
        .then((value) {
      if (value == '') {
        Provider.of<OrderHistoryPageService>(context, listen: false)
            .setStatus(status);
        Provider.of<localportOrderHistoryServices>(context, listen: false)
            .fetchOrders(status);
        Navigator.pop(context);
      } else {
        showFailMessage("Something went wrong");
      }
    });
  }

  updatePaymentStatus() {
    String oid =
        Provider.of<LocalportOrderDetailsServce>(context, listen: false)
            .getOrder()
            .oid;

    Provider.of<LocalportOrderPaymentService>(context, listen: false)
        .setPayment(oid)
        .then((value) {
      if (value == '') {
        String status =
            Provider.of<OrderStatusButtonService>(context, listen: false)
                .getStatus();
        Provider.of<OrderHistoryPageService>(context, listen: false)
            .setStatus(status);
        Provider.of<localportOrderHistoryServices>(context, listen: false)
            .fetchOrders(status);
        Navigator.pop(context);
      } else {
        showFailMessage("Something went wrong");
      }
    });
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  listCard(String key, String value, {TextStyle style}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "$key :",
                style: style == null
                    ? GoogleFonts.aBeeZee(
                        color: Colors.black, fontWeight: FontWeight.bold)
                    : style,
              ),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 3,
                style: style == null
                    ? GoogleFonts.aBeeZee(
                        color: Colors.black,
                      )
                    : style,
              ),
            ),
            key == senderphone || key == receiverPhone
                ? GestureDetector(
                    onTap: () {
                      launch("tel:$value");
                    },
                    child: CircleAvatar(child: Icon(Icons.call)))
                : Container()
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchPartnerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.color4,
        title: Text(
          "Order Detail",
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<LocalportOrderDetailsServce>(
                builder: (context, snapshot, child) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<LocalportVendorUserDetailById>(
                      builder: (context, vsnapshot, child) {
                        return vsnapshot.isLoading()
                            ? Text(
                                "Loading user details...",
                                style: GoogleFonts.aBeeZee(color: Colors.red),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: Column(
                                  children: [
                                    vsnapshot.getUserData()['fname'] != null
                                        ? listCard(
                                            sendername,
                                            vsnapshot.getUserData()['fname'] +
                                                " " +
                                                vsnapshot
                                                    .getUserData()['lname'])
                                        : Container(),
                                    vsnapshot.getUserData()['mobile'] != null
                                        ? listCard(senderphone,
                                            vsnapshot.getUserData()['mobile'])
                                        : Container(),
                                    vsnapshot.getUserData()['vname'] != null
                                        ? listCard(vendorname,
                                            vsnapshot.getUserData()['vname'])
                                        : Container(),
                                  ],
                                ),
                              );
                      },
                    ),
                    listCard(receiverName, snapshot.getOrder().rName),
                    listCard(receiverPhone, snapshot.getOrder().rPhone),
                    listCard(parcelWeight, snapshot.getOrder().weight),
                    listCard(pickupLocation, snapshot.getOrder().pickutext),
                    listCard(dropLocation, snapshot.getOrder().dropText),
                    listCard(roundTrip, snapshot.getOrder().roundTrip.toString()),

                    listCard(
                        delInstruction,
                        snapshot.getOrder().delInstruction == null
                            ? " del ins"
                            : snapshot.getOrder().delInstruction),
                    Divider(
                      thickness: 1,
                    ),
                    listCard("Status", snapshot.getOrder().status,
                        style: GoogleFonts.aBeeZee(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )),
                    listCard(distance, snapshot.getOrder().distance),
                    snapshot.getOrder().priceDistribution.length > 0
                        ? ListView.builder(
                            itemCount:
                                snapshot.getOrder().priceDistribution.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              List<DeliveryChargeClass> _list =
                                  snapshot.getOrder().priceDistribution;
                              return listCard(_list[index].key.toString(),
                                  _list[index].value.toString());
                            })
                        : Container(),
                    Divider(
                      thickness: 1,
                    ),
                    listCard('Total', snapshot.getOrder().dprice.toString(),
                        style: GoogleFonts.aBeeZee(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )),
                    snapshot.getOrder().payment != "null"
                        ? listCard(payment, "Done",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ))
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Consumer<LocalportOrderDelPartnerService>(
                      builder: (context, psnapshot, child) {
                        return psnapshot.isLoading()
                            ? Text(
                                'fetching delivery partner...',
                                style: TextStyle(color: Colors.grey),
                              )
                            : psnapshot.isError()
                                ? Row(
                                    children: [
                                      Text(
                                        'error fetching partner details...  ',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          fetchPartnerDetails();
                                        },
                                        child: Text(
                                          "Try again",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      )
                                    ],
                                  )
                                : psnapshot.isAssigned()
                                    ? ListTile(
                                        title: Text(
                                          "Delivery partner",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Text(psnapshot
                                            .getPartner()
                                            .name
                                            .toString()),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      SelectDeliveryPartnerPage(
                                                          snapshot
                                                              .getOrder()
                                                              .oid))).then(
                                              (value) async {
                                            await Future.delayed(
                                                Duration(milliseconds: 200));
                                            fetchPartnerDetails();
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(
                                            "Delivery partner",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Not assigned"),
                                              Text(
                                                "Select",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ));
                      },
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    snapshot.getOrder().status != "Delivered"
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              onTap: () {
                                updateStatus();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: Offset(0, 0),
                                          blurRadius: 12)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  child: Center(child:
                                      Consumer<OrderStatusButtonService>(
                                          builder: (context, snapshot, child) {
                                    return Text(
                                      "Update status to : ${snapshot.getStatus()}",
                                      maxLines: 3,
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white),
                                    );
                                  })),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    snapshot.getOrder().status == "Delivered"
                        ? snapshot.getOrder().payment == "null"
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    updatePaymentStatus();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: Offset(0, 0),
                                              blurRadius: 12)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: Center(
                                          child: Text(
                                        "Paid",
                                        maxLines: 3,
                                        style: GoogleFonts.aBeeZee(
                                            color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                        : Container(),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
