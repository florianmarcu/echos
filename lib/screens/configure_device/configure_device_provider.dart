import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConfigureDevicePageProvider with ChangeNotifier{
  BluetoothDevice device;

  ConfigureDevicePageProvider(this.device);

  
} 