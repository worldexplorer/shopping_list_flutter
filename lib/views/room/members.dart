import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/person/person_dto.dart';
import '../my_router.dart';
import '../theme.dart';
import 'room_appbar.dart';

class Members extends HookConsumerWidget {
  const Members({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final incoming = ref.watch(incomingStateProvider);

    final socketConnected = incoming.socketConnected;
    final rooms = incoming.rooms;

    final roomId = rooms.currentRoomId;
    final List<PersonDto> members = rooms.currentRoomUsersOrEmpty;

    final inputCtrl = TextEditingController(text: '');
    final focusNode = useFocusNode(
      debugLabel: 'personLookupFocusNode',
    );

    return Scaffold(
      backgroundColor: chatBackground,
      appBar: AppBar(
        leading: roomLeading(context),
        titleSpacing: 0,
        centerTitle: false,
        title: roomTitle(incoming, roomId, socketConnected),
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
          existingMembers(members, Icons.add_circle),
          Flexible(
            child: Container(
                decoration: textInputDecoration,
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: TextField(
                  autofocus: true,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 1,
                  onSubmitted: (modifiedText) {
                    // TODO: debounced search
                  },
                  controller: inputCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter email or phone...',
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
          ),
          existingMembers(members, Icons.remove_circle),
        ],
      ),
    );
  }

  existingMembers(List<PersonDto> members, IconData icon) {
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
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            subtitle: Text(
              person.email,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
            ),
            trailing: Icon(icon, color: Colors.white),
          );
        });
  }
}
