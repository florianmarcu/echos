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
              Builder(
                builder: (context) {
                  if(!provider.isSearching)
                  /// Button with no animation
                    return GestureDetector(
                      onTap: (){
                        /// Start searching and animation
                        provider.startScanning();
                        startAnimation();
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: buttonSize,
                        child: Icon(Icons.search, size: 44, color: Theme.of(context).canvasColor,)
                      ),
                    );
                  /// Button with animation
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
                      onPressed: () => provider.connect(context, device.id.id),
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