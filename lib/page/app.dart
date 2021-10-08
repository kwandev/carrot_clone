import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentPageIndex = 0;

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return Container();
      default:
        return Home();
    }
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child:
                SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 22)),
        activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child:
                SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 22)),
        label: label);
  }

  BottomNavigationBar _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      currentIndex: _currentPageIndex,
      items: [
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "동네생활"),
        _bottomNavigationBarItem("location", "내 근처"),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "내 당근"),
      ],
      onTap: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: _appBar(),
        body: _bodyWidget(),
        bottomNavigationBar: _bottomNavigationBarWidget());
  }
}
