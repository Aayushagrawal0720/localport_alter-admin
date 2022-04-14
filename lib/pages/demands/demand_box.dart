import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localport_alter_admin/DataClasses/demandbox_class.dart';
import 'package:localport_alter_admin/pages/demands/demand_details_page.dart';
import 'package:localport_alter_admin/services/LocalportApiService/LocalportDermandDetailService.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_alldemand_service.dart';
import 'package:provider/provider.dart';

class DemandBoxPage extends StatefulWidget {
  @override
  _DemandBoxPageState createState() => _DemandBoxPageState();
}

class _DemandBoxPageState extends State<DemandBoxPage> {
  List<DemandBoxClass> _demandList = [];

  Widget _demandItem(DemandBoxClass _demand) {
    return GestureDetector(
      onTap: () {
        Provider.of<LocalportDemandDetailService>(context, listen: false).setDemand(_demand);
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => DemandDetailsPage()));
      },
      child: Column(
        children: [
          ListTile(
            title: Text(_demand.demand),
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _allDemands() {
    return Consumer<LocalportAllDemandService>(
        builder: (context, snapshot, child) {
      if (!snapshot.isLoading()) {
        if (snapshot.getStatus()) {
          _demandList = snapshot.getDemandList();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(snapshot.getMessage())));
        }
      }
      return snapshot.isLoading()
          ? Container(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _demandList.length,
              itemBuilder: (BuildContext context, int index) {
                return _demandItem(_demandList[index]);
              },
            );
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocalportAllDemandService>(context, listen: false)
        .fetchAllDemands('All');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CupertinoNavigationBarBackButton(
                    color: Colors.black,
                  ),
                  Text(
                    "Demand box",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            _allDemands()
          ],
        ),
      )),
    );
  }
}
