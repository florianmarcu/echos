
import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kbeacon/kbeacon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
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

    // var permissionGranted = await askLocationPermissions();
    // // if(!permissionGranted)
    //   return false;

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

      if(!checkDeviceAlreadyPaired(macAddress)){
        /// Register the newly connected device into Firestore
        FirebaseFirestore.instance
        .collection('users')
        .doc(Authentication.auth.currentUser!.uid)
        .collection('devices')
        .doc(macAddress)
        .set({
          "mac_address": macAddress,
          "id": macAddress,
          "name": name,
          "date_registered": FieldValue.serverTimestamp(),
          "configured": false
        }, SetOptions(merge: true));

        ///Save device to Shared Preferences
        await registerDeviceLocally(macAddress, name);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Device has been successfuly connected"),));
      
      Kbeacon.buttonClickEvents.listen((currentMacAddress) async{
        var sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.reload();

        // get device index
        int deviceCount = sharedPreferences.getInt('paired_device_count') ?? 0;
        int? i;
        for(int j = 0; j < deviceCount; j++){
          var jMacAddress = sharedPreferences.getString('paired_device_$j');
          if(jMacAddress == macAddress)
            i = j;
        }
        if(i != null){
          /// Get button settings
          var configured = sharedPreferences.getBool("paired_device_${i}_configured");
          print(configured);
          print(sharedPreferences.getString("paired_device_${i}_email"));
          if(configured != null && configured == true){
            var onPress = sharedPreferences.getBool("paired_device_${i}_on_press");
            if(onPress != null && onPress == true){
              var email = sharedPreferences.getString("paired_device_${i}_email");
              var emailMessage = sharedPreferences.getString("paired_device_${i}_email_message");
              var callPhoneNumberPrefix = sharedPreferences.getString("paired_device_${i}_call_phone_number_prefix");
              var callPhoneNumber = sharedPreferences.getString("paired_device_${i}_call_phone_number");
              var smsPhoneNumberPrefix = sharedPreferences.getString("paired_device_${i}_sms_phone_number_prefix");
              var smsPhoneNumber = sharedPreferences.getString("paired_device_${i}_sms_phone_number");
              var smsMessage = sharedPreferences.getString("paired_device_${i}_sms_message");
              /// Create document for alert in Firestore 
              /// Automatically sends EMAIL and SMS
              var alertDocReference = FirebaseFirestore.instance
              .collection('users')
              .doc(Authentication.auth.currentUser!.uid)
              .collection('devices')
              .doc(currentMacAddress)
              .collection('alerts')
              .doc();
              await alertDocReference
              .set({
                "date_created": FieldValue.serverTimestamp(),
                "device_id": currentMacAddress,
                "email": email,
                "email_message": emailMessage,
                "call_phone_number": callPhoneNumber,
                "call_phone_number_prefix": callPhoneNumberPrefix,
                "sms_phone_number": smsPhoneNumber,
                "sms_phone_number_prefix": smsPhoneNumberPrefix,
                "sms_message": smsMessage
              }, SetOptions(merge: true));
              /// CALL phone number
              // try{
              //   launchUrlString("tel:${callPhoneNumberPrefix}${callPhoneNumber}");
              // }
              // catch(err){
              //   FirebaseFirestore.instance
              //   .collection('users')
              //   .doc(Authentication.auth.currentUser!.uid)
              //   .collection('devices')
              //   .doc(macAddress)
              //   .collection('alerts')
              //   .doc(alertDocReference.id)
              //   .set({
              //     "dial_phone_number_error": err.toString()
              //   }, SetOptions(merge: true));
              // }
              //await sendSMS(message: smsMessage ?? "I am in danger", recipients: [smsPhoneNumberPrefix!+smsPhoneNumber!]);
            }
          }
        }
      });
    }
    
    else {
      /// Device did not connect
      _loading();
      notifyListeners();
      return false;
    }
    
    _loading();
    notifyListeners();
    return true;
  }

  Future<void> disconnect(String macAddress, BuildContext context) async{
    _loading();

    await Kbeacon.disconnect(macAddress);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Device has been successfuly disconnected"),));

    _loading();
    notifyListeners();
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

  bool checkDeviceAlreadyPaired(String macAddress){
    return pairedDevices.where((device) => device.macAddress == macAddress).length > 0
    ? true
    : false;
  }

  Future<bool> askLocationPermissions() async{
    print(await Permission.locationWhenInUse.status);
    // print(await BackgroundLocation.startLocationService());
    // Permission.locationWhenInUse
    return false;
    var status = await Permission.locationWhenInUse.request();
    switch (status){
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        return false;
      default: return false;
    }
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}
