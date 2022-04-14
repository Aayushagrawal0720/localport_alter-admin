import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class SelectDeliveryPartnerService with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;

  Future setDeliveryPartner(String oid, String partnerid) async {
    await Future.delayed(Duration(milliseconds: 200));
    _isLoading = true;
    _isError = false;
    notifyListeners();

    Uri url = Uri.parse(setdelpartner);
    Map<String, String> header = {
      "Content-type": "application/json",
    };

    String body = '{"oid":"$oid", "partnerid":"$partnerid"}';

    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      if (status) {
        _isLoading = false;
        _isError = false;
      } else {
        _isLoading = false;
        _isError = true;
      }
    } else {
      _isLoading = false;
      _isError = true;
    }

    notifyListeners();
    return;
  }

  isLoading() => _isLoading;

  isError() => _isError;
}
