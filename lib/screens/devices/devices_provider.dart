
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
export 'package:provider/provider.dart';

class DevicesPageProvider with ChangeNotifier{
  List devices = [];

  DevicesPageProvider(){
    getData();
  }

  Future<void> getData() async{
    FlutterBlue.instance.startScan(

    ); 

    notifyListeners();
  }
}