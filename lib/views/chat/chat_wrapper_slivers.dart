import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../hooks/scroll_controller_for_animation.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
import 'chat_messages.dart';
import 'message_input.dart';
import '../views.dart';

class ChatWrapperSlivers extends HookConsumerWidget {
  const ChatWrapperSlivers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    if (incoming.serverError != '') {
      //https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        final TextStyle snackBarErrorTextStyle = GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            incoming.serverError,
            style: snackBarErrorTextStyle,
          ),
        ));

        Future.delayed(const Duration(milliseconds: 100), () async {
          incoming.serverError = '';
        });
      });
    }

    var debugExpanded = useState(false);

    final hideFabAnimController = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 1);
    final scrollController =
        useScrollControllerForAnimation(hideFabAnimController);

    return Scaffold(
      backgroundColor: chatBackground,
      // floatingActionButton: FadeTransition(
      //   opacity: hideFabAnimController,
      //   child: ScaleTransition(
      //     scale: hideFabAnimController,
      //     child: Padding(
      //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
      //       child: FloatingActionButton.small(
      //         child: const Icon(
      //           Icons.arrow_drop_down,
      //           size: 28,
      //         ),
      //         onPressed: () {
      //           // scrollController.sc
      //         },
      //       ),
      //     ),
      //   ),
      // ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              floating: false,
              // https://stackoverflow.com/questions/50460629/how-to-remove-extra-padding-around-appbar-leading-icon-in-flutter
              // https://blog.logrocket.com/flutter-appbar-tutorial/
              // https://o7planning.org/12851/flutter-appbar
              leading: IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                ),
                onPressed: () {
                  ui.toMenuAndBack();
                },
              ),
              titleSpacing: 0,
              centerTitle: false,
              title: Column(children: [
                Text(
                  '${incoming.currentRoom.name} (${incoming.currentRoomUsersCsv})',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
                if (incoming.typing.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    incoming.typing,
                    style: GoogleFonts.manrope(
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                ]
              ]),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    debugExpanded.value = !debugExpanded.value;
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(debugExpanded.value ? 400 : 0),
                child:
                    debugExpanded.value ? Expanded(child: Log()) : Container(),
              )),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const Expanded(child: ChatMessages()),
              incoming.newPurchaseItem != null
                  ? incoming.newPurchaseItem!
                  : const MessageInput()
            ]),
          )
        ],
      ),
    );
  }
}
