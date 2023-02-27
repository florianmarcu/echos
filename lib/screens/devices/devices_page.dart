import 'package:echos/screens/configure_device/configure_device_page.dart';
import 'package:echos/screens/configure_device/configure_device_provider.dart';
import 'package:echos/screens/search_device/search_device_page.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'devices_provider.dart';
import 'package:flutter/material.dart';

class DevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var provider = context.watch<DevicesPageProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text("Devices", style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
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
          children: buildChildren(context, provider, wrapperHomePageProvider)
        ),
      ),
    );
  }

  /// Builds the 'Wrap' widget's children
  /// Tiles containing the connected devices
  buildChildren(BuildContext context, DevicesPageProvider provider, WrapperHomePageProvider wrapperHomePageProvider){
    List<Widget> devices = [];
    if(provider.connectedDevices != [])
      devices = provider.connectedDevices.map((device) => GestureDetector(
        onTap: (){},
        child: Container(
          padding: const EdgeInsets.only(top: 20.0),
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
          height: 210,
          width: MediaQuery.of(context).size.width*0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.bluetooth_connected_rounded,),
                  Text(device.name, style: Theme.of(context).textTheme.headline6,),
                  Text("Connected", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.green),)
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      //color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red,),
                        Flexible(child: Text("Requires configuration before usage", maxLines: 2, style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.red, fontSize: 12),))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider<ConfigureDevicePageProvider>(
                        create: (_) => ConfigureDevicePageProvider(device),
                        child: ConfigureDevicePage(),
                      )));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Configure", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),)
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(Icons.add_circle_outline, color: Theme.of(context).canvasColor,)
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
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
          height: 210,
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
