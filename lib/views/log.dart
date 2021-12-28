import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

class Log extends HookWidget {
  const Log({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    final text = StaticLogger.dumpAll('\n\n');

    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      height: 280,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 13.0,
            letterSpacing: 1,
            wordSpacing: 1,
          ),
        ),
      ),
    );
  }
}
