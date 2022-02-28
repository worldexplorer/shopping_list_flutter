import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HalfTiger extends HookConsumerWidget {
  final String message;
  const HalfTiger({Key? key, required this.message}) : super(key: key);

  @override
  build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("images/half-tiger.jpg"),
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4), BlendMode.dstATop),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(message,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}
