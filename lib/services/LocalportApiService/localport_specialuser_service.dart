import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class LocalportSpecialUserService with ChangeNotifier {
  String _finalResponse = '';

  setSpecialUser(UserClass user, bool specialUser) async {
    Uri url = Uri.parse(setspecialuser);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"uid":"${user.uid}", "specialuser":"$specialUser"}';

    Response response = await post(url, headers: header, body: body);

    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      bool status = responseData['status'];
      String message = responseData['message'];
      _finalResponse = message;
    }
  }

  getFinalResponse() => _finalResponse;
}
