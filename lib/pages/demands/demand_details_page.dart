import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_admin/DataClasses/demandbox_class.dart';
import 'package:localport_alter_admin/resources/Strings.dart';
import 'package:localport_alter_admin/services/LocalportApiService/LocalportDermandDetailService.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_vendor_user_detailbyid_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DemandDetailsPage extends StatefulWidget {
  @override
  _DemandDetailsPageState createState() => _DemandDetailsPageState();
}

class _DemandDetailsPageState extends State<DemandDetailsPage> {
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

  fetchUserDetails() {
    Provider.of<LocalportVendorUserDetailById>(context, listen: false)
        .fetchDetails(
            Provider.of<LocalportDemandDetailService>(context, listen: false)
                .getDemand()
                .uid)
        .then((value) {
      if (value == '') {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            (SnackBar(content: Text("can't fetch user details right now"))));
      }
    });
  }

  // fetchPartnerDetails() {
  //   Provider.of<LocalportOrderDelPartnerService>(context, listen: false)
  //       .fetchDelPartner(
  //       Provider.of<LocalportOrderDetailsServce>(context, listen: false)
  //           .getOrder()
  //           .oid);
  // }


  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Consumer<LocalportDemandDetailService>(
            builder: (context, snapshot, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CupertinoNavigationBarBackButton(),
                      Text('Demand Details')
                    ],
                  ),
                  Consumer<LocalportVendorUserDetailById>(
                    builder: (context, vsnapshot, child) {
                      if (vsnapshot.isLoading()) {
                        return Text(
                          "Loading user details...",
                          style: GoogleFonts.aBeeZee(color: Colors.red),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Column(
                            children: [
                              vsnapshot.getUserData()['fname'] != null
                                  ? listCard(
                                      'name',
                                      vsnapshot.getUserData()['fname'] +
                                          " " +
                                          vsnapshot.getUserData()['lname'])
                                  : Container(),
                              vsnapshot.getUserData()['mobile'] != null
                                  ? listCard('phone',
                                      vsnapshot.getUserData()['mobile'])
                                  : Container(),
                              vsnapshot.getUserData()['vname'] != null
                                  ? listCard(
                                      vendorname, vsnapshot.getUserData()['vname'])
                                  : Container(),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  listCard('Demand', snapshot.getDemand().demand),
                  listCard('Date', snapshot.getDemand().date.toString()),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
