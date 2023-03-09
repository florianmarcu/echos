import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
export 'package:provider/provider.dart';

class SettingsPageProvider with ChangeNotifier{
  bool isLoading = false;
  Map<String, dynamic> currentButtonSettings = {};
  Map<String, dynamic> newButtonSettings = {};
  bool haveSettingsChanged = false;

  SettingsPageProvider(){
    getData();
  }

  Future<void> getData() async{
    _loading();
    currentButtonSettings = {
      "alerts" : true
    };

    newButtonSettings = Map.from(currentButtonSettings);

    notifyListeners();
    _loading();
  }

  Future<void> updateProfileImage() async{
    _loading();

    XFile? newImage = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);
    if(newImage != null)
      await Authentication.updateProfileImage(newImage.path);
    _loading();

    notifyListeners();
  }

  void updateButtonSettings(String key, dynamic value){
    switch(key){
      case "alerts": 
        newButtonSettings[key] = value;
        break;
    }
    
    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}