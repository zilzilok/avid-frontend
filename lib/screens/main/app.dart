import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/material.dart';

import 'components/tab_navigator.dart';

class AppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  String _currentPage = "Feed";
  List<String> pageKeys = [
    "Feed",
    "Search",
    // "Notifications",
    "Profile",
  ];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Feed": GlobalKey<NavigatorState>(),
    "Search": GlobalKey<NavigatorState>(),
    // "Notifications": GlobalKey<NavigatorState>(),
    "Profile": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Feed") {
            _selectTab("Feed", 0);

            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator("Feed"),
            _buildOffstageNavigator("Search"),
            // _buildOffstageNavigator("Notifications"),
            _buildOffstageNavigator("Profile"),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border(top: BorderSide(color: kPrimaryColor, width: 2)),
          ),
          child: BottomNavigationBar(
            selectedItemColor: kPrimaryAccentColor,
            unselectedItemColor: kPrimaryColor,
            onTap: (int index) {
              _selectTab(pageKeys[index], index);
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home_outlined),
                activeIcon: new Icon(Icons.home),
                label: "Новости",
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.search_outlined),
                activeIcon: new Icon(Icons.search),
                label: "Поиск",
              ),
              // BottomNavigationBarItem(
              //   icon: new Icon(Icons.notifications_active_outlined),
              //   activeIcon: new Icon(Icons.notifications_active),
              //   label: "Уведомления",
              // ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.person_outline),
                activeIcon: new Icon(Icons.person),
                label: "Профиль",
              ),
            ],
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
