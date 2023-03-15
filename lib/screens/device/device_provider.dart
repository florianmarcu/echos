import 'package:echos/models/models.dart';
import 'package:echos/screens/devices/devices_provider.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class DevicePageProvider with ChangeNotifier{
  Device device;
  DevicesPageProvider devicesPageProvider;
  BuildContext context;
  bool isLoading = false;

  DevicePageProvider(this.device, this.context, this.devicesPageProvider);

  Future<void> disconnect() async{
    _loading();
    await devicesPageProvider.disconnect(device.macAddress, context);
    _loading();
  }

  Future<bool> connect() async{
    _loading();
    var result = await devicesPageProvider.connect(context, device.macAddress, device.name);
    _loading();

    return result;
  }
  
  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}