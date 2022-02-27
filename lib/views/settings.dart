import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../utils/theme.dart';

class Settings extends HookWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatBackground,
      appBar: AppBar(
        title: const Text("Settings"),
      ),
    );
  }
}
