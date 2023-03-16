import 'package:country_list/country_list.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Device{
  String macAddress;
  String name;
  bool connected;
  BluetoothDevice? device;
  bool? isConfigured;
  Map<String, dynamic> configurations;

  static Map<String, dynamic> get emptyConfigurations => {
    "on_press" : false,
    "email": "",
    "email_message": "I might be in danger",
    "call_phone_number_prefix": "${Countries.list.first.dialCode}",
    "call_phone_number": "",
    "sms_phone_number_prefix": "${Countries.list.first.dialCode}",
    "sms_phone_number": "",
    "sms_message": "I might be in danger"
  };

  factory Device.fromBluetoothDevice(BluetoothDevice device){
    return Device(
      macAddress: device.id.id,
      connected: true,
      name: device.name,
      device: device, 
      isConfigured: false,
      configurations: Device.emptyConfigurations
    );
  }
  
  factory Device.fromPairedDevice(String macAddress, String name, bool connected, bool isConfigured, Map<String, dynamic> configurations){
    return Device(
      macAddress: macAddress,
      name: name,
      connected: connected,
      device: null,
      isConfigured: isConfigured,
      configurations: configurations
    );
  }

  Device({required this.macAddress, required this.name, required this.device, required this.connected, required this.isConfigured, required this.configurations});
}

Device bluetoothDeviceToDevice(String macAddress, BluetoothDevice? device, bool isConfigured, bool connected, String name, Map<String, dynamic> configurations){
  return Device(
    macAddress: macAddress,
    connected: connected,
    name: name,
    device: device, 
    isConfigured: isConfigured,
    configurations: configurations
  );
}
