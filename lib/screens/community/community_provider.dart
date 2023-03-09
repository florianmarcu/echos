import 'package:echos/models/models.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class CommunityPageProvider with ChangeNotifier{
  List<Alert> recentAlerts = [];
  bool isLoading = false;

  CommunityPageProvider(){
    getData();
  } 

  Future<void> getData() async{
    _loading();

    recentAlerts;

    notifyListeners();
    _loading();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}