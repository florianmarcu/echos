import 'package:echos/screens/settings/settings_provider.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SettingsPageProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text("Notifications", style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Switch.adaptive( /// Switch for button's state
                  activeColor: Theme.of(context).primaryColor,
                  value: provider.newButtonSettings['alerts'], 
                  onChanged: (value) => provider.updateButtonSettings("alerts", value)
                ),
                SizedBox(width: 15),
                Container( /// Switch's text
                  width: 230,
                  child: Stack(
                    children: [
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text("Alert me about people around me", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Tooltip(
                          showDuration: Duration(milliseconds: 10000),
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(Icons.info, size: 20, color: Theme.of(context).colorScheme.tertiary),
                          message: "If turned ON, you will receive a notification every time a user sends an Echos emergency signal",
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}