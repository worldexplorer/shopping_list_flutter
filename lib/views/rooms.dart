import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Rooms extends HookWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Container(
      child: Text("Rooms"),
    );
  }
}