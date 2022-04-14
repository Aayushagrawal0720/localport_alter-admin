import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class LocalportVendorUserDetailById with ChangeNotifier {
  Map<String, String> _userProfile = Map();
  bool _loading = false;

  fetchDetails(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    _loading = true;
    _userProfile.clear();
    notifyListeners();

    Uri url = Uri.parse(getuserbyid);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"id":"$id"}';
    Response response = await post(url, headers: header, body: body);
    var data = json.decode(response.body);
    bool status = data['status'];
    String errorcode = data['errorcode'];
    if (status) {
      var userdata = data['data'];
      for (var u in userdata) {
        if (u['uid'] != null) _userProfile['uid'] = u['uid'];

        _userProfile[u['key']] = u['value'];
      }
    }
    _loading = false;
    notifyListeners();
    return errorcode;
  }

  isLoading() => _loading;

  Map<String, String> getUserData() => _userProfile;
}
