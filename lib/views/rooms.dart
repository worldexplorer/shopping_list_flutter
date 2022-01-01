import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Rooms extends HookWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rooms"),
      ),
      // body: Container(
      //   child: ,
      // ),
    );
  }
}
