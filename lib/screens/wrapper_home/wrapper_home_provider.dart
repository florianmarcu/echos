import 'package:authentication/authentication.dart';
import 'package:echos/screens/home/home_provider.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'package:echos/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class WrapperHomePageProvider with ChangeNotifier{
  BuildContext context;
  int selectedScreenIndex = 0;
  UserProfile? currentUser; 
  bool isLoading = false;
  List<Widget> screens = [];
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  PageController pageController = PageController();


  List<BottomNavigationBarItem> screenLabels = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: "Acasă",
      icon: Icon(Icons.home)
    ),
    BottomNavigationBarItem(
      label: "Bilete",
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Image.asset(localAsset("ticket"),width: 25, color: Color(0xFF222831),)
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Image.asset(localAsset("ticket"),width: 25, color: Color(0xFFD65A31))
      )
    ),
    BottomNavigationBarItem(
      label: "Profil",
      icon: Icon(Icons.person)
    ),
  ];

  WrapperHomePageProvider(this.context){
    getData(context);
  }

  void rebuildTicketPageProvider(){
    // if(pageController.page == 3){ /// Workaround that solves the TicketPageProvider being disposed upon popping the Payment Page
    //   var oldProvider = ticketPageProvider!;
    //   ticketPageProvider = TicketPageProvider(ticketPageProvider!.ticket);
    //   ticketPageProvider!.passengerData = oldProvider.passengerData;
    //   ticketPageProvider!.selectedAirline = oldProvider.selectedAirline;
    //   ticketPageProvider!.selectedPassengerNumber = oldProvider.selectedPassengerNumber;
    // } 
  }

  Future<void> getData(BuildContext context) async{
    _loading();

    currentUser = await userToUserProfile(context.read<User?>());

    HomePageProvider homePageProvider = HomePageProvider();

    
    screens = <Widget>[
      // ChangeNotifierProvider<HomePageProvider>.value(  /// First screen - contains departure, arrival and date searching criteria
      //   value: homePageProvider,
      //   builder: (context, _) {
      //     return HomePage();
      //   }
      // ), 
      // ChangeNotifierProvider<TicketsPageProvider>(
      //   create: (context) => TicketsPageProvider(),
      //   builder: (context, _) {
      //     return TicketsPage();
      //   }
      // ),
      // ChangeNotifierProvider<ProfilePageProvider>(
      //   create: (context) => ProfilePageProvider(),
      //   builder: (context, _) {
      //     return ProfilePage();
      //   }
      // ),
    ];

    _loading();

    notifyListeners();
  }

  void updateSelectedScreenIndex(int index){
    /// If the user is anonymous, do not allow to see the Profile page
    if(Authentication.auth.currentUser!.isAnonymous && index == 2)
      showCupertinoDialog(
        context: context,
        barrierDismissible: true, 
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titleTextStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),
          title: Center(
            child: Container(
              child: Text("Pentru a vizualiza profilul, trebuie să fiți logat.", textAlign: TextAlign.center,),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              child: Text(
                "Log In"
              ),
              onPressed: () {
                Navigator.pop(context);
                Authentication.signOut();
              }
            ),
          ],
      ));
    else selectedScreenIndex = index;

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}