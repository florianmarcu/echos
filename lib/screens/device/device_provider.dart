import 'package:echos/models/models.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class DevicePageProvider with ChangeNotifier{
  Device device;

  DevicePageProvider(this.device);

  
}