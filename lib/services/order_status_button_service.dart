import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class OrderStatusButtonService with ChangeNotifier {
  String _status = '';

  setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  getStatus() => _status;
}
