// https://o7planning.org/13151/flutter-navigation-and-routing
// https://github.com/TechieBlossom/sidebar_menu_dashboard/blob/master/lib/bloc/navigation_bloc/navigation_bloc.dart

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../views/views.dart';

final routerProvider = ChangeNotifierProvider<Router>((ref) => Router());

class Router extends ChangeNotifier {
  RouteItem get initialRoute => currentRoom;

  final home = RouteItem(
      page: Page.Home,
      title: "HOME",
      path: '/home',
      widget: (BuildContext context) => const Home(),
      isSelectedInMenu: false,
      isVisibleInMenu: false);

  final currentRoom = RouteItem(
      page: Page.CurrentRoom,
      title: "",
      path: '/currentRoom',
      widget: (BuildContext context) => const Home(),
      isSelectedInMenu: false,
      isVisibleInMenu: true);

  final rooms = RouteItem(
      page: Page.Rooms,
      title: "Rooms",
      path: '/rooms',
      widget: (BuildContext context) => const Rooms(),
      isSelectedInMenu: false,
      isVisibleInMenu: true);

  final settings = RouteItem(
      page: Page.Settings,
      title: "Settings",
      path: '/settings',
      widget: (BuildContext context) => const Settings(),
      isSelectedInMenu: false,
      isVisibleInMenu: true);

  final log = RouteItem(
      page: Page.Log,
      title: "Log",
      path: '/log',
      widget: (BuildContext context) => const Log(),
      isSelectedInMenu: false,
      isVisibleInMenu: true);

  late Map<Page, RouteItem> _routes;
  List<RouteItem> get visibleMenuItems =>
      _routes.values.toList().where((x) => x.isVisibleInMenu == true).toList();

  Router() {
    _routes = {
      Page.Home: home,
      Page.CurrentRoom: currentRoom,
      Page.Rooms: rooms,
      Page.Settings: settings,
      Page.Log: log,
    };
  }
}

enum Page { Home, CurrentRoom, Rooms, Settings, Log }

class RouteItem {
  Page page;
  String title;
  String path;
  WidgetBuilder widget;
  Map<String, String>? parameters;
  bool isVisibleInMenu = true;
  bool isSelectedInMenu = false;

  RouteItem({
    required this.page,
    required this.title,
    required this.path,
    required this.widget,
    this.parameters,
    required this.isVisibleInMenu,
    required this.isSelectedInMenu,
  });
}
