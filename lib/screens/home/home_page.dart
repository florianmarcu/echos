import 'package:authentication/authentication.dart';
import 'package:echos/screens/devices/devices_provider.dart';
import 'package:echos/screens/search_device/search_device_page.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'package:echos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
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
                  icon: Icon(Icons.notifications, size: 30),
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
                    height: 250,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.bluetooth,),
                                Text("Devices", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Icon(Icons.circle, size: 10, color: Colors.green),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      '"KBeacon" is connected',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: GestureDetector(
                                      onTap: (){
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                        //   create: DevicePageProvider(device),
                                        // )));
                                      },
                                      child: InkWell(
                                        splashColor: Theme.of(context).canvasColor,
                                        child: Icon(Icons.settings)
                                      )
                                    ),
                                  ),
                                ],
                              ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.people,),
                              Text("Community", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: 140,
                            child: GoogleMap(
                              mapToolbarEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(24,24),
                                zoom: 14
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
                  onTap: (){},
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