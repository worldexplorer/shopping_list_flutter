import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../hooks/scroll_controller_for_animation.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/theme.dart';
import '../../utils/ui_notifier.dart';
import 'chat_messages.dart';
import 'flat_text_field.dart';
import '../views.dart';

class ChatWrapperSlivers extends HookConsumerWidget {
  const ChatWrapperSlivers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    var debugExpanded = useState(false);

    final hideFabAnimController = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 1);
    final scrollController =
        useScrollControllerForAnimation(hideFabAnimController);

    return Scaffold(
      backgroundColor: chatBackground,
      floatingActionButton: FadeTransition(
        opacity: hideFabAnimController,
        child: ScaleTransition(
          scale: hideFabAnimController,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: FloatingActionButton.small(
              // label: const Text(
              //   '+',
              //   // style: Theme.of(context).textTheme.headline4,
              // ),
              child: const Icon(
                Icons.arrow_drop_down,
                size: 28,
              ),
              onPressed: () {
                // scrollController.sc
              },
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
                  // FluentIcons.settings_28_filled,
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
                // PopSliverToBoxAdapter(upMenuButton(
                //   child: Icon(Icons.more_vert),
                //   itemBuilder: (BuildContext context) {
                //     return <PopupMenuEntry>[
                //       const PopupMenuItem(
                //         child: Text('Not implemented'),
                //       )
                //     ];
                //   },
                // )),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(debugExpanded.value ? 400 : 0),
                child:
                    debugExpanded.value ? Expanded(child: Log()) : Container(),
              )),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(mainAxisSize: MainAxisSize.max, children: const [
              Expanded(child: ChatMessages()),
              // Container(
              // height: 50,
              // margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              // color: Colors.yellow,
              // child: const
              // Flexible(child:
              FlatTextField()
              // )
              // ),
            ]),
          )
        ],
      ),
    );
  }
}