import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../widget/context_menu.dart';
import '../log.dart';
import '../my_router.dart';
import '../theme.dart';
import 'message_input.dart';
import 'messages.dart';
import 'room_appbar.dart';

class Room extends HookConsumerWidget {
  const Room({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);
    final router = ref.watch(routerProvider);
    final incoming = ref.watch(incomingStateProvider);

    var debugExpanded = useState(false);

    // final hideFabAnimController = useAnimationController(
    //     duration: kThemeAnimationDuration, initialValue: 1);
    // final scrollController =
    //     useScrollControllerForAnimation(hideFabAnimController);

    final socketConnected = incoming.socketConnected;

    // Future<void>.delayed(const Duration(milliseconds: 100), () async {
    final roomId = ModalRoute.of(context)!.settings.arguments as int;
    // when notifyListeners() happens inside build(), throws:
    //    setState() or markNeedsBuild() called during build.
    //    This UncontrolledProviderScope widget cannot be marked as needing to build b
    // invoked every rebuild() but fetches room message only once
    incoming.currentRoomId = roomId;
    // });

    return Scaffold(
      backgroundColor: chatBackground,
      body: CustomScrollView(
        // controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              floating: false,
              // https://stackoverflow.com/questions/50460629/how-to-remove-extra-padding-around-appbar-leading-icon-in-flutter
              // https://blog.logrocket.com/flutter-appbar-tutorial/
              // https://o7planning.org/12851/flutter-appbar
              leading: roomLeading(context),
              titleSpacing: 0,
              centerTitle: false,
              title: roomTitle(incoming, roomId, socketConnected,
                  incoming.rooms.currentRoomUsersCsv, () {
                Navigator.pushNamed(context, router.roomMembers.path,
                    arguments: roomId);
              }),
              actions: [
                roomActionsDropdown(context, [
                  CtxMenuItem(
                      'Mute notifications', () => router.getMessages.action()),
                  incoming.rooms.canEditCurrentRoom
                      ? CtxMenuItem(
                          'Delete Room', () => router.getMessages.action())
                      : CtxMenuItem(
                          'Leave Room', () => router.getMessages.action()),
                  CtxMenuItem('__________________', () {}),
                  CtxMenuItem('Reconnect', () => router.reconnect.action()),
                  CtxMenuItem(
                      'Get messages', () => router.getMessages.action()),
                  CtxMenuItem(
                      'Log', () => debugExpanded.value = !debugExpanded.value),
                ])
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(debugExpanded.value ? 400 : 0),
                child: debugExpanded.value
                    ? const SizedBox(height: 400, child: Log())
                    : Container(),
              )),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const Expanded(child: Messages()),
              incoming.newPurchaseMessageItem != null
                  ? incoming.newPurchaseMessageItem!
                  : const MessageInput()
            ]),
          )
        ],
      ),
    );
  }
}
