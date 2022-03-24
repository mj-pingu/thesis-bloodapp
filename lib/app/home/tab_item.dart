
import 'package:flutter/material.dart';

enum TabItem { requests, tracking, maps, account }

class TabItemData {
  const TabItemData({ @required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.requests: TabItemData(title: 'Requests', icon: Icons.assignment_return),
    TabItem.tracking: TabItemData(title: 'News', icon: Icons.campaign),
    TabItem.maps: TabItemData(title: 'Map', icon: Icons.location_on),
    TabItem.account: TabItemData(title: 'Profile', icon: Icons.person),

  };

}