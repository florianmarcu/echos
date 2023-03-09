import 'package:echos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
export 'package:provider/provider.dart';

class DevicePageProvider with ChangeNotifier{
  BluetoothDevice device;

  DevicePageProvider(this.device);

  
}