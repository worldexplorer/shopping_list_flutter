import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HalfTiger extends HookConsumerWidget {
  final String message;
  final Function? onTap;
  const HalfTiger({Key? key, required this.message, this.onTap})
      : super(key: key);

  @override
  build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("images/half-tiger.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(message,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold))),
            )));
  }
}
