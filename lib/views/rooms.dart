import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/views/chat/chat_wrapper_slivers.dart';

import '../network/incoming/incoming_state.dart';
import '../utils/theme.dart';
import '../utils/ui_state.dart';
import 'menu.dart';

class Rooms extends HookConsumerWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

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

    return Scaffold(
      backgroundColor: chatBackground,
      drawer: const Menu(),
      appBar: AppBar(
        title: titleText(socketConnected, "Rooms"),
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
              // debugExpanded.value = !debugExpanded.value;
            },
          ),
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: incoming.rooms.length,
        itemBuilder: (BuildContext context, int index) {
          final room = incoming.rooms[index];
          final users = room.users;
          final majorUsers = users
              .getRange(0, users.length >= 4 ? 4 : users.length - 1)
              .map((x) => x.name)
              .join(", ");
          final minorUsers = users.length > 5 ? ' + ${users.length - 5}' : '';
          final label = room.name;

          String forceReRenderAfterPurItemFill =
              dateFormatterHmsMillis.format(DateTime.now());
          String key = room.id.toString() + '-' + forceReRenderAfterPurItemFill;

          return Container(
              key: Key(key),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  incoming.currentRoomId = room.id;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatWrapperSlivers()));
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      radius: 25,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          majorUsers + minorUsers,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
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
