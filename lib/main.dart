import 'dart:async';
import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_codes/country_codes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:echos/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:kbeacon/kbeacon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';
import 'screens/wrapper/wrapper.dart';
import 'screens/wrapper/wrapper_provider.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';


void main() async{
  await config();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          updateShouldNotify: (prevUser, newUser){
            if(prevUser == null && newUser != null && (newUser.email == null || newUser.email == ""))
              return false;
            return true;
          },
          value: Authentication.user, 
          initialData: null
        )
      ],
      child: MaterialApp(
        title: 'Echos',
        debugShowCheckedModeBanner: false,
        theme: theme(context),
        home: ChangeNotifierProvider(
          create: (_) => WrapperProvider(),
          child: Wrapper()
        ),
      ),
    );
  }
}

Future<void> config() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await CountryCodes.init();
  // isAutoStartAvailable.then((value) => print(value));
  // getAutoStartPermission();
  //await db();
  startProcess();
}

void startProcess() async{
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ), 
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, 
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true
    )
  );
}

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    // WidgetsFlutterBinding.ensureInitialized();
    // DartPluginRegistrant.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  @pragma('vm:entry-point')
  void onStart(ServiceInstance service) async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    //await FirebaseFirestore.instance.collection('logs').doc().set({"opened": true, "date": FieldValue.serverTimestamp()});
    
    if(Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    if(Platform.isIOS) SharedPreferencesIOS.registerWith();

    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();

    /// Get device count
    var deviceCount = sharedPreferences.getInt("paired_device_count");
    if(deviceCount != null){
      for(int i = 0 ; i < deviceCount; i++){
        await Future.delayed(Duration(milliseconds: 5000));
        /// Connect to each paired device
        var macAddress = sharedPreferences.getString('paired_device_${i}');
        // print(macAddress);
        if(macAddress != null) {
          if(await Kbeacon.connect(macAddress) == "connected"){ 
            /// Device is connected
            await Future.delayed(Duration(milliseconds: 5000));
            await Kbeacon.enableButtonTrigger(macAddress);
            Kbeacon.buttonClickEvents.listen((event) {
              print(event);
              FirebaseFirestore.instance.collection('users').doc(Authentication.auth.currentUser!.uid).collection('logs').doc(Timestamp.now().toString())
              .set({
                "date_created": FieldValue.serverTimestamp(),
              });
              /// Get button settings
              var configured = sharedPreferences.getBool("configured");
              print(configured);
              if(configured != null && configured == true){
                var onPress = sharedPreferences.getBool("on_press");
                if(onPress != null && onPress == true){
                  var email = sharedPreferences.getString("email");
                  var emailMessage = sharedPreferences.getString("email_message");
                  var callPhoneNumberPrefix = sharedPreferences.getString("call_phone_number_prefix");
                  var callPhoneNumber = sharedPreferences.getString("call_phone_number");
                  var smsPhoneNumberPrefix = sharedPreferences.getString("sms_phone_number_prefix");
                  var smsPhoneNumber = sharedPreferences.getString("sms_phone_number");
                  var smsMessage = sharedPreferences.getString("sms_message");
                  FirebaseFirestore.instance.collection('users')
                  .doc(Authentication.auth.currentUser!.uid)
                  .collection('logs').doc(Timestamp.now().toString())
                  .set({
                    "date_created": FieldValue.serverTimestamp(),
                    "device_id": macAddress,
                    "email": email,
                    "email_message": emailMessage
                  });
                }
              }
            });
          }
        }
      }
    }
    

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    } 

    service.on('stopService').listen((event) async{
      FirebaseFirestore.instance.collection('users').doc(Authentication.auth.currentUser!.uid).collection('logs').doc('stopped').set({
        "date_stopped": FieldValue.serverTimestamp()
      });
      service.stopSelf();
    });

    // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          /// OPTIONAL for use custom notification
          /// the notification id must be equals with AndroidConfiguration when you call configure() method.
          // flutterLocalNotificationsPlugin.show(
          //   888,
          //   'COOL SERVICE',
          //   'Awesome ${DateTime.now()}',
          //   const NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       'my_foreground',
          //       'MY FOREGROUND SERVICE',
          //       icon: 'ic_bg_service_small',
          //       ongoing: true,
          //     ),
          //   ),
          // );

          // if you don't using custom notification, uncomment this
          service.setForegroundNotificationInfo(
            title: "Echos",
            content: "Echos button is available and ready-to-use.",
          );
        }
      }

      /// you can see this log in logcat
      //print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    });  
  }
