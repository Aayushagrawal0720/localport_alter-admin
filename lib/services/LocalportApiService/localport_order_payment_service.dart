import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class LocalportOrderPaymentService  with ChangeNotifier{

  Future setPayment(String oid) async {
    Uri url = Uri.parse(setorderpayment);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"oid":"$oid"}';

    Response response = await post(url, headers: header, body: body);
    var data =json.decode(response.body);
    bool status = data['status'];
    String errorcode= data['errorcode'];

    return errorcode;
  }
}