import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class LocalportOrderStatusUpdateService with ChangeNotifier {
  Future updateStatus(String oid, String status, String uid) async {
    Uri url = Uri.parse(updateorderstatus);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"oid":"$oid", "status":"$status", "uid":"$uid"}';
    Response response = await post(url, headers: header, body: body);
    var data = json.decode(response.body);
    bool resStatus = data['status'];
    String errorcode = data['errorcode'];


    return errorcode;
  }
}
