import 'package:flutter/cupertino.dart';
import 'package:localport_alter_admin/DataClasses/demandbox_class.dart';

class LocalportDemandDetailService with ChangeNotifier {
  DemandBoxClass _demand;

  setDemand(DemandBoxClass demand) {
    _demand = demand;
    notifyListeners();
  }

  getDemand() => _demand;
}
