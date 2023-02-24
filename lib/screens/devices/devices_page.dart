import 'dart:math';

import 'package:echos/screens/search_device/search_device_page.dart';

import 'devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'components/widgets.dart';

class DevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DevicesPageProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text("Devices"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications_none, size: 30, color: Theme.of(context).colorScheme.tertiary,),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          runSpacing: 30,
          runAlignment: WrapAlignment.start,
          alignment: WrapAlignment.spaceEvenly,
          children: buildChildren(context, provider)
        ),
      ),
    );
  }

  /// Builds the 'Wrap' widget's children
  /// Tiles containing the connected devices
  buildChildren(BuildContext context, DevicesPageProvider provider){
    List<Widget> devices = [];
    if(provider.connectedDevices != [])
      devices = provider.connectedDevices.map((device) => GestureDetector(
        onTap: (){},
        child: Container(
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).highlightColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(0, 0)
              )
            ],
          ),
          height: 200,
          width: MediaQuery.of(context).size.width*0.4,
          child: Text(device.id.id, style: Theme.of(context).textTheme.headline6,),
        ),
      )).toList();
    devices.add(
      GestureDetector(
        child: Container(
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(0, 0)
              )
            ],
          ),
          height: 200,
          width: MediaQuery.of(context).size.width*0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Connect \na device", textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).canvasColor),),
              SizedBox(height: 10,),
              Icon(Icons.add_circle_outline, size: 40, color: Theme.of(context).canvasColor)
            ],
          )
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
            value: provider,
            child: SearchDevicePage(),
          ))).then((value) => provider.stopScanning());
        }
      ),
    );
    return devices;
  }
}
