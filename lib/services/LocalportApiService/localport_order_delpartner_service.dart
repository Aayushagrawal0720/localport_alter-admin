import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';
import 'package:localport_alter_admin/resources/Strings.dart';

class LocalportOrderDelPartnerService with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  bool _assigned = true;
  Map<String, dynamic> _userMap = {};
  UserClass _partner;

  fetchDelPartner(String oid) async {
    await Future.delayed(Duration(milliseconds: 200));
    _isLoading = true;
    _isError = false;
    _assigned=true;
    notifyListeners();

    Uri url = Uri.parse(getorderpartner);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"oid":"${oid}"}';
    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String _resMessage = responseData['message'];
      if (status) {
        if (_resMessage != orderPartnerResponseMessage) {
          var partnerData = responseData['data'];
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
            _partner = UserClass(
                uid: u['uid'],
                name: u['fname'] + " " + u['lname'],
                mobile: u['mobile'],
                isvendor: u['isvendor'].toString() == true.toString(),
                vname: u['vname'],
                vabout: u['vabout'],
                logo: u['logo'],
                wallet: u['wallet'],
                joiningDate: u['joinning_date']);
          }
        } else {
          _assigned = false;
        }
        _isLoading = false;
        _isError = false;
      }else{
        _isLoading = false;
        _isError = true;
      }
    } else {
      _isLoading = false;
      _isError = true;
    }
    notifyListeners();
  }

  isLoading() => _isLoading;

  isError() => _isError;

  UserClass getPartner() => _partner;

  isAssigned() => _assigned;
}
