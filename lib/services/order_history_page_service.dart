import 'package:flutter/cupertino.dart';

class OrderHistoryPageService with ChangeNotifier{

  String _status="Pending";
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