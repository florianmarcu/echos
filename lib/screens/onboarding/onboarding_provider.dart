import 'package:flutter/cupertino.dart';
export 'package:provider/provider.dart';

class OnboardingPageProvider with ChangeNotifier {
  PageController pageController = PageController();
  int pageIndex = 0;

  void updateSelectedPageIndex(int index){
    pageIndex = index;

    notifyListeners();
  }

  var pages = [
    {
      "image": "welcome",
      "title": "Welcome to Echos!",
      "content": "Let's start"
    },
    {
      "image": "register",
      "title": "Register",
      "content": "First of all, sign up on our platform"
    },
    {
      "image": "connect-device",
      "title": "Connect a device",
      "content": "Connect an Echos device to your phone"
    },
    {
      "image": "configure-device",
      "title": "Configure your Echos device",
      "content": "Fill in the information required in order to use your Echos device",
    },
    {
      "image": "alert",
      "title": "Done! From now, use Echos in any emergency situation",
      "content": "After you have configured your device, you can use your Echos device to send emergency signals to your friends or family whenever you feel in danger",
    }
  ];
}
