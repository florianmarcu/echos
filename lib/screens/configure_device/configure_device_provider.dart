import 'package:country_list/country_list.dart';
import 'package:echos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:provider/provider.dart';

class ConfigureDevicePageProvider with ChangeNotifier{
  Device device;
  Map<String, dynamic> currentButtonSettings = {};
  Map<String, dynamic> newButtonSettings = {};
  bool isLoading = false;
  Country? selectedSmsPhoneNumberCountry = Countries.list.first;
  bool haveSettingsChanged = false;
  GlobalKey<FormState> formKey = GlobalKey();
  

  ConfigureDevicePageProvider(this.device){
    getData();
  }

  Future<void> getData() async{
    _loading();

    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.reload();
    /// Get paired devices count
    var deviceCount = sharedPreferences.getInt("paired_device_count");
    if(deviceCount != null){
      for(int i = 0; i < deviceCount; i++){
        var macAddress = sharedPreferences.getString('paired_device_${i}');
        // print(macAddress);
        if(macAddress != null && macAddress == device.macAddress) {
          var configured = sharedPreferences.getBool("paired_device_${i}_configured");
          if(configured != null && configured == true){
            currentButtonSettings = {
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
            currentButtonSettings = {
              "on_press" : false,
              "email": "",
              "email_message": "I might be in danger",
              "call_phone_number_prefix": "${Countries.list.first.dialCode}",
              "call_phone_number": "",
              "sms_phone_number_prefix": "${Countries.list.first.dialCode}",
              "sms_phone_number": "",
              "sms_message": "I might be in danger"
            };
            //print(currentButtonSettings);
          }
        }
      }
    }
        
    // currentButtonSettings = {
    //   "on_press" : true,
    //   "email": "florian.marcu23@gmail.com",
    //   "email_message": "I might be in danger",
    //   "call_phone_number_prefix": "${Countries.list.first.dialCode}",
    //   "call_phone_number": "742010086",
    //   "sms_phone_number_prefix": "${Countries.list.first.dialCode}",
    //   "sms_phone_number": "742010086",
    //   "sms_message": "I might be in danger"
    // };

    newButtonSettings = Map.from(currentButtonSettings);
    print(newButtonSettings);

    notifyListeners();
    _loading();
  }
  
  Future<void> saveChanges() async{
    _loading();
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    /// Get paired devices count
    var deviceCount = sharedPreferences.getInt("paired_device_count");
    if(deviceCount != null){
      for(int i = 0; i < deviceCount; i++){
        var macAddress = sharedPreferences.getString('paired_device_${i}');
        if(macAddress != null && macAddress == device.macAddress) {
          for(var key in newButtonSettings.keys){
            switch(key){
              case "on_press":
                await sharedPreferences.setBool("paired_device_${i}_$key", newButtonSettings[key]);
              break;
              case "email":
                await sharedPreferences.setString("paired_device_${i}_$key", newButtonSettings[key]);
              break;
              case "email_message":
                await sharedPreferences.setString("paired_device_${i}_$key", newButtonSettings[key]);
              break;
              case "call_phone_number_prefix":
                await sharedPreferences.setString("paired_device_${i}_$key", newButtonSettings[key]);
              break;
              case "call_phone_number":
                await sharedPreferences.setString("paired_device_${i}_$key", newButtonSettings[key]);
              break;
              case "sms_phone_number_prefix":
                await sharedPreferences.setString("paired_device_${i}_$key", newButtonSettings[key]);
              break;
              case "sms_phone_number":
                await sharedPreferences.setString("paired_device_${i}_$key", newButtonSettings[key]);
              break;
              case "sms_message":
                await sharedPreferences.setString("paired_device_${i}_$key", newButtonSettings[key]);
              break;
            }
            await sharedPreferences.setBool("paired_device_${i}_configured", true);
            await sharedPreferences.reload();
          }
        }
      }
    }
    _loading();
    notifyListeners();
  }

  void updateButtonSettings(String key, dynamic value){
    switch(key){
      case "on_press": 
        newButtonSettings[key] = value;
        break;
      case "email": 
        newButtonSettings[key] = value;
        break;
      case "call_phone_number_prefix": 
        newButtonSettings[key] = value;
        break;
      case "call_phone_number": 
        newButtonSettings[key] = value;
        break;
      case "sms_phone_number_prefix": 
        newButtonSettings[key] = value;
        break;
      case "sms_phone_number": 
        newButtonSettings[key] = value;
        break;
      case "sms_message": 
        newButtonSettings[key] = value;
        break;
      case "email_message": 
        newButtonSettings[key] = value;
    }

    checkIfSettingsHaveChanged();
    
    notifyListeners();
  }

  void checkIfSettingsHaveChanged(){
    for(int i = 0 ; i < newButtonSettings.keys.length; i++){
      if(newButtonSettings[newButtonSettings.keys.elementAt(i)] != currentButtonSettings[currentButtonSettings.keys.elementAt(i)]){
        haveSettingsChanged = true;
        return;
      }
    }
    haveSettingsChanged = false;

    notifyListeners();
  }

  String? validateCallPhoneNumber(String? number){
    if(number == null || number == "")
      return "You must enter a valid phone number";
    else return null;
  }

  String? validateSmsPhoneNumber(String? number){
    if(number == null || number == "")
      return "You must enter a valid phone number";
    else return null;
  }

  String? validateSmsMessage(String? message){
    if(message == null || message == "")
      return "You must enter a message that is at least 10 characters long";
    else return null;
  }

  String? validateEmailMessage(String? message){
    if(message == null || message == "")
      return "You must enter a message that is at least 10 characters long";
    else return null;
  }

  String? validateEmailAddress(String? email){
    if(email == null || email == "")
      return "You must enter a valid email address";
    else return null;
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
  
} 