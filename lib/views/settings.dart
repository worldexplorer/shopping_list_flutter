import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Settings extends HookWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Container(
      child: Text("Settings"),
    );
  }
}
