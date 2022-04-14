import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter_admin/DataClasses/demandbox_class.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class LocalportAllDemandService with ChangeNotifier {
  List<DemandBoxClass> _demands = [];
  bool _status = false;
  String _message = '';
  bool _loading = true;

  fetchAllDemands(String status) async {
    await Future.delayed(Duration(milliseconds: 200));
    _loading = true;
    _demands.clear();
    notifyListeners();

    Uri url = Uri.parse(alldemands);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"status":"$status"}';

    Response response = await post(url, headers: header, body: body);

    print(response.body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      _status = responseData['status'];
      _message = responseData['message'];
      if (_status) {
        var data = responseData['data'];
        Map<String, dynamic> demandMap = {};
        for (var d in data) {
          demandMap[d['did']] = {'did': d['did']};
        }
        for (var d in data) {
          Map<String, dynamic> _temp =
              demandMap[d['did']] as Map<String, dynamic>;
          _temp[d['key']] = d['value'];
        }
        for (var val in demandMap.values) {
          String rawdate = val['date'];
          DateTime datee = DateTime.parse(rawdate);
          datee = datee.toLocal();
          String date = DateFormat("dd-MM-yyy hh:mm").format(datee);

          _demands.add(DemandBoxClass(
              did: val['did'],
              date: datee,
              demand: val['demand'],
              uid: val['uid']));
        }
        _demands.sort((a, b) => b.date.compareTo(a.date));
        _loading = false;
        notifyListeners();
      } else {
        notifyListeners();
      }
    }
  }

  getStatus() => _status;

  getMessage() => _message;

  getDemandList() => _demands;

  isLoading() => _loading;
}
