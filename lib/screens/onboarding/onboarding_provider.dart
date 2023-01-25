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
      "image": "alert",
      "title": "Bun venit",
      "content": "Pas 1."
    },
    {
      "image": "alert",
      "title": "Pas 2",
      "content": "Pas 2"
    },
    {
      "image": "alert",
      "title": "Pas 3",
      "content": "Pas 3"
    },
    {
      "image": "alert",
      "title": "Pas 4",
      "content": "Pas 4",
    }
  ];
}
