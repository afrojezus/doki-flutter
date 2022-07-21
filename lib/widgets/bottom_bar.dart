import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../screens/viewer_vm.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  Widget get customCreateIcon => SizedBox(
      width: 32.0,
      height: 32.0,
      child: Stack(children: [
        Center(
            child: Container(
          height: double.infinity,
          width: 38.0,
          decoration: BoxDecoration(
              color: GetIt.instance<ViewerViewModel>().actualScreen == 0
                  ? Colors.white
                  : Colors.black,
              borderRadius: BorderRadius.circular(99.0)),
          child: Icon(
            Icons.add,
            color: GetIt.instance<ViewerViewModel>().actualScreen == 0
                ? Colors.black
                : Colors.white,
            size: 20.0,
          ),
        )),
      ]));

  @override
  Widget build(BuildContext context) {
    /*return Container(
        decoration: BoxDecoration(
          gradient: GetIt.instance<ViewerViewModel>().actualScreen == 0
              ? const LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 1],
                  tileMode: TileMode.clamp,
                )
              : null,
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            GetIt.instance<ViewerViewModel>().setActualScreen(index);
          },
          selectedIndex: GetIt.instance<ViewerViewModel>().actualScreen,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            const NavigationDestination(
                icon: Icon(Icons.home), label: 'Viewer'),
            const NavigationDestination(
                icon: Icon(Icons.search), label: 'Browser'),
            NavigationDestination(icon: customCreateIcon, label: 'Upload'),
            const NavigationDestination(
                icon: Icon(Icons.update), label: 'Updates'),
            const NavigationDestination(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
        ));
        */

    return Container(
        decoration: BoxDecoration(
          gradient: GetIt.instance<ViewerViewModel>().actualScreen == 0
              ? const LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 1],
                  tileMode: TileMode.clamp,
                )
              : null,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: GetIt.instance<ViewerViewModel>().actualScreen == 0
              ? Colors.transparent
              : Colors.white,
          onTap: (int index) {
            GetIt.instance<ViewerViewModel>().setActualScreen(index);
          },
          unselectedItemColor:
              GetIt.instance<ViewerViewModel>().actualScreen == 0
                  ? const Color.fromARGB(128, 255, 255, 255)
                  : const Color.fromARGB(128, 0, 0, 0),
          selectedItemColor: GetIt.instance<ViewerViewModel>().actualScreen == 0
              ? Colors.white
              : Colors.black,
          currentIndex: GetIt.instance<ViewerViewModel>().actualScreen,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Viewer'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search), label: 'Browser'),
            BottomNavigationBarItem(icon: customCreateIcon, label: 'Upload'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.update), label: 'Updates'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
        ));
  }
}
