import 'package:authentication/authentication.dart';
import 'package:echos/screens/community/community_page.dart';
import 'package:echos/screens/community/community_provider.dart';
import 'package:echos/screens/devices/devices_page.dart';
import 'package:echos/screens/devices/devices_provider.dart';
import 'package:echos/screens/home/home_page.dart';
import 'package:echos/screens/home/home_provider.dart';
import 'package:echos/screens/settings/settings_page.dart';
import 'package:echos/screens/settings/settings_provider.dart';
import 'package:echos/screens/shop/shop_page.dart';
import 'package:echos/screens/shop/shop_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
export 'package:provider/provider.dart';

class WrapperHomePageProvider with ChangeNotifier{
  BuildContext context;
  int selectedScreenIndex = 2;
  UserProfile? currentUser; 
  bool isLoading = false;
  List<Widget> screens = [];
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  PageController pageController = PageController();

  List screenProviders = [
    DevicesPageProvider(),
    CommunityPageProvider(),
    HomePageProvider(),
    ShopPageProvider(),
    SettingsPageProvider()
  ];

  List<Tuple2<IconData?, String>?> screenIcons = <Tuple2<IconData?, String>?>[
    Tuple2(Icons.bluetooth_audio_outlined, "My Devices"),
    Tuple2(Icons.people, "Community"),
    null,
    Tuple2(Icons.shopping_cart, "Shop"),
    Tuple2(Icons.settings, "Settings")
  ];

  IconData centralIcon = Icons.home;
 
  // List<BottomNavigationBarItem> screenLabels = <BottomNavigationBarItem>[
  //   BottomNavigationBarItem(
  //     label: "Devices",
  //     icon: Icon(Icons.home)
  //   ),
  //   BottomNavigationBarItem(
  //     label: "Community",
  //     icon: Icon(Icons.people)
  //   ),
  //   BottomNavigationBarItem(
  //     label: "Home",
  //     icon: Icon(Icons.person)
  //   ),
  //   BottomNavigationBarItem(
  //     label: "Shop",
  //     icon: Icon(Icons.person)
  //   ),
  //   BottomNavigationBarItem(
  //     label: "Settings",
  //     icon: Icon(Icons.person)
  //   ),
  // ];

  WrapperHomePageProvider(this.context){
    getData(context);
  }

  /// Returns the provider of the specific screen
  providerOf(int index) => screenProviders[index];

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


    // screenIcons = <IconData>[
    //   Icons.bluetooth_audio_outlined,
    //   Icons.people,
    //   Icons.home,
    //   Icons.shop,
    //   Icons.settings
    // ];
    
    screens = <Widget>[
      ChangeNotifierProvider<DevicesPageProvider>.value(  /// First screen - contains departure, arrival and date searching criteria
        value: screenProviders[0],
        builder: (context, _) {
          return DevicesPage();
        }
      ), 
      ChangeNotifierProvider<CommunityPageProvider>.value(
        value: screenProviders[1],
        builder: (context, _) {
          return CommunityPage();
        }
      ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomePageProvider>.value(
            value: screenProviders[2],
          ),
          ChangeNotifierProvider<DevicesPageProvider>.value(
            value: screenProviders[0],
          ),
        ],
        builder: (context, _) {
          return HomePage();
        }
      ),
      ChangeNotifierProvider<ShopPageProvider>.value(
        value: screenProviders[3],
        builder: (context, _) {
          return ShopPage();
        }
      ),
      ChangeNotifierProvider<SettingsPageProvider>.value(
        value: screenProviders[4],
        builder: (context, _) {
          return SettingsPage();
        }
      ),
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
