
import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kbeacon/kbeacon.dart';
export 'package:provider/provider.dart';

class DevicesPageProvider with ChangeNotifier{
  Set<BluetoothDevice> discoveredDevices = {};
  List<BluetoothDevice> connectedDevices = [];
  FlutterReactiveBle bluetooth = FlutterReactiveBle();
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // Stream<DiscoveredDevice>? scannedDevicesStream;
  bool isSearching = false;

  DevicesPageProvider(){
    getData();
  }

  void startScanning(){
    isSearching = true;
    discoveredDevices.clear();
    flutterBlue.scan().listen((scanResult) {
      if(isKBeaconDevice(scanResult.device))
        discoveredDevices.add(scanResult.device);
      notifyListeners();
    });
    // scannedDevicesStream = FlutterReactiveBle().scanForDevices(withServices: []);
    // scannedDevicesStream!.listen((DiscoveredDevice device) {
    //   discoveredDevices.add(device);
    //   notifyListeners();
    // });
    notifyListeners();
  }

  void stopScanning(){
    isSearching = false;
    flutterBlue.stopScan();

    notifyListeners();
  }

  Future<void> getData() async{
    
    //startScanning();

    Stream.periodic(Duration(milliseconds: 2000)).listen((_) async{
      await flutterBlue.connectedDevices.then((devices) => this.connectedDevices = devices);  
      notifyListeners();
    });

    // bluetooth.connectedDeviceStream.listen((connectionStateUpdate) {
    //   if(connectionStateUpdate.connectionState == DeviceConnectionState.connected)
    //     connectedDevices.add(connectionStateUpdate.deviceId);
    //     notifyListeners();
    // });

    notifyListeners();
  }

  bool isKBeaconDevice(BluetoothDevice device){
    if(device.name.startsWith("KB"))
      return true;
    return false;
  }

  void connect(BuildContext context, String macAddress) async{
    bluetooth.connectToDevice(id: macAddress);
    if(await Kbeacon.connect(macAddress) == "connected"){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Device has been successfuly connected"),));
      await Future.delayed(Duration(milliseconds: 5000));
      Kbeacon.enableButtonTrigger(macAddress);
      Kbeacon.buttonClickEvents.listen((event) {
        FirebaseFirestore.instance.collection('users').doc(Authentication.auth.currentUser!.uid).collection('logs').doc(Timestamp.now().toString()).set({
          "date_created": FieldValue.serverTimestamp(),
          "device_id": macAddress,
        });
      });
    }

    notifyListeners();
  }
}