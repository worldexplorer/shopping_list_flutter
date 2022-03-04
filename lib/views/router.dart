// https://o7planning.org/13151/flutter-navigation-and-routing
// https://github.com/TechieBlossom/sidebar_menu_dashboard/blob/master/lib/bloc/navigation_bloc/navigation_bloc.dart

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming.dart';
import '../utils/ui_state.dart';
import 'login/login.dart';
import 'views.dart';

final routerProvider = ChangeNotifierProvider<Router>((ref) => Router(ref));

class Router extends ChangeNotifier {
  RouteMenuItem get initialRoute => currentRoom;

  late RouteMenuItem home;
  late RouteMenuItem rooms;
  late RouteMenuItem currentRoom;
  late RouteMenuItem settings;
  late RouteMenuItem log;
  late RouteMenuItem login;
  late ActionMenuItem reconnect;
  late ActionMenuItem getMessages;
  late ActionMenuItem refresh;

  late Map<Page, MenuItem> _menuItems;

  List<MenuItem> get visibleMenuItems => _menuItems.values
      .toList()
      .where((x) => x.isVisibleInMenu == true)
      .toList();

  Map<String, Widget Function(BuildContext)> get widgetByNamedRoute {
    Map<String, Widget Function(BuildContext)> ret = {};
    // for (var x in visibleMenuItems) {
    for (var x in _menuItems.values.toList()) {
      if (x is RouteMenuItem) {
        RouteMenuItem routeMenuItem = x;
        ret.addAll(
            {routeMenuItem.path: (context) => routeMenuItem.widget(context)});
      }
    }
    return ret;
  }

  Router(ChangeNotifierProviderRef ref) {
    home = RouteMenuItem(
        page: Page.Home,
        title: 'HOME',
        path: '/home',
        widget: (BuildContext context) => const Home(),
        isSelectedInMenu: false,
        isVisibleInMenu: false);

    rooms = RouteMenuItem(
      page: Page.Rooms,
      title: 'Rooms',
      path: '/rooms',
      widget: (BuildContext context) => const Rooms(),
      isSelectedInMenu: false,
      isVisibleInMenu: true,
    );

    currentRoom = RouteMenuItem(
        page: Page.CurrentRoom,
        title: 'Current Room',
        path: '/currentRoom',
        widget: (BuildContext context) => const ChatWrapperSlivers(),
        isSelectedInMenu: false,
        isVisibleInMenu: true);

    settings = RouteMenuItem(
        page: Page.Settings,
        title: 'Settings',
        path: '/settings',
        widget: (BuildContext context) => const Settings(),
        isSelectedInMenu: false,
        isVisibleInMenu: true);

    log = RouteMenuItem(
        page: Page.Log,
        title: 'Log',
        path: '/log',
        widget: (BuildContext context) => const Log(showAppBar: true),
        isSelectedInMenu: false,
        isVisibleInMenu: true);

    login = RouteMenuItem(
        page: Page.Login,
        title: 'Login',
        path: '/login',
        widget: (BuildContext context) => const Login(),
        isSelectedInMenu: false,
        isVisibleInMenu: true);

    reconnect = ActionMenuItem(
        page: Page.Reconnect,
        title: 'Reconnect',
        action: () {
          final incoming = ref.watch(incomingStateProvider);
          incoming.clearAllMessages();
          final connection = incoming.connection;
          connection.reconnect();
        },
        isSelectedInMenu: false,
        isVisibleInMenu: true);

    getMessages = ActionMenuItem(
        page: Page.GetMessages,
        title: 'Get Messages',
        action: () {
          final incoming = ref.watch(incomingStateProvider);
          // incoming.clearAllMessages();
          incoming.outgoingHandlers.sendGetMessages(incoming.currentRoomId);
        },
        isSelectedInMenu: false,
        isVisibleInMenu: true);

    refresh = ActionMenuItem(
        page: Page.Refresh,
        title: 'Refresh',
        action: () {
          final ui = ref.watch(uiStateProvider);
          ui.rebuild();
          refresh.title = 'Refresh (${ui.refreshCounter})';
        },
        isSelectedInMenu: false,
        isVisibleInMenu: true);

    _menuItems = {
      Page.Home: home,
      Page.Rooms: rooms,
      Page.CurrentRoom: currentRoom,
      Page.Settings: settings,
      Page.Log: log,
      Page.Login: login,
      Page.Reconnect: reconnect,
      Page.GetMessages: getMessages,
      Page.Refresh: refresh,
    };
  }
}

enum Page {
  Home,
  Rooms,
  CurrentRoom,
  Settings,
  Log,
  Login,
  Reconnect,
  GetMessages,
  Refresh
}

class MenuItem {
  Page page;
  String title;
  bool isVisibleInMenu = true;
  bool isSelectedInMenu = false;

  MenuItem({
    required this.page,
    required this.title,
    required this.isVisibleInMenu,
    required this.isSelectedInMenu,
  });
}

class RouteMenuItem extends MenuItem {
  String path;
  WidgetBuilder widget;
  Map<String, String>? parameters;

  RouteMenuItem({
    required page,
    required title,
    required isVisibleInMenu,
    required isSelectedInMenu,
    required this.path,
    required this.widget,
    this.parameters,
  }) : super(
          page: page,
          title: title,
          isVisibleInMenu: isVisibleInMenu,
          isSelectedInMenu: isSelectedInMenu,
        );
}

class ActionMenuItem extends MenuItem {
  Function() action;

  ActionMenuItem({
    required page,
    required title,
    required isVisibleInMenu,
    required isSelectedInMenu,
    required this.action,
  }) : super(
          page: page,
          title: title,
          isVisibleInMenu: isVisibleInMenu,
          isSelectedInMenu: isSelectedInMenu,
        );
}
