import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class LocalportAllPartnersService with ChangeNotifier {
  bool _isLoading = true;
  Map<String, dynamic> _userMap = {};
  List<UserClass> _users = [];

  fetchPartners() async {

    await Future.delayed(Duration(milliseconds: 200));
    _isLoading=true;
    _users.clear();
    _userMap.clear();
    notifyListeners();

    Uri url = Uri.parse(allpartners);
    Map<String, String> header = {
      "Content-type": "application/json",
    };

    Response response = await get(url, headers: header);
    print(response.body);
    var resData = json.decode(response.body);
    bool status = resData['status'];
    if (status) {
      var partnerData = resData['data'];
      for (var d in partnerData) {
        if (d['uid'] != null) {
          _userMap[d['uid']] = {"uid": "${d['uid']}"};
        }
      }

      for (var d in partnerData) {
        if (d['uid'] != null) {
          Map<String, dynamic> _temp =
              _userMap[d['uid']] as Map<String, dynamic>;
          _temp[d['key']] = d['value'];
        }
      }
      for (var u in _userMap.values) {
        _users.add(UserClass(
            uid: u['uid'],
            name: u['fname'] + " " + u['lname'],
            mobile: u['mobile'],
            isvendor: u['isvendor'].toString() == true.toString(),
            vname: u['vname'],
            vabout: u['vabout'],
            logo: u['logo'],
            wallet: u['wallet'],
            joiningDate: u['joinning_date']));
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  getPartners() => _users;

  isLoading() => _isLoading;
}
