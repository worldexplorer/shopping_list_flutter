import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'chat.dart';

class HomeWidget extends HookWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Chat();
  }
}
