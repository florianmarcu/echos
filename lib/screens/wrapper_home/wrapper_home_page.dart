import 'package:authentication/authentication.dart';
import 'package:echos/common_widgets/drawer.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class WrapperHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<WrapperHomePageProvider>();
    return Scaffold(
      drawer: AppDrawer(),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed
      // ),
      body: Center(child: Text("home")),
    );
  }
}