import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_allpartners_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_order_delpartner_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_select_delivery_partner_service.dart';
import 'package:provider/provider.dart';

class SelectDeliveryPartnerPage extends StatefulWidget {
  String oid;

  SelectDeliveryPartnerPage(this.oid);

  @override
  _SelectDeliveryPartnerPageState createState() =>
      _SelectDeliveryPartnerPageState();
}

class _SelectDeliveryPartnerPageState extends State<SelectDeliveryPartnerPage> {
  List<UserClass> _users = [];

  fetchPartners() async {
    Provider.of<LocalportAllPartnersService>(context, listen: false)
        .fetchPartners();
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  popFunction() async {
    await Future.delayed(Duration(milliseconds: 200));
    Navigator.pop(context);
  }

  updateDelPartner(int index) {
    showLoadingDIalog();
    var snapshot =
        Provider.of<SelectDeliveryPartnerService>(context, listen: false);
    snapshot.setDeliveryPartner(widget.oid, _users[index].uid).then((value) {
      if (!snapshot.isLoading()) {
        Navigator.pop(context);
        if (snapshot.isError()) {
          showFailMessage("Some error occurred");
        } else {
          popFunction();
        }
      }
    });
  }

  showLoadingDIalog() {
    var dialog = Dialog(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text('Updating Delivery partner...'),
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  Widget _appBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: const [
              CupertinoNavigationBarBackButton(
                color: Colors.black,
              ),
              Text(
                "Select delivery partners",
                style: TextStyle(color: Colors.black, fontSize: 20),
              )
            ],
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }

  Widget _partnersList() {
    return Consumer<LocalportAllPartnersService>(
        builder: (context, snapshot, child) {
      _users = snapshot.getPartners();

      return snapshot.isLoading()
          ? CircularProgressIndicator()
          : Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    String _date = _users[index].joiningDate;
                    String date;
                    if (_date != null && _date != 'null') {
                      DateTime datee = DateTime.parse(_date);
                      datee = datee.toLocal();
                      date = DateFormat("dd-MM-yyy hh:mm").format(datee);
                    }
                    return ListTile(
                      onTap: () {
                        updateDelPartner(index);
                      },
                      title: Text(_users[index].name),
                      subtitle: Text(date.toString()),
                    );
                  }));
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [_appBar(), _partnersList()],
        ),
      )),
    );
  }
}
