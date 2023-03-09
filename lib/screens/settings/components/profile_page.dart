import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text("Profile", style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
        ),
      ),
    );
  }
}