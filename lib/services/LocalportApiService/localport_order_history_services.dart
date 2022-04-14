import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter_admin/DataClasses/OrderHistoryObjectClass.dart';
import 'package:localport_alter_admin/DataClasses/delivery_charge_class.dart';
import 'package:localport_alter_admin/resources/ServerUrls.dart';

class localportOrderHistoryServices with ChangeNotifier {
  List<OrderHistoryObjectClass> _orders = [];
  bool _loading = true;

  fetchOrders(String status) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      _loading = true;
      _orders.clear();
      notifyListeners();

      Uri url = Uri.parse(getorderbystatus);
      Map<String, String> header = {
        "Content-type": "application/json",
      };
      String body = '{"status":"$status"}';

      post(url, body: body, headers: header).then((response) {
        Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        bool status = data['status'];
        String errorcode = data['errorcode'];
        Map<String, dynamic> orderMap = {};
        if (status) {
          var orderdata = data['data'];
          for (var d in orderdata) {
            orderMap[d['oid']] = {'oid': d['oid']};
          }
          for (var d in orderdata) {
            Map<String, dynamic> _temp =
                orderMap[d['oid']] as Map<String, dynamic>;
            _temp[d['key']] = d['value'];
          }
          for (var val in orderMap.values) {
            String rawdate = val['date'];
            DateTime datee = DateTime.parse(rawdate);
            datee = datee.toLocal();
            String date = DateFormat("dd-MM-yyy hh:mm").format(datee);

            List<DeliveryChargeClass> _deliveryCharges = [];
            if (val['price_distribution'] != null) {
              String h =
              val['price_distribution'].toString().replaceAll('{', '{"');
              h = h.replaceAll(':', '":');
              var priceDistributionObj = json.decode(h);
              for (var d in priceDistributionObj) {
                Map<String, int> _temp = Map<String, int>.from(d);
                _deliveryCharges.add(DeliveryChargeClass(
                    key: _temp.keys.first, value: _temp.values.first));
              }
            }
            _orders.add(
              OrderHistoryObjectClass(
                  weight: val['weight'],
                  // phone: ,
                  id: val['id'],
                  // uid: ,
                  status: val['status'],
                  // fname: ,
                  // lname: ,
                  date: datee,
                  oid: val['oid'],
                  dprice: val['price'],
                  distance: val['distance'],
                  // delInstruction:
                  dropText: val['droploc'],
                  pickutext: val['pickuploc'],
                  // vendorName: ,
                  rName: val['dropname'],
                  rPhone: val['dropphone'],
                  payment: val['payment'].toString(),
                  delInstruction: val['delinstruction'],
                  roundTrip: val['round_trip'] == null
                      ? false
                      : val['round_trip'] == 'true',
                  priceDistribution: _deliveryCharges),
            );
          }
        }
        _orders.sort((a,b)=>b.date.compareTo(a.date));
        // _orders = _orders.reversed.toList();
        _loading = false;
        notifyListeners();
      });
    } catch (err) {
      print(err);
    }
  }

  getOrder() => _orders;

  isLoading() => _loading;
}
