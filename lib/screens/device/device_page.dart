import 'package:echos/screens/device/device_provider.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DevicePageProvider>();
    var device = provider.device;
    return Scaffold(
      appBar: AppBar(
        title: Text("${device.name}"),
      ),
    );
  }
}