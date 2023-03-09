import 'package:echos/screens/community/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CommunityPageProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text("Community", style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: (){
              },
              icon: Icon(Icons.notifications, size: 30, color: Theme.of(context).colorScheme.tertiary,),
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          /// The Google Map
          Container(
            height: 300,
            child: Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,                  
                  mapToolbarEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(44.42519351823793, 26.163671485388658),
                    zoom: 14
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width/2 - 100,
                  bottom: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0.1,
                          blurRadius: 10,
                          offset: const Offset(0, 0)
                        )
                      ],
                    ),
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Container(
                        height: 50,
                        width: 120,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("See map\nof users", style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).canvasColor
                              ),)
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(Icons.place)
                            ),
                          ],
                        ),
                      ),
                      onPressed: (){},
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 30,),
          Text(
            "Recent alerts",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.recentAlerts.length,
            separatorBuilder: (context, index) => SizedBox(height: 10), 
            itemBuilder: (context, index){
              var alert = provider.recentAlerts[index];
              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              );
            }, 
          )
        ],
      ),
    );
  }
}