import 'package:echos/screens/device/device_provider.dart';
import 'package:echos/screens/devices/devices_provider.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DevicePageProvider>();
    var devicesPageProvider = context.watch<DevicesPageProvider>();
    var device = provider.device;
    return Scaffold(
      appBar: AppBar(
        title: Text("${device.name}"),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async{
                        if(!provider.isLoading){
                          if(device.connected)
                            await provider.disconnect();
                          else await provider.connect();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: ShapeDecoration(
                          color: device.connected ? Theme.of(context).primaryColor : Colors.grey,
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(0, 0)
                            )
                          ],
                          shape: CircleBorder(
                            // side: BorderSide(width: 0, color: Theme.of(context).colorScheme.tertiary)
                          )
                        ),
                        child: Icon(device.connected? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded, size: 40, color: Theme.of(context).canvasColor)
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      device.connected ? "Connected" : "Disconnected", 
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: device.connected ? Colors.green : Colors.red
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text("Device information", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              /// Date used
              Text("Name:   ${device.name}"),
              SizedBox(height: 20,),
              Text("MAC Address:    ${device.macAddress}"),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Configuration", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
                  Icon(Icons.edit)
                ],
              ),
            ],
          ),
          provider.isLoading
          ? Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), backgroundColor: Colors.transparent,)
            ),
          )
          : Container(),
        ],
      ),
    );
  }
}