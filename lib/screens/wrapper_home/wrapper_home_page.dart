import 'package:echos/common_widgets/bottom_app_bar.dart';
import 'package:echos/common_widgets/drawer.dart';
import 'package:echos/screens/wrapper_home/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class WrapperHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<WrapperHomePageProvider>();
    return Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => provider.updateSelectedScreenIndex(2),
        child: Icon(Icons.home, size: 35,),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: provider.selectedScreenIndex,
      //   items: provider.screenLabels,
      //   // onTap: (index) => provider.updateSelectedScreenIndex(index),
      //   onTap: (index) =>
      //   provider.updateSelectedScreenIndex(index)
      //   //provider.pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn),

      // ),
      body: IndexedStack(
        children: provider.screens,
        index: provider.selectedScreenIndex,
      )
    );
  }
}