// https://github.com/TechieBlossom/flutter-samples/blob/master/menu_dashboard_layout.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/views/router.dart';

import '../utils/theme.dart';
import 'views.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final router = ref.watch(routerProvider);

    return Scaffold(
      backgroundColor: menuBackgroundColor,
      // body: router.home.widget(context),
      body: const Rooms(),
      drawer: const Menu(),
    );
  }
}
