import 'dart:async';
import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:kbeacon/kbeacon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';
export 'package:provider/provider.dart';


class WrapperProvider with ChangeNotifier{
  bool isLoading = false;
  UserProfile? user;

  void finishOnboardingScreen() async{

    await SharedPreferences.getInstance()
    .then((result) {
      result.setBool("welcome", true);
    });
    notifyListeners();
  }

  /// Starts a background process responsible with keeping the connection alive with the device
  /// used only when the user is AUTHENTICATED
  // void startProcess() async{
  //   final service = FlutterBackgroundService();
  //   await service.configure(
  //     iosConfiguration: IosConfiguration(
  //       autoStart: true,
  //       onForeground: onStart,
  //       onBackground: onIosBackground,
  //     ), 
  //     androidConfiguration: AndroidConfiguration(
  //       onStart: onStart, 
  //       autoStart: true,
  //       autoStartOnBoot: true,
  //       isForegroundMode: true
  //     )
  //   );
  // }

  // @pragma('vm:entry-point')
  // Future<bool> onIosBackground(ServiceInstance service) async {
  //   // WidgetsFlutterBinding.ensureInitialized();
  //   // DartPluginRegistrant.ensureInitialized();
  //   SharedPreferences.setMockInitialValues({});
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.reload();
  //   final log = preferences.getStringList('log') ?? <String>[];
  //   log.add(DateTime.now().toIso8601String());
  //   await preferences.setStringList('log', log);

  //   return true;
  // }

  // @pragma('vm:entry-point')
  // void onStart(ServiceInstance service) async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //   await FirebaseFirestore.instance.collection('logs').doc().set({"opened": true, "date": FieldValue.serverTimestamp()});
  //   print("START");
    
  //   if(Platform.isAndroid) SharedPreferencesAndroid.registerWith();
  //   if(Platform.isIOS) SharedPreferencesIOS.registerWith();
  //   // SharedPreferences.setMockInitialValues({});
  //   var sharedPreferances = await SharedPreferences.getInstance();
  //   await sharedPreferances.reload();



  //   // String? macAddress = sharedPreferances.getString("macAddress");
  //   // var macAddress = await FirebaseFirestore.instance.collection('config').doc('config').get().then((doc) => doc.data()!['mac_address']);
  //   // print(macAddress);
  //   // if(macAddress != null) {
  //   //   if(await Kbeacon.connect(macAddress) == "connected"){ 
  //   //     await Future.delayed(Duration(milliseconds: 5000));
  //   //     Kbeacon.enableButtonTrigger(macAddress);
  //   //     Kbeacon.buttonClickEvents.listen((event) {
  //   //       FirebaseFirestore.instance.collection('logs').doc(Timestamp.now().toString()).set({
  //   //         "date_created": FieldValue.serverTimestamp()
  //   //       });
  //   //     });
  //   //   }
  //   // }

  //   if (service is AndroidServiceInstance) {
  //     service.on('setAsForeground').listen((event) {
  //       service.setAsForegroundService();
  //     });

  //     service.on('setAsBackground').listen((event) {
  //       service.setAsBackgroundService();
  //     });
  //   } 

  //   service.on('stopService').listen((event) async{
  //     await FirebaseFirestore.instance.collection('logs').doc('stopped').set({
  //       "date_stopped": FieldValue.serverTimestamp()
  //     });
  //     service.stopSelf();
  //   });

  //   // bring to foreground
  //   Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     if (service is AndroidServiceInstance) {
  //       if (await service.isForegroundService()) {
  //         /// OPTIONAL for use custom notification
  //         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
  //         // flutterLocalNotificationsPlugin.show(
  //         //   888,
  //         //   'COOL SERVICE',
  //         //   'Awesome ${DateTime.now()}',
  //         //   const NotificationDetails(
  //         //     android: AndroidNotificationDetails(
  //         //       'my_foreground',
  //         //       'MY FOREGROUND SERVICE',
  //         //       icon: 'ic_bg_service_small',
  //         //       ongoing: true,
  //         //     ),
  //         //   ),
  //         // );

  //         // if you don't using custom notification, uncomment this
  //         service.setForegroundNotificationInfo(
  //           title: "Echos",
  //           content: "Echos button is available and ready-to-use.",
  //         );
  //       }
  //     }

  //     /// you can see this log in logcat
  //     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

  //     // test using external plugin
  //     final deviceInfo = DeviceInfoPlugin();
  //     String? device;
  //     if (Platform.isAndroid) {
  //       final androidInfo = await deviceInfo.androidInfo;
  //       device = androidInfo.model;
  //     }

  //     if (Platform.isIOS) {
  //       final iosInfo = await deviceInfo.iosInfo;
  //       device = iosInfo.model;
  //     }

  //     service.invoke(
  //       'update',
  //       {
  //         "current_date": DateTime.now().toIso8601String(),
  //         "device": device,
  //       },
  //     );
  //   });  
  //   print("START2");
  // }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}