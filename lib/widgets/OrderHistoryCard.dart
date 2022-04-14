import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter_admin/DataClasses/OrderHistoryObjectClass.dart';
import 'package:localport_alter_admin/pages/orders/OrderDetailPage.dart';
import 'package:localport_alter_admin/resources/MyColors.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_detail_service.dart';
import 'package:localport_alter_admin/services/order_status_button_service.dart';
import 'package:provider/provider.dart';

class OrderHistoryCard extends StatefulWidget {
  OrderHistoryObjectClass _historyObjectClass = OrderHistoryObjectClass();

  OrderHistoryCard(this._historyObjectClass);

  @override
  _OrderHistoryCardState createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  showVendorDialog(String status) {
    var dialog = Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              status == 'Pending' ? "Very soon..." : "On The Way...",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            Text(
              status == 'Pending'
                  ? "A delivery partner will be assigned soon"
                  : "A delivery partner will be at your location in no time",
              style: GoogleFonts.aBeeZee(color: MyColors.fontgrey),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.color1,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Text(
                        "Close",
                        style: GoogleFonts.aBeeZee(color: Colors.white),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
    showCupertinoDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          Provider.of<LocalportOrderDetailsServce>(context, listen: false)
              .setOrder(widget._historyObjectClass);
          var _osbs =
              Provider.of<OrderStatusButtonService>(context, listen: false);
          switch (widget._historyObjectClass.status) {
            case 'Pending':
              {
                _osbs.setStatus('Way to pick up');
                break;
              }
            case 'Way to pick up':
              {
                _osbs.setStatus('On the way');
                break;
              }
            case 'On the way':
              {
                _osbs.setStatus('Delivered');
                break;
              }
          }
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => OrderDetailPage()));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    blurRadius: 12,
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(
                      0,
                      0,
                    ))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget._historyObjectClass.rName != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Receiver",
                                  style: GoogleFonts.aBeeZee(
                                      color: MyColors.fontgrey, fontSize: 12),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: Text(
                                    widget._historyObjectClass.rName,
                                    maxLines: 3,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pickup",
                            style: GoogleFonts.aBeeZee(
                                color: MyColors.fontgrey, fontSize: 12),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/4,
                            child: Text(
                              widget._historyObjectClass.pickutext.split(",")[0],
                              maxLines: 5,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Drop",
                            style: GoogleFonts.aBeeZee(
                                color: MyColors.fontgrey, fontSize: 12),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/4,
                            child: Text(
                              widget._historyObjectClass.dropText.split(",")[0],
                              maxLines: 5,
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Weight",
                            style: GoogleFonts.aBeeZee(
                                color: MyColors.fontgrey, fontSize: 12),
                          ),
                          Text(
                            widget._historyObjectClass.weight,
                            style: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // widget._historyObjectClass.resamt==null? Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Value",
                      //       style: GoogleFonts.aBeeZee(
                      //           color: MyColors.fontgrey, fontSize: 12),
                      //     ),
                      //     Text(
                      //       widget._historyObjectClass.resamt,
                      //       style: GoogleFonts.aBeeZee(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ):Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 12, bottom: 12),
                  child: Divider(
                    height: 1,
                    color: MyColors.fontgrey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              color: MyColors.fontgrey,
                              fontSize: 16),
                        ),
                        Text(
                          widget._historyObjectClass.status,
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              color: widget._historyObjectClass.status ==
                                      'Delivered'
                                  ? Colors.green
                                  : widget._historyObjectClass.status ==
                                          'Cancelled'
                                      ? Colors.red
                                      : MyColors.yellow,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    widget._historyObjectClass.roundTrip
                        ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow:[
                            BoxShadow(
                                color: Colors.grey.withAlpha(35),
                                offset: Offset(0, 0),
                                blurRadius: 3
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Round trip",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                        : Container(),
                    Text(
                      DateFormat("dd-MM-yyy hh:mm").format(widget._historyObjectClass.date),
                      style: GoogleFonts.aBeeZee(
                        color: MyColors.fontgrey,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
