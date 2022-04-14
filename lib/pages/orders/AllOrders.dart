import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_admin/DataClasses/OrderHistoryObjectClass.dart';
import 'package:localport_alter_admin/resources/MyColors.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_history_services.dart';
import 'package:localport_alter_admin/services/order_history_page_service.dart';
import 'package:localport_alter_admin/widgets/OrderHistoryCard.dart';
import 'package:provider/provider.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({Key key}) : super(key: key);

  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  List<OrderHistoryObjectClass> _orders = [];

  fetchOrders() async {
    try {
      String status =
          Provider.of<OrderHistoryPageService>(context, listen: false)
              .getOrderHistorySearchStatus();

      Provider.of<localportOrderHistoryServices>(context, listen: false)
          .fetchOrders(status);
    } catch (err) {
      print(err);
      showFailMessage("Please try again after sometime");
    }
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget orderList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer<localportOrderHistoryServices>(
          builder: (context, snapshot, child) {
        _orders = snapshot.getOrder();
        return snapshot.isLoading()
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: MyColors.color1,
                  ),
                ),
              )
            : _orders.length == 0
                ? Container(
                    child: Center(
                        child: Text(
                      "No record found",
                      style: GoogleFonts.aBeeZee(),
                    )),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          return OrderHistoryCard(_orders[index]);
                        }),
                  );
      }),
    );
  }

  Widget historyType() {
    return Consumer<OrderHistoryPageService>(
        builder: (context, snapshot, child) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: MyColors.color1)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: DropdownButton<String>(
                      elevation: 0,
                      onChanged: (val) {
                        snapshot.setStatus(val);
                        fetchOrders();
                      },
                      value: snapshot.getOrderHistorySearchStatus(),
                      items: <String>[
                        'Pending',
                        'Way to pick up',
                        'On the way',
                        'Delivered'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
            orderList()
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.color4,
        title: Text(
          "Order History",
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child:
              Padding(padding: const EdgeInsets.all(8.0), child: historyType()),
        ),
      )),
    );
  }
}
