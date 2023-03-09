import 'package:authentication/authentication.dart';
import 'package:echos/models/models.dart';
import 'package:echos/screens/configure_device/configure_device_page.dart';
import 'package:echos/screens/configure_device/configure_device_provider.dart';
import 'package:echos/screens/device/device_page.dart';
import 'package:echos/screens/device/device_provider.dart';
import 'package:echos/screens/devices/devices_provider.dart';
import 'package:echos/screens/search_device/search_device_page.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'package:echos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var devicesPageProvider = context.watch<DevicesPageProvider>();
    var connectedDevices = devicesPageProvider.connectedDevices;
    var pairedDevices = devicesPageProvider.pairedDevices;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi, ${Authentication.auth.currentUser!.displayName}", style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold
              )),
              Text("${formatDateToWeekdayAndDate(DateTime.now().toLocal())}", style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              )),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 25, right: 15.0),
            child: Stack(
              children: [
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.notifications, size: 30, color: Theme.of(context).colorScheme.tertiary,),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 5,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric( vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// First column of menu buttons
            Column(
              children: [
                /// Devices button
                GestureDetector(
                  onTap: (){
                    wrapperHomePageProvider.updateSelectedScreenIndex(0);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    width: MediaQuery.of(context).size.width*0.4,
                    height: 270,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(/// Devices 'Icon' and 'Title'
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.bluetooth,),
                                Text("Devices", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ListView.separated( /// Connected devices
                              shrinkWrap: true,
                              itemCount: pairedDevices.length,
                              separatorBuilder: (_, index) => SizedBox(height: 0), 
                              itemBuilder: (context, index){
                                Device device = pairedDevices[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric( vertical: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Icon(Icons.circle, size: 10, color: device.connected ? Colors.green : Colors.red),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '"${device.name}"',
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                device.connected ? "Connected" : "Disconnected", 
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: device.connected ? Colors.green : Colors.red),),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                            create: (_) => ConfigureDevicePageProvider(device),
                                            child: ConfigureDevicePage(),
                                          ))).then((_) => wrapperHomePageProvider.updateSelectedScreenIndex(0));
                                        },
                                        child: Container(
                                          width: 20,
                                          padding: const EdgeInsets.only(),
                                          child: Icon(Icons.settings),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }, 
                            ),
                            
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider<DevicesPageProvider>.value(
                              value: wrapperHomePageProvider.screenProviders[0],
                              child: SearchDevicePage(),
                            ))).then((value) => wrapperHomePageProvider.updateSelectedScreenIndex(0));
                            
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
                                  child: Text("Connect a new device", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),)
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.add_circle_outline, color: Theme.of(context).canvasColor,)
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),
                SizedBox(height: 30,),
                /// Shop button
                GestureDetector(
                  onTap: (){
                    wrapperHomePageProvider.updateSelectedScreenIndex(3);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.4,
                    height: 110,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.shopping_cart, color: Theme.of(context).canvasColor),
                        Flexible(child: Text("Get a new\ndevice", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).canvasColor))),
                      ],
                    )
                  ),
                )
              ],
            ),
            /// Second column of menu button
            Column(
              children: [
                /// Community button
                GestureDetector(
                  onTap: (){
                    wrapperHomePageProvider.updateSelectedScreenIndex(1);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: 200,
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.people,),
                              Text("Community", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          AbsorbPointer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                height: 140,
                                child: GoogleMap(
                                  zoomControlsEnabled: false,                  
                                  mapToolbarEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(44.42519351823793, 26.163671485388658),
                                    zoom: 14
                                  ),
                                ),
                              ),
                            ),
                          )
                          // GestureDetector(
                          //   onTap: (){
                          //     ///Push 'search for devices'
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(30),
                          //       color: Theme.of(context).primaryColor
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         Expanded(
                          //           flex: 2,
                          //           child: Text("Connect a new device", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),)
                          //         ),
                          //         Expanded(
                          //           flex: 1,
                          //           child: Icon(Icons.add_circle_outline, color: Theme.of(context).canvasColor,)
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ),
                ),
                SizedBox(height: 30),
                ///Settings button
                GestureDetector(
                  onTap: (){
                    wrapperHomePageProvider.updateSelectedScreenIndex(4);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: 180,
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.settings,),
                              Text("Settings", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 15),
                                    SizedBox(width: 10,),
                                    Text("${Authentication.auth.currentUser!.displayName}", )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.notifications_active, size: 15),
                                    SizedBox(width: 10,),
                                    Text.rich(TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Alerts: ", 
                                        ),
                                        TextSpan(
                                          text: "ON",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.green)
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}