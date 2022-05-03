import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/person/person_dto.dart';
import '../../network/outgoing/room/room_member_dto.dart';
import '../theme.dart';
import 'room_appbar.dart';

const trailingIconsSize = 30.0;
const trailingIconsSpacing = 30.0;
const trailingIconsContainerWidth =
    // 3 * trailingIconsSize + 3 * trailingIconsSpacing + 3 * 40 - 15; // ElevatedButton
    3 * trailingIconsSize + 3 * trailingIconsSpacing + 55; // IconButton

class Members extends HookConsumerWidget {
  const Members({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);
    // final router = ref.watch(routerProvider);
    final incoming = ref.watch(incomingStateProvider);
    final rooms = incoming.rooms;

    final roomId = rooms.currentRoomId;
    final List<RoomMemberDto> members =
        List.from(rooms.currentRoomUsersOrEmpty.map(personToMember));

    final List<RoomMemberDto> membersFound = incoming.personsFound != null
        ? List.from(incoming.personsFound!.map(personToMember))
        : [];

    final inputCtrl = useTextEditingController(text: '');
    final focusNode = useFocusNode(
      debugLabel: 'personLookupFocusNode',
    );

    sendSearchPerson() {
      incoming.outgoingHandlers.sendFindPersons(inputCtrl.text, roomId);
    }

    final personsCanEditById = useState<Map<int, RoomMemberDto>>({});
    final personsCanInviteById = useState<Map<int, RoomMemberDto>>({});

    final membersToAddById = useState<Map<int, RoomMemberDto>>({});
    final membersToRemoveById = useState<Map<int, RoomMemberDto>>({});

    final sentNewRoomMembers = useState(false);

    useEffect(() {
      if (sentNewRoomMembers.value) {
        sentNewRoomMembers.value = false;
        Navigator.of(context).pop();
      }
      return null;
    }, [incoming.rooms]);

    final hasChanges = useMemoized(() {
      return membersToAddById.value.isNotEmpty ||
          membersToRemoveById.value.isNotEmpty;
    }, [membersToAddById.value, membersToRemoveById.value]);

    final welcomeMsg = useState('');
    final goodByeMsg = useState('');

    final List<RoomMemberDto> currentAndAdded = [
      ...members,
      ...List.from(membersToAddById.value.values)
    ];

    return Scaffold(
      backgroundColor: chatBackground,
      appBar: AppBar(
        leading: roomLeading(context),
        titleSpacing: 0,
        centerTitle: false,
        title: roomTitle(
            incoming, roomId, incoming.socketConnected, 'Editing room members'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              fixedSize: const Size.square(15.0),
              enableFeedback: true,
            ),
            child:
                // icon:
                const Icon(Icons.check),
            onPressed: hasChanges
                ? () {
                    incoming.outgoingHandlers.sendEditRoomMembers(
                      incoming.personId,
                      incoming.personName,
                      roomId,
                      List.from(membersToAddById.value.keys),
                      welcomeMsg.value,
                      List.from(membersToRemoveById.value.keys),
                      goodByeMsg.value,
                    );
                    sentNewRoomMembers.value = true;
                  }
                : null,
          ),
        ],
      ),
      body: Column(
        children: [
          // Expanded(
          //     child:
          // Container(
          //     color: Colors.black26,
          //     padding: const EdgeInsets.all(20),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: const [
          //         Icon(Icons.remove_circle,
          //             color: Colors.white, size: trailingIconsSize),
          //         SizedBox(
          //           width: trailingIconsSpacing,
          //         ),
          //         Icon(Icons.remove_circle,
          //             color: Colors.white, size: trailingIconsSize),
          //         SizedBox(
          //           width: trailingIconsSpacing * 2,
          //         ),
          //         Icon(Icons.remove_circle,
          //             color: Colors.white, size: trailingIconsSize),
          //       ],
          //       // )
          //     )),
          // SingleChildScrollView(
          //   child:
          personsList(
              currentAndAdded,
              (RoomMemberDto eachMember) => [
                    ...liToggle(Icons.android,
                        personsCanEditById.value.containsKey(eachMember.person),
                        () {
                      togglePresenceInMembersMap(
                          personsCanEditById.value, eachMember);
                    }, 1),
                    ...liToggle(
                        Icons.add_to_photos,
                        personsCanInviteById.value
                            .containsKey(eachMember.person), () {
                      togglePresenceInMembersMap(
                          personsCanInviteById.value, eachMember);
                    }, 2),
                    ...liToggle(
                        Icons.remove_circle,
                        membersToRemoveById.value
                            .containsKey(eachMember.person), () {
                      togglePresenceInMembersMap(
                          membersToRemoveById.value, eachMember);
                    }, 0),
                  ]),
          // ),
          searchField(focusNode, sendSearchPerson, inputCtrl),
          // SingleChildScrollView(
          //   child:
          // ,)
          incoming.waitingForPersonsFound == true
              ? Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Icon(
                    FluentIcons.data_waterfall_24_filled,
                    size: 40.0,
                    color: Colors.white,
                  ))
              : incoming.personsFound != null
                  ? personsList(
                      membersFound,
                      (RoomMemberDto eachFound) => [
                            const SizedBox(width: 185),
                            ...liToggle(
                                Icons.add_circle,
                                membersToAddById.value
                                    .containsKey(eachFound.person), () {
                              togglePresenceInMembersMap(
                                  membersToAddById.value, eachFound);
                            }, 0),
                          ])
                  : Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text('No users found', style: listItemTitleStyle)),
          // ),
        ],
      ),
    );
  }

  List<Widget> liToggle(
      IconData icon, bool pressed, Function() onTap, int rightMargin) {
    return [
      // ElevatedButton(
      //   style: ElevatedButton.styleFrom(
      //       // padding: const EdgeInsets.symmetric(horizontal: 20),
      //       shape: const RoundedRectangleBorder(
      //           borderRadius: BorderRadius.all(Radius.circular(16))),
      //       fixedSize: const Size.square(trailingIconsSize),
      //       enableFeedback: true,
      //       primary: pressed ? null : chatBackground),
      //       child:
      IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: trailingIconsSize),
      ),
      SizedBox(
        width: (trailingIconsSpacing * rightMargin),
      )
    ];
  }

  ListView personsList(List<RoomMemberDto> members,
      List<Widget> Function(RoomMemberDto person) trailingIcons) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: members.length,
        itemBuilder: (BuildContext context, int index) {
          final RoomMemberDto member = members[index];

          String key = member.person.toString();

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
                member.person_name,
                style: listItemTitleStyle,
              ),
              subtitle: Text(
                member.person_email,
                style: listItemSubtitleStyle,
              ),
              trailing: Container(
                  width: trailingIconsContainerWidth,
                  // color: Colors.black26,
                  child: Row(children: trailingIcons(member)))
              //   trailing: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: persons.length,
              //       itemBuilder: (BuildContext context, int index) {
              //         final Widget icon = trailingIcons[index];
              //         String key = index.toString();
              //         return ListTile(
              //           key: Key(key),
              //           dense: true,
              //           title: icon,
              //         );
              //       }),
              );
        });
  }

  Widget searchField(focusNode, sendSearchPerson, inputCtrl) {
    return Container(
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
    );
  }
}

// void togglePresenceInMembersMap(Map<int, RoomMemberDto> map, PersonDto person) {
//   if (map.containsKey(person.id)) {
//     map.remove(person.id);
//   } else {
//     map.putIfAbsent(person.id, () => personToMember(person));
//   }
// }

// void togglePresenceInMap(Map<int, PersonDto> map, PersonDto person) {
//   if (map.containsKey(person.id)) {
//     map.remove(person.id);
//   } else {
//     map.putIfAbsent(person.id, () => person);
//   }
// }

void togglePresenceInMembersMap(
    Map<int, RoomMemberDto> map, RoomMemberDto member) {
  if (map.containsKey(member.person)) {
    map.remove(member.person);
  } else {
    map.putIfAbsent(member.person, () => member);
  }
}

RoomMemberDto personToMember(PersonDto personDto) {
  return RoomMemberDto(
      person: personDto.id,
      person_name: personDto.name,
      person_email: personDto.email,
      person_phone: personDto.phone,
      can_edit: false,
      can_invite: true);
}
