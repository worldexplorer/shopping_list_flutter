import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/widget/context_menu.dart';
import 'package:shopping_list_flutter/widget/message_item.dart';

import '../hooks/scroll_controller_for_animation.dart';
import '../network/incoming/incoming_state.dart';
import '../utils/theme.dart';
import '../utils/ui_notifier.dart';
import '../widget/flat_text_field.dart';
import 'views.dart';

class Chat extends HookConsumerWidget {
  late TextStyle ctxMenuItemTextStyle;
  late CtxMenuItem replyCtx;
  late CtxMenuItem forwardCtx;
  late CtxMenuItem editCtx;
  late CtxMenuItem deleteCtx;

  Chat({Key? key}) : super(key: key) {
    ctxMenuItemTextStyle = GoogleFonts.poppins(
      color: Colors.white.withOpacity(0.8),
      fontSize: 15,
    );
    // color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0);

    replyCtx = CtxMenuItem(
      'Reply',
      () {
        StaticLogger.clear();
      },
    );
    forwardCtx = CtxMenuItem(
      'Forward',
      () {
        StaticLogger.clear();
      },
    );
    editCtx = CtxMenuItem(
      'Edit',
      // true,
      () {
        StaticLogger.clear();
      },
      // ctxMenuItemTextStyle,
    );
    deleteCtx = CtxMenuItem(
      'Delete',
      () {
        StaticLogger.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    var debugExpanded = useState(false);
    final tapGlobalPosition = useState(const Offset(0, 0));
    final messagesSelected = useState<Map<int, MessageItem>>({});

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
            child: Column(children: [
              Flexible(
                child: ListView(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  children: incoming.getMessageItems
                      .map((msgItem) => addContextMenu(
                          child: Container(
                              color: msgItem.selected
                                  ? altColor
                                  : Colors.transparent,
                              child: msgItem),
                          context: context,
                          tapGlobalPosition: tapGlobalPosition,
                          items: [editCtx, replyCtx, forwardCtx, deleteCtx],
                          textStyle: ctxMenuItemTextStyle,
                          onItemTap: () {
                            final isInSelectMode =
                                messagesSelected.value.isNotEmpty;
                            if (!isInSelectMode) {
                              return;
                            }

                            if (msgItem.selected) {
                              messagesSelected.value.remove(msgItem.message.id);
                              msgItem.selected = false;
                            } else {
                              messagesSelected.value
                                  .addAll({msgItem.message.id: msgItem});
                              msgItem.selected = true;
                            }
                          },
                          onOpened: () {
                            messagesSelected.value
                                .addAll({msgItem.message.id: msgItem});
                            msgItem.selected = true;
                          },
                          onClosed: () {}))
                      .toList(),
                ),
              ),
              Container(
                  height: 50,
                  // margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  // color: Colors.yellow,
                  child: FlatTextField()),
            ]),
          )
        ],
      ),
    );
  }
}
