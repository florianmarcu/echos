import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConfigureDevicePage extends StatelessWidget {
  const ConfigureDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.tertiary,)
        ),
        title: Text(
          "Configure"
        ),
      ),
    );
  }
}