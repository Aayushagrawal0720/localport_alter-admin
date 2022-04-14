import 'package:flutter/cupertino.dart';

class AlluserPageService with ChangeNotifier{

  String _status="All";
  String _orderHistorySearchType='Individual';
  setStatus(String status){
    _status=status;
    notifyListeners();
  }

  setOrderHistorySearchType(String type){
    _orderHistorySearchType=type;
    notifyListeners();
  }

  getOrderHistorySearchStatus()=>_status;

  getOrderHistorySearchType()=>_orderHistorySearchType;
}