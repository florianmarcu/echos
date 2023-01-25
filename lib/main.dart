import 'package:authentication/authentication.dart';
import 'package:country_codes/country_codes.dart';
import 'package:echos/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/wrapper/wrapper.dart';
import 'screens/wrapper/wrapper_provider.dart';

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
  //await db();
}