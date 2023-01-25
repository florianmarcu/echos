import 'dart:math';

import 'devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'components/widgets.dart';

class DevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DevicesPageProvider>();
    return Scaffold(
      body: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, ss) {
          if(!ss.hasData)
            return CircularProgressIndicator();
          else {
            
            return Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text("${ss.data}"),
                  /// Connected devices
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(d.name),
                              subtitle: Text(d.id.toString()),
                              trailing: StreamBuilder<BluetoothDeviceState>(
                                stream: d.state,
                                initialData: BluetoothDeviceState.disconnected,
                                builder: (c, snapshot) {
                                  if (snapshot.data ==
                                      BluetoothDeviceState.connected) {
                                    return TextButton(
                                      child: Text('OPEN'),
                                      onPressed: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeviceScreen(device: d))),
                                    );
                                  }
                                  return Text(snapshot.data.toString());
                                },
                              ),
                            ))
                        .toList(),
                    ),
                  ),
                  /// Available devices
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                        .map<Widget>(
                          (r) => ScanResultTile(
                            result: r,
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              r.device.connect();
                              return DeviceScreen(device: r.device);
                            })),
                          ),
                        )
                        .toList(),
                    ),
                  ),
                  // ListView(
                  //   shrinkWrap: true,
                  //   children: provider.devices.map((device) => Container(
                  //     child: Text(
                  //       device.toString()
                  //     ),
                  //   )).toList(),
                  // )
                ],
              ),
            );
          }
        }
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [

      // math.nextInt(255),
      // math.nextInt(255),
      // math.nextInt(255),
      // math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (service) {
            print(service.uuid);
            // print("\n");
            print(service.characteristics.length);
            // print("\n");
            service.characteristics.forEach((characteristic) async{ 
              // print("characteristic service uuuid: " + characteristic.serviceUuid.toString());
              await characteristic.setNotifyValue(true);
              print("read: " + characteristic.properties.read.toString());
              print("notify: " + characteristic.properties.notify.toString());
              print("write: " + characteristic.properties.write.toString());
              characteristic.value.listen((event) { print("VALUE: " + event.toString());});
            });
            // print("device id " + s.characteristics[0]);
            return ServiceTile(
            service: service,
            characteristicTiles: service.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read().then((value) => print("PUSH $value")),
                    onWritePressed: () async {
                      // await c.write(_getRandomBytes(), withoutResponse: true);
                      // await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            // onWritePressed: () => d.write(_getRandomBytes()),
                            onWritePressed: (){},
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          );
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /// Device's state and name
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}\n '),
                isThreeLine: true,
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            /// Device's maximum transimission unit
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    device.requestMtu(246);
                  },
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}