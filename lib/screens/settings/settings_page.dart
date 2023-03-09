import 'package:authentication/authentication.dart';
import 'package:echos/screens/settings/components/notifications_settings_page.dart';
import 'package:echos/screens/settings/components/profile_page.dart';
import 'package:echos/screens/settings/components/terms_and_conditions_page.dart';
import 'package:echos/screens/settings/settings_provider.dart';
import 'package:flutter/material.dart';

import 'components/privacy_policy_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SettingsPageProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text("Settings", style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications, size: 30, color: Theme.of(context).colorScheme.tertiary,),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Stack(
              children: [
                ClipOval(
                  child: Authentication.auth.currentUser!.photoURL != null
                  ? Image.network(
                    Authentication.auth.currentUser!.photoURL!, 
                    width: 100, 
                    height: 100, 
                    fit: BoxFit.cover
                  )
                  : CircleAvatar(
                    backgroundColor: Theme.of(context).highlightColor,
                    radius: 50,
                    child: Icon(Icons.person, size: 20, color: Theme.of(context).colorScheme.tertiary,)
                  ), 
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () async{
                      await provider.updateProfileImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 20,
                      child: Icon(Icons.edit, color: Theme.of(context).highlightColor,)
                    ),
                  )
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          ListTile( /// Profile page button
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: provider,
                  child: ProfilePage()
                )
              ));
            },
            leading: Icon(Icons.person, size: 30, color: Theme.of(context).colorScheme.tertiary),
            title: Text("Profile", style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
            trailing: Icon(Icons.arrow_forward_ios, size: 25,),
          ),
          ListTile( /// Notifications settings page button
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: provider,
                  child: NotificationsSettingsPage()
                )
              ));
            },
            leading: Icon(Icons.edit_notifications, size: 30, color: Theme.of(context).colorScheme.tertiary),
            title: Text("Notifications", style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
            trailing: Icon(Icons.arrow_forward_ios, size: 25,),
          ),
          ListTile( /// Privacy policy button
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: provider,
                  child: PrivacyPolicyPage()
                )
              ));
            },
            leading: Icon(Icons.privacy_tip, size: 30, color: Theme.of(context).colorScheme.tertiary),
            title: Text("Privacy policy", style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
            trailing: Icon(Icons.arrow_forward_ios, size: 25,),
          ),
          ListTile( /// Terms and conditions button
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: provider,
                  child: TermsAndConditionsPage()
                )
              ));
            },
            leading: Icon(Icons.note_alt, size: 30, color: Theme.of(context).colorScheme.tertiary),
            title: Text("Terms and conditions", style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
            trailing: Icon(Icons.arrow_forward_ios, size: 25,),
          )
        ],
      ),
    );
  }
}