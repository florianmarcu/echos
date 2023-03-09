import 'package:echos/models/device.dart';
import 'package:echos/screens/configure_device/configure_device_page.dart';
import 'package:echos/screens/configure_device/configure_device_provider.dart';
import 'package:echos/screens/devices/devices_provider.dart';
import 'package:echos/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchDevicePage extends StatefulWidget {
  
  @override
  State<SearchDevicePage> createState() => _SearchDevicePageState();
}

class _SearchDevicePageState extends State<SearchDevicePage> with TickerProviderStateMixin{

  AnimationController? _controller;
  double buttonSize = 70;

  Widget _rippleButton(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(buttonSize),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                Theme.of(context).primaryColor,
                Color.lerp(Theme.of(context).primaryColor, Colors.black, .05)!
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller!,
                curve: CurveWave(),
              ),
            ),
            child: Icon(Icons.search, size: 44, color: Theme.of(context).canvasColor,)
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  startAnimation(){
    setState(() {
      _controller!.repeat();
    });
  }

  stopAnimation(){
    setState(() {
      _controller!.stop();
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DevicesPageProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text("Search device"),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              // Container(
              //   child: CircularProgressIndicator(),
              // ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 1000),
                child: Builder(
                  builder: (context) {
                    if(!provider.isSearching)
                    /// Button with no animation (SEARCH IS OFF)
                      return GestureDetector(
                        onTap: (){
                          /// Start searching and animation
                          provider.startScanning();
                          startAnimation();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                                BoxShadow(
                                  offset: Offset(0,1), 
                                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2), 
                                  blurRadius: 4,
                                  spreadRadius: 0.1
                                ),
                              ]
                          ),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: buttonSize,
                            child: Icon(Icons.search, size: 44, color: Theme.of(context).canvasColor,)
                          ),
                        ),
                      );
                    /// Button with animation (SEARCH IS ON)
                    else return GestureDetector(
                      onTap: (){
                        provider.stopScanning();
                        stopAnimation();
                      },
                      child: CustomPaint(
                        painter: CirclePainter(
                          _controller!,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: SizedBox(
                          width: buttonSize * 4.125,
                          height: buttonSize * 4.125,
                          child: _rippleButton(context),
                        ),
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height: 20),
              /// Shows either 
              /// 'Press to search for devices' - not searching state
              /// 'Scanning' - searching state
              Builder(
                builder: (context) {
                  if(provider.isSearching)
                    return Container(
                      child: Text("Searching for devices..."),
                    );
                  else return Text("Press button to start searching for devices");
                }
              ),
              provider.isSearching
              ? Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: provider.discoveredDevices.map((device) => ListTile(
                    title: Text(device.name, style: Theme.of(context).textTheme.headline6,),
                    subtitle: Text(device.id.id),
                    trailing: TextButton(
                      onPressed: () async => provider.connect(context, device.id.id, device.name).then((value) => value
                      ? Navigator.push(context, 
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            transitionsBuilder: (context, animation, secAnimation, child){
                              var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                              return SlideTransition(
                                child: child,
                                position: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0)
                                ).animate(_animation),
                              );
                            },
                            pageBuilder: (context, animation, secAnimation) => ChangeNotifierProvider(
                              create: (context) => ConfigureDevicePageProvider(
                                bluetoothDeviceToDevice(
                                  device.id.id, 
                                  device, 
                                  false, 
                                  true, 
                                  device.name, 
                                  Device.emptyConfigurations
                                )
                              ),
                              child: ConfigureDevicePage(),
                            )
                          )
                      )
                      : null),
                      child: Text("Connect") 
                    ),
                  )).toList(),
                ),
              )
              : Container(),
            ],
          );
        }
      )
    );
  }
}



// body: Builder(
//         builder: (context) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 100,),
//               // Container(
//               //   child: CircularProgressIndicator(),
//               // ),
//               AnimatedSwitcher(
//                 duration: Duration(milliseconds: 1000),
//                 child: Builder(
//                   builder: (context) {
//                     if(!provider.isSearching)
//                     /// Button with no animation (SEARCH IS OFF)
//                       return GestureDetector(
//                         onTap: (){
//                           /// Start searching and animation
//                           provider.startScanning();
//                           startAnimation();
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                                 BoxShadow(
//                                   offset: Offset(0,1), 
//                                   color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2), 
//                                   blurRadius: 4,
//                                   spreadRadius: 0.1
//                                 ),
//                               ]
//                           ),
//                           child: CircleAvatar(
//                             backgroundColor: Theme.of(context).primaryColor,
//                             radius: buttonSize,
//                             child: Icon(Icons.search, size: 44, color: Theme.of(context).canvasColor,)
//                           ),
//                         ),
//                       );
//                     /// Button with animation (SEARCH IS ON)
//                     else return GestureDetector(
//                       onTap: (){
//                         provider.stopScanning();
//                         stopAnimation();
//                       },
//                       child: CustomPaint(
//                         painter: CirclePainter(
//                           _controller!,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         child: SizedBox(
//                           width: buttonSize * 4.125,
//                           height: buttonSize * 4.125,
//                           child: _rippleButton(context),
//                         ),
//                       ),
//                     );
//                   }
//                 ),
//               ),
//               SizedBox(height: 20),
//               /// Shows either 
//               /// 'Press to search for devices' - not searching state
//               /// 'Scanning' - searching state
//               Builder(
//                 builder: (context) {
//                   if(provider.isSearching)
//                     return Container(
//                       child: Text("Searching for devices..."),
//                     );
//                   else return Text("Press button to start searching for devices");
//                 }
//               ),
//               provider.isSearching
//               ? Expanded(
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: provider.discoveredDevices.map((device) => ListTile(
//                     title: Text(device.name, style: Theme.of(context).textTheme.headline6,),
//                     subtitle: Text(device.id.id),
//                     trailing: TextButton(
//                       onPressed: () async => provider.connect(context, device.id.id).then((value) => value
//                       ? Navigator.push(context, 
//                           PageRouteBuilder(
//                             transitionDuration: Duration(milliseconds: 500),
//                             transitionsBuilder: (context, animation, secAnimation, child){
//                               var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
//                               return SlideTransition(
//                                 child: child,
//                                 position: Tween<Offset>(
//                                   begin: Offset(1, 0),
//                                   end: Offset(0, 0)
//                                 ).animate(_animation),
//                               );
//                             },
//                             pageBuilder: (context, animation, secAnimation) => ChangeNotifierProvider(
//                               create: (context) => ConfigureDevicePageProvider(device),
//                               child: ConfigureDevicePage(),
//                             )
//                           )
//                       )
//                       : null),
//                       child: Text("Connect") 
//                     ),
//                   )).toList(),
//                 ),
//               )
//               : Container(),
//             ],
//           );
//         }
//       )









      // body: Stack(
      //   // mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     // SizedBox(height: 100,),
      //     AnimatedPositioned(
      //       duration: Duration(milliseconds: 500),
      //       // left: provider.isAnimating
      //       // ? MediaQuery.of(context).size.width*0.5
      //       // : MediaQuery.of(context).size.width*0.5,
      //       top: provider.isSearching
      //       ? MediaQuery.of(context).size.height*0.2
      //       : MediaQuery.of(context).size.height*0.5,
      //       child: Builder(
      //         builder: (context) {
      //           if(!provider.isSearching)
      //           /// Button with no animation (SEARCH IS OFF)
      //             return GestureDetector(
      //               onTap: () async{
      //                 print("PRESS");
      //                 //await provider.updateIsAnimating();
      //                 /// Start searching and animation
      //                 provider.startScanning();
      //                 //await Future.delayed(Duration(milliseconds: 2000));
      //                 startAnimation();
      //               },
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   boxShadow: [
      //                       BoxShadow(
      //                         offset: Offset(0,1), 
      //                         color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2), 
      //                         blurRadius: 4,
      //                         spreadRadius: 0.1
      //                       ),
      //                     ]
      //                 ),
      //                 child: CircleAvatar(
      //                   backgroundColor: Theme.of(context).primaryColor,
      //                   radius: buttonSize,
      //                   child: Icon(Icons.search, size: 44, color: Theme.of(context).canvasColor,)
      //                 ),
      //               ),
      //             );
      //           /// Button with animation (SEARCH IS ON)
      //           else return GestureDetector(
      //             onTap: () async{
      //               //await provider.updateIsAnimating();
      //               provider.stopScanning();
      //               stopAnimation();
      //             },
      //             child: CustomPaint(
      //               painter: CirclePainter(
      //                 _controller!,
      //                 color: Theme.of(context).primaryColor,
      //               ),
      //               child: SizedBox(
      //                 width: buttonSize * 4.125,
      //                 height: buttonSize * 4.125,
      //                 child: _rippleButton(context),
      //               ),
      //             ),
      //           );
      //         }
      //       ),
      //     ),
      //     Positioned(
      //       top: MediaQuery.of(context).size.height*0.5,
      //       width: MediaQuery.of(context).size.width,
      //       child: Container(
      //         height: MediaQuery.of(context).size.height*0.5,
      //         child: ListView(
      //           shrinkWrap: true,
      //           children: provider.discoveredDevices.map((device) => ListTile(
      //             title: Text(device.name, style: Theme.of(context).textTheme.headline6,),
      //             subtitle: Text(device.id.id),
      //             trailing: TextButton(
      //               onPressed: () async => provider.connect(context, device.id.id).then((value) => value
      //               ? Navigator.push(context, 
      //                   PageRouteBuilder(
      //                     transitionDuration: Duration(milliseconds: 500),
      //                     transitionsBuilder: (context, animation, secAnimation, child){
      //                       var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
      //                       return SlideTransition(
      //                         child: child,
      //                         position: Tween<Offset>(
      //                           begin: Offset(1, 0),
      //                           end: Offset(0, 0)
      //                         ).animate(_animation),
      //                       );
      //                     },
      //                     pageBuilder: (context, animation, secAnimation) => ChangeNotifierProvider(
      //                       create: (context) => ConfigureDevicePageProvider(device),
      //                       child: ConfigureDevicePage(),
      //                     )
      //                   )
      //               )
      //               : null),
      //               child: Text("Connect") 
      //             ),
      //           )).toList(),
      //         ),
      //       ),
      //     )
      //     //SizedBox(height: 20),
      //     /// Shows either 
      //     /// 'Press to search for devices' - not searching state
      //     /// 'Scanning' - searching state
      //     // Builder(
      //     //   builder: (context) {
      //     //     if(provider.isSearching)
      //     //       return Container(
      //     //         child: Text("Searching for devices..."),
      //     //       );
      //     //     else return Text("Press button to start searching for devices");
      //     //   }
      //     // ),
