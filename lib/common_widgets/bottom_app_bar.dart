import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<WrapperHomePageProvider>();
    return BottomAppBar(
      shape: AutomaticNotchedShape(RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
      height: 90,
      color: Theme.of(context).colorScheme.tertiary,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: provider.screenIcons.map((iconData) => Expanded(
          child: iconData != null 
          ? Container(
            height: 60,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Column(
                children: [
                  Icon(
                    iconData.item1, 
                    color: provider.screenIcons.indexOf(iconData) == provider.selectedScreenIndex
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).canvasColor,
                  ),
                  SizedBox(height: 5),
                  Text(
                    iconData.item2,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 12*(1/MediaQuery.textScaleFactorOf(context)),
                      color: provider.screenIcons.indexOf(iconData) == provider.selectedScreenIndex
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).canvasColor,
                    ),
                  ),
                  provider.screenIcons.indexOf(iconData) == provider.selectedScreenIndex
                  ? Column(
                    children: [
                      SizedBox(height: 5,),
                      CircleAvatar(
                        radius: 2,
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                    ]
                  )
                  : Container()
                ],
              ),
              onPressed: () => provider.updateSelectedScreenIndex(provider.screenIcons.indexOf(iconData)),
            ),
          )
          : Container(),
        )).toList()
      ),
    );
    // return ConvexAppBar.builder(
    //   initialActiveIndex: provider.selectedScreenIndex,
    //   disableDefaultTabController: true,
    //   itemBuilder: CustomAppBarBuilder(provider.screenIcons), 
    //   backgroundColor: Theme.of(context).colorScheme.tertiary,
    //   count: provider.screenIcons.length
    // );
    // return BottomAppBar(
    //   color: Colors.transparent,
    //   elevation: 0, 
    //   child: Stack(
    //     children: [
    //       Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Container(height: 20),
    //           Container(
    //             color: Theme.of(context).colorScheme.tertiary,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: provider.screenIcons.map<Widget>((icon) => 
    //                 provider.screenIcons.length == 5 && provider.screenIcons.indexOf(icon) == 2
    //                 /// The middle button
    //                 ? Container(
    //                   margin: EdgeInsets.only(bottom: 20),
    //                   child: CircleAvatar(
    //                     radius: 30,
    //                     backgroundColor: Theme.of(context).canvasColor,
    //                     child: Icon(icon),
    //                   )
    //                 )
    //                 /// The other buttons
    //                 : IconButton(
    //                   onPressed: (){},
    //                   icon: Icon(icon),
    //                 )
    //               ).toList(),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Positioned.fill(
    //         child: Container(
    //             alignment: Alignment.center,
    //             margin: EdgeInsets.only(bottom: 20),
    //             child: CircleAvatar(
    //               radius: 30,
    //               backgroundColor: Theme.of(context).canvasColor,
    //               child: Icon(provider.centralIcon),
    //             )
    //           )
    //       )
    //     ],
    //   ),
    // );
  }
}

class CustomAppBarBuilder extends DelegateBuilder{

  List<IconData> icons;

  CustomAppBarBuilder(this.icons);

  @override
  Widget build(BuildContext context, int index, bool state) {
    
    return index == 2
    ? Container(
      child: Icon(icons[index], color: Theme.of(context).colorScheme.primary),
    )
    : Container(
      child: Icon(icons[index], color: Theme.of(context).canvasColor),
    );
  }
}