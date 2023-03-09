
import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list/country_list.dart';
import 'package:echos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kbeacon/kbeacon.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:provider/provider.dart';

class DevicesPageProvider with ChangeNotifier{
  Set<BluetoothDevice> discoveredDevices = {};
  List<BluetoothDevice> connectedDevices = [];
  List<Device> pairedDevices = [];
  FlutterReactiveBle bluetooth = FlutterReactiveBle();
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // Stream<DiscoveredDevice>? scannedDevicesStream;
  bool isSearching = false;
  bool isLoading = false;
  bool isAnimating = false;

  DevicesPageProvider(){
    getData();
  }

  Future<bool> startScanning() async{
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

    return true;
  }

  void stopScanning(){
    isSearching = false;
    flutterBlue.stopScan();

    notifyListeners();
  }

  Future<void> getData() async{
    
    //startScanning();
    //await getPairedDevices();

    Stream.periodic(Duration(milliseconds: 500)).listen((_) {
      getPairedDevices();
    });

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

  Future<void> updateIsAnimating() async{
    isAnimating = !isAnimating;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 500));
    //return null;
  }

  bool isKBeaconDevice(BluetoothDevice device){
    if(device.name.startsWith("KB"))
      return true;
    return false;
  }

  Future<bool> connect(BuildContext context, String macAddress, String name) async{
    _loading();
    //bluetooth.connectToDevice(id: macAddress);
    if(await Kbeacon.connect(macAddress) == "connected"){
      /// Device is connected
      await Future.delayed(Duration(milliseconds: 5000));
      await Kbeacon.enableButtonTrigger(macAddress);
      Kbeacon.buttonClickEvents.listen((event) {
        FirebaseFirestore.instance.collection('users').doc(Authentication.auth.currentUser!.uid).collection('logs').doc(Timestamp.now().toString()).set({
          "date_created": FieldValue.serverTimestamp(),
          "device_id": macAddress,
        });
      });
    }
    else {
      /// Device did not connect
      _loading();
      notifyListeners();
      return false;
    }

    ///Save device to Shared Preferences
    await registerDeviceLocally(macAddress, name);
    
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Device has been successfuly connected"),));
    
    _loading();
    notifyListeners();
    return true;
  }

  ///Save device to shared preferences
  Future<void> registerDeviceLocally(String macAddress, String name) async{
    var sharedPreferences = await SharedPreferences.getInstance();
    ///Get the device count
    int? currentDeviceCount = sharedPreferences.getInt('paired_device_count') ?? 0;

    await sharedPreferences.setString('paired_device_${currentDeviceCount}', macAddress);
    await sharedPreferences.setString('paired_device_${currentDeviceCount}_name', name);
    await sharedPreferences.setBool('paired_device_${currentDeviceCount}_configured', false);
    await sharedPreferences.setInt('paired_device_count', currentDeviceCount + 1);
  }

  /// Fetches all paired devices (which the user connected to in the past)
  Future<void> getPairedDevices() async{

    List<Device> pairedDevices = [];

    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.reload();
    /// Get paired devices count
    var deviceCount = sharedPreferences.getInt("paired_device_count");
    if(deviceCount != null){
      for(int i = 0; i < deviceCount; i++){
        var macAddress = sharedPreferences.getString('paired_device_${i}');
        var name = sharedPreferences.getString('paired_device_${i}_name');
        // print(macAddress);
        //if(macAddress != null && macAddress == device.macAddress) {
          var configured = sharedPreferences.getBool("paired_device_${i}_configured");
          Map<String, dynamic>? configuration;
          if(configured != null && configured == true){
            configuration = {
              "on_press" : sharedPreferences.getBool("paired_device_${i}_on_press") ?? false,
              "email": sharedPreferences.getString("paired_device_${i}_email") ?? "",
              "email_message": sharedPreferences.getString("paired_device_${i}_email_message") ?? "",
              "call_phone_number_prefix": sharedPreferences.getString("paired_device_${i}_call_phone_number_prefix") ?? "+40",
              "call_phone_number": sharedPreferences.getString("paired_device_${i}_call_phone_number") ?? "",
              "sms_phone_number_prefix": sharedPreferences.getString("paired_device_${i}_sms_phone_number_prefix") ?? "+40",
              "sms_phone_number": sharedPreferences.getString("paired_device_${i}_sms_phone_number") ?? "",
              "sms_message": sharedPreferences.getString("paired_device_${i}_sms_message") ?? ""
            };
          }
          else {
            configuration = Device.emptyConfigurations;
          }
        pairedDevices.add(
          Device.fromPairedDevice(
            macAddress ?? "",
            name ?? "",
            connectedDevices.indexWhere((device) => device.id.id == macAddress) != -1 ? true : false,
            configured ?? false,
            configuration
          )
        );
      }
    }

    this.pairedDevices = List.from(pairedDevices);

    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}
