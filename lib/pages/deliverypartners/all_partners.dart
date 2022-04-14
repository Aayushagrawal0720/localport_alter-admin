import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_allpartners_service.dart';
import 'package:provider/provider.dart';

class AllPartners extends StatefulWidget {
  @override
  _AllPartnersState createState() => _AllPartnersState();
}

class _AllPartnersState extends State<AllPartners> {
  List<UserClass> _users = [];

  fetchPartners() async {
    Provider.of<LocalportAllPartnersService>(context, listen: false)
        .fetchPartners();
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
                "All Partners",
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
                      title: Text(_users[index].name),
                      subtitle: Text(date.toString()),
                      trailing: Text("10 deliveries"),
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
