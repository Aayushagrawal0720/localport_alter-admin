import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/resources/CustomException.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class LocalportAllUserService with ChangeNotifier {
  Map<String, dynamic> _userMap = {};
  List<UserClass> _users = [];
  bool _loading = true;

  Future fetchUsers(String usertype, String status) async {
    // try {
    await Future.delayed(Duration(milliseconds: 200));
    _loading = true;
    _users.clear();
    _userMap.clear();
    notifyListeners();

    Uri url = Uri.parse(allusers);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"status":"$status","usertype":"$usertype"}';

    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool resStatus = responseData['status'];
      String message = responseData['message'];
      if (resStatus) {
        var userData = responseData['data'];
        // debugPrint(userData.toString());
        // _getMapObject(userData);
        for (var d in userData) {
          if (d['uid'] != null) {
            _userMap[d['uid']] = {"uid": "${d['uid']}"};
          }
        }
        for (var d in userData) {
          if (d['uid'] != null) {
            Map<String, dynamic> _temp =
                _userMap[d['uid']] as Map<String, dynamic>;
            _temp[d['key']] = d['value'];
          }
          if (d['vid'] != null) {
            if (d['key'] == 'uid') {
              String uid = d['value'];
              Map<String, dynamic> _temp =
                  _userMap[uid] as Map<String, dynamic>;
              _temp['vid'] = d['vid'];
            }
          }
        }
        if (status != 'Individual') {
          for (var u in _userMap.values) {
            String vid = u['vid'];
            String uid = u['uid'];
            for (var d in userData) {
              if (d['vid'] != null && d['vid'] == vid) {
                Map<String, dynamic> _temp =
                    _userMap[uid] as Map<String, dynamic>;
                _temp[d['key']] = d['value'];
              }
            }
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
              isSpecialUser: u['special_user'] == null
                  ? false
                  : u['special_user'] == 'true'
                      ? true
                      : false));
        }
        _loading = false;
        notifyListeners();
      } else {
        throw CustomException(message);
      }
    } else {
      throw CustomException("Execution error");
    }
    // } catch (err) {
    //   print(err);
    //   return err;
    // }
  }

  updateSpecialUser(int index, bool special){
    _users[index].isSpecialUser=special;
    notifyListeners();
  }

  _getMapObject(var userData) {
    for (var d in userData) {
      _userMap[d['uid']] = {"uid": "${d['uid']}"};
    }
    for (var d in userData) {
      Map<String, dynamic> _temp = _userMap[d['uid']] as Map<String, dynamic>;
      _temp['key'] = d['value'];
    }
  }

  isLoading() => _loading;

  getUsers() => _users;
}
