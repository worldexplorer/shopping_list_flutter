import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../network/incoming/incoming_state.dart';
import '../utils/ui_state.dart';
import 'menu.dart';
import 'router.dart';
import 'theme.dart';

class Rooms extends HookConsumerWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final router = ref.watch(routerProvider);

    final incoming = ref.watch(incomingStateProvider);
    final socketConnected = incoming.connection.connectionState.socketConnected;

    final nameController = useTextEditingController();

    void showDialogWithFields() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('New Room'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Room name'),
                ),
              ],
            )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  var name = nameController.text;
                  incoming.outgoingHandlers.sendNewRoom(name, []);
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      );
    }

    final roomsList =
        incoming.personNullable != null ? incoming.rooms.roomsSnapList : [];

    return Scaffold(
      backgroundColor: chatBackground,
      drawer: const Menu(),
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleText(true, "Shared Shopping List"),
          if (!socketConnected)
            Text(
              'connecting...',
              style: chatSliverSubtitleStyle(false),
            ),
        ]),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back,
        //       size: 20, color: whiteOrConnecting(socketConnected)),
        //   onPressed: () {
        //     ui.toMenuAndBack();
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Navigator.pushNamed(context, router.log.path);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: roomsList.length,
        itemBuilder: (BuildContext context, int index) {
          final room = roomsList[index];
          final users = room.users;
          const firstUsersLimit = 4;
          final majorUsers = users
              .getRange(
                  0,
                  users.length >= firstUsersLimit
                      ? firstUsersLimit
                      : users.length)
              .map((x) => x.name)
              .join(", ");
          final minorUsers = users.length > firstUsersLimit
              ? ' + ${users.length - firstUsersLimit}'
              : '';
          final label = room.name;

          final messagesUnread = incoming.rooms
                  .getRoomMessagesForRoom(room.id)
                  ?.getOnlyUnreadMessages()
                  .length ??
              0;

          String forceReRenderAfterPurItemFill =
              dateFormatterHmsMillis.format(DateTime.now());
          String key = room.id.toString() + '-' + forceReRenderAfterPurItemFill;

          return ListTile(
            key: Key(key),
            dense: false,
            onTap: () {
              // incoming.rooms.setCurrentRoomId(room.id);
              Navigator.pushNamed(context, router.currentRoom.path,
                  arguments: room.id);
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              radius: 25,
            ),
            title: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            subtitle: Text(
              majorUsers + minorUsers,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
            ),
            trailing: messagesUnread == 0
                ? const SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.deepOrange.withOpacity(0.4),
                    foregroundColor: Colors.white,
                    radius: 10,
                    child:
                        Text('$messagesUnread', style: unreadMessagesTextStyle),
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Add new Room',
        onPressed: () {
          showDialogWithFields();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
