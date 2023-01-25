import 'package:authentication/authentication.dart';
import 'package:echos/common_widgets/loading.dart';
import 'package:echos/screens/authentication/authentication_page.dart';
import 'package:echos/screens/authentication/authentication_provider.dart';
import 'package:echos/screens/devices/devices_page.dart';
import 'package:echos/screens/devices/devices_provider.dart';
import 'package:echos/screens/onboarding/onboarding_page.dart';
import 'package:echos/screens/onboarding/onboarding_provider.dart';
import 'package:echos/screens/register/register_phone/register_phone_page.dart';
import 'package:echos/screens/register/register_provider.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_page.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'wrapper_provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<WrapperProvider>();
    var user = Provider.of<User?>(context);
    if(provider.isLoading){ /// loading
      return Container(
        color: Theme.of(context).canvasColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          // alignment: Alignment.bottomCenter,
          // height: 5,
          // width: MediaQuery.of(context).size.width,
          child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
        ), 
      );
    }
    /// The user is either:
    /// - Signed out
    /// - Partially registered using his phone number
    else if(user == null || user.email == null || user.email == ""){
      /// Onboarding Screen
      return new FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              if (!snapshot.hasError) {
                return snapshot.data!.getBool("welcome") != null
                    ? (
                      ChangeNotifierProvider(
                      create: (context) => DevicesPageProvider(),
                      child: DevicesPage()
                    ))
                    // ? (
                    //   ChangeNotifierProvider(
                    //   create: (context) => RegisterPageProvider(),
                    //   child: RegisterPhonePage()
                    // ))
                    : MultiProvider(
                        providers: [
                          ChangeNotifierProvider(create: (context) => OnboardingPageProvider(),),
                          ChangeNotifierProvider.value(value: provider)
                        ],
                        child: OnboardingPage()
                    );
              } else {
                return ChangeNotifierProvider(
                  create: (context) => AuthenticationPageProvider(),
                  child: AuthenticationPage()
                );
              }
          }
        },
      );
    }
    else {
      return ChangeNotifierProvider(
        create: (context) => WrapperHomePageProvider(context),
        child: WrapperHomePage()
      );
    }
  }
}