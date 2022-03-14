import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../utils/theme.dart';

class SendSms extends HookWidget {
  const SendSms({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatBackground,
      appBar: AppBar(
        title: const Text("SendSms"),
      ),
    );
  }
}
