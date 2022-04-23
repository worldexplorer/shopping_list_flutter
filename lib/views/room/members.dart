import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/person/person_dto.dart';
import '../theme.dart';
import 'room_appbar.dart';

class Members extends HookConsumerWidget {
  const Members({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);
    // final router = ref.watch(routerProvider);
    final incoming = ref.watch(incomingStateProvider);
    final rooms = incoming.rooms;

    final roomId = rooms.currentRoomId;
    final List<PersonDto> members = rooms.currentRoomUsersOrEmpty;

    final inputCtrl = useTextEditingController(text: '');
    final focusNode = useFocusNode(
      debugLabel: 'personLookupFocusNode',
    );

    sendSearchPerson() {
      incoming.outgoingHandlers.sendFindPersons(inputCtrl.text, roomId);
    }

    return Scaffold(
      backgroundColor: chatBackground,
      appBar: AppBar(
        leading: roomLeading(context),
        titleSpacing: 0,
        centerTitle: false,
        title: roomTitle(
            incoming, roomId, incoming.socketConnected, 'Editing room members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // roomActionsDropdown(context, router, incoming, [
          //   incoming.rooms.canEditCurrentRoom
          //       ? CtxMenuItem('Delete Room', () {})
          //       : CtxMenuItem('Leave Room', () {}),
          //   CtxMenuItem('__________________', () {}),
          //   CtxMenuItem('Reconnect', () => router.reconnect.action()),
          //   CtxMenuItem('Get messages', () => router.getMessages.action()),
          //   CtxMenuItem('Log', () => router.log.widget),
          // ])
        ],
      ),
      body: Column(
        children: [
          // SingleChildScrollView(
          //   child:
          existingMembers(members, Icons.remove_circle),
          // ),
          Container(
            color: altColor,
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            // decoration: textInputDecoration,
            // margin: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: TextField(
                  autofocus: true,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 1,
                  onSubmitted: (modifiedText) => sendSearchPerson(),
                  controller: inputCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search by email or phone...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(
                      12.0,
                      0.0,
                      12.0,
                      0.0,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                )),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: sendMessageInputIconSize,
                    color: Colors.green,
                  ),
                  onPressed: sendSearchPerson,
                ),
              ],
            ),
          ),
          // SingleChildScrollView(
          //   child:
          // ,)
          incoming.waitingForPersonsFound == true
              ? Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Icon(FluentIcons.data_waterfall_24_filled))
              : incoming.personsFound != null
                  ? existingMembers(
                      incoming.personsFound ?? [], Icons.add_circle)
                  : Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text('No users found', style: listItemTitleStyle)),
          // ),
        ],
      ),
    );
  }

  ListView existingMembers(List<PersonDto> members, IconData icon) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: members.length,
        itemBuilder: (BuildContext context, int index) {
          final PersonDto person = members[index];

          String key = person.id.toString();

          return ListTile(
            key: Key(key),
            dense: true,
            onTap: () {},
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              radius: 25,
            ),
            title: Text(
              person.name,
              style: listItemTitleStyle,
            ),
            subtitle: Text(
              person.email,
              style: listItemSubtitleStyle,
            ),
            trailing: Icon(icon, color: Colors.white),
          );
        });
  }
}
