import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_flutter/network/net_state.dart';

import 'chat.dart';

class HomeWidget extends HookWidget {
  HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabController? tabController;
    return (tabController != null)
        ? TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Consumer<NetState>(builder: (context, netState, child) {
                return Chat();
              })
            ],
          )
        : SpinKitFadingCube();
  }
}
