import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/donate/request_form.dart';
import 'package:time_tracker_flutter_course/app/home/news/news_page.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

import 'maps/map_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.requests;


  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.requests: GlobalKey<NavigatorState>(),
    TabItem.tracking: GlobalKey<NavigatorState>(),
    TabItem.maps: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.requests: (_) => RequestForm(),
      TabItem.tracking: (_) => NewsPage(),
      TabItem.maps: (_) => MapPage(),
      TabItem.account: (_) => AccountPage(),

    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) =>
      route.isFirst); //to pop to the first route
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
