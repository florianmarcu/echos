import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // UserAccountsDrawerHeader(
          //   accountName: Text("${Authentication.auth.currentUser!.displayName}"),
          //   accountEmail: Text("${Authentication.auth.currentUser!.email}"),
          //   // accountName: Text(Authentication.auth.currentUser!.displayName!), 
          //   // accountEmail: Text(Authentication.auth.currentUser!.email!)
          // ),
          Spacer(),
          TextButton(
            onPressed: () => Authentication.signOut(),
            child: Text("Log out"),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}