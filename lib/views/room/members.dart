import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/person/person_dto.dart';
import '../../network/outgoing/room/room_member_dto.dart';
import '../theme.dart';
import 'room_appbar.dart';

const trailingIconsSize = 20.0;
const trailingIconsSpacing = 10.0;
const trailingIconsContainerWidth =
    // 3 * trailingIconsSize + 3 * trailingIconsSpacing + 3 * 40 - 15; // ElevatedButton
    3 * trailingIconsSize + 3 * trailingIconsSpacing + 90; // IconButton
// 215.0; // Flutter Inspector

class Members extends HookConsumerWidget {
  const Members({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);
    // final router = ref.watch(routerProvider);
    final incoming = ref.watch(incomingStateProvider);
    final rooms = incoming.rooms;

    final roomId = rooms.currentRoomId;
    final List<RoomMemberDto> currentRoomMembers =
        rooms.currentRoomUsersOrEmpty.map(personToMember).toList();

    final Set<int> currentRoomMembersIds =
        currentRoomMembers.map((e) => e.person).toSet();
    final Map<int, RoomMemberDto> personsFoundAsMembersById = {};
    if (incoming.personsFound != null) {
      for (var eachFound in incoming.personsFound!) {
        final alreadyMember = currentRoomMembersIds.contains(eachFound.id);
        if (!alreadyMember) {
          personsFoundAsMembersById.putIfAbsent(
              eachFound.id, () => personToMember(eachFound));
        }
      }
    }

    final searchInputCtrl = useTextEditingController(text: '');
    final searchFocusNode = useFocusNode(
      debugLabel: 'personLookupFocusNode',
    );
    void sendSearchPerson() {
      incoming.outgoingHandlers.sendFindPersons(searchInputCtrl.text, roomId);
    }

    final personsCanEditById = useState<Map<int, RoomMemberDto>>({});
    final personsCanInviteById = useState<Map<int, RoomMemberDto>>({});

    final membersToAddById = useState<Map<int, RoomMemberDto>>({});
    final membersToRemoveById = useState<Map<int, RoomMemberDto>>({});

    final permissionsChanged = useState(false);
    final sentNewRoomMembers = useState(false);

    useEffect(() {
      if (sentNewRoomMembers.value) {
        sentNewRoomMembers.value = false;
        Navigator.of(context).pop();
      }
      return null;
    }, [incoming.rooms]);

    final hasChanges = membersToAddById.value.isNotEmpty ||
        membersToRemoveById.value.isNotEmpty;

    final welcomeMsg = useState('');
    final goodByeMsg = useState('');
    final goodByeInputCtrl = useTextEditingController(text: '');
    final goodByeFocusNode = useFocusNode(
      debugLabel: 'goodByeMessageFocusNode',
    );

    final List<RoomMemberDto> currentAndAdded = [
      ...currentRoomMembers,
      ...membersToAddById.value.values.toList()
    ];

    currentMembersIconsRenderer(RoomMemberDto eachMember) {
      final inRemoveList =
          membersToRemoveById.value.containsKey(eachMember.person);
      List<Widget> ret = [
        ...liToggle(Icons.remove_circle, inRemoveList, () {
          togglePresenceInMembersMap(membersToRemoveById, eachMember);
        }, 0, Colors.redAccent)
      ];

      final toBeDeleted =
          membersToRemoveById.value.containsKey(eachMember.person);
      if (toBeDeleted) {
        return ret;
      }

      final canEdit = personsCanEditById.value.containsKey(eachMember.person);
      final canInvite =
          personsCanInviteById.value.containsKey(eachMember.person);
      ret = [
        ...liToggle(Icons.android, canEdit, () {
          togglePresenceInMembersMap(personsCanEditById, eachMember);
          permissionsChanged.value = true;
          permissionsChanged.notifyListeners();
        }, 1),
        ...liToggle(Icons.add_to_photos, canInvite, () {
          togglePresenceInMembersMap(personsCanInviteById, eachMember);
          permissionsChanged.value = true;
          permissionsChanged.notifyListeners();
        }, 2),
        ...ret,
      ];
      return ret;
    }

    foundPersonsIconsRenderer(RoomMemberDto eachFound) {
      return [
        ...liToggle(Icons.add_circle,
            membersToAddById.value.containsKey(eachFound.person), () {
          togglePresenceInMembersMap(membersToAddById, eachFound);
        }),
      ];
    }

    return Scaffold(
      backgroundColor: chatBackground,
      appBar: AppBar(
        leading: roomLeading(context),
        titleSpacing: 0,
        centerTitle: false,
        title: roomTitle(
            incoming, roomId, incoming.socketConnected, 'Editing room members'),
        actions: hasChanges || permissionsChanged.value
            ? [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      enableFeedback: true,
                    ),
                    child: const Icon(Icons.save),
                    onPressed: () {
                      incoming.outgoingHandlers.sendEditRoomMembers(
                        incoming.personId,
                        incoming.personName,
                        roomId,
                        membersToAddById.value.values.toList(),
                        welcomeMsg.value,
                        membersToRemoveById.value.values.toList(),
                        goodByeMsg.value,
                      );
                      sentNewRoomMembers.value = true;
                    }),
              ]
            : [],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: roomMembersList(
                currentAndAdded,
                currentMembersIconsRenderer,
                (RoomMemberDto eachMember) =>
                    membersToRemoveById.value.containsKey(eachMember.person)),
          ),
          if (membersToRemoveById.value.isNotEmpty)
            goodByeField(goodByeFocusNode, goodByeInputCtrl, goodByeMsg),
          searchField(searchFocusNode, searchInputCtrl, sendSearchPerson),
          SingleChildScrollView(
            child: incoming.waitingForPersonsFound == true
                ? Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: const Icon(
                      FluentIcons.data_waterfall_24_filled,
                      size: 40.0,
                      color: Colors.white,
                    ))
                : incoming.personsFound != null &&
                        personsFoundAsMembersById.isNotEmpty
                    ? roomMembersList(personsFoundAsMembersById.values.toList(),
                        foundPersonsIconsRenderer)
                    : Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child:
                            Text('No users found', style: listItemTitleStyle)),
          ),
        ],
      ),
    );
  }
}

List<Widget> liToggle(IconData icon, bool pressed, Function() onTap,
    [int rightMargin = 0, Color colorPressed = Colors.lightGreenAccent]) {
  return [
    IconButton(
      onPressed: onTap,
      icon: Icon(icon,
          color: pressed ? colorPressed : Colors.white,
          size: trailingIconsSize),
    ),
    if (rightMargin > 0)
      SizedBox(
        width: (trailingIconsSpacing * rightMargin),
      )
  ];
}

ListView roomMembersList(List<RoomMemberDto> members,
    List<Widget> Function(RoomMemberDto member) trailingIcons,
    [bool Function(RoomMemberDto member)? markedForDeletion]) {
  return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (BuildContext context, int index) {
        final RoomMemberDto member = members[index];
        final greyOut =
            markedForDeletion != null ? markedForDeletion(member) : false;

        String key = member.person.toString();

        return ListTile(
            key: Key(key),
            dense: true,
            onTap: () {},
            // tileColor: greyOut ? Colors.black45 : Colors.transparent,
            leading: CircleAvatar(
              backgroundColor: greyOut ? Colors.black12 : Colors.grey,
              foregroundColor: greyOut ? Colors.grey : Colors.white,
              radius: 25,
            ),
            title: Text(
              member.person_name,
              style: greyOut ? listItemTitleStyleGreyedOut : listItemTitleStyle,
            ),
            subtitle: Text(
              member.person_email,
              style: greyOut
                  ? listItemSubtitleStyleGreyedOut
                  : listItemSubtitleStyle,
            ),
            trailing: Container(
                width: trailingIconsContainerWidth,
                // color: Colors.black26,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: trailingIcons(member))));
      });
}

Widget searchField(FocusNode searchFocusNode,
    TextEditingController searchInputCtrl, Function() sendSearchPerson) {
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
          focusNode: searchFocusNode,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 1,
          onSubmitted: (modifiedText) => sendSearchPerson(),
          controller: searchInputCtrl,
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

Widget goodByeField(FocusNode goodByeFocusNode,
    TextEditingController goodByeInputCtrl, ValueNotifier<String> goodByeMsg) {
  return Container(
    color: altColor,
    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
    // decoration: textInputDecoration,
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: TextField(
          autofocus: true,
          focusNode: goodByeFocusNode,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 10,
          onSubmitted: (modifiedText) => goodByeMsg.notifyListeners(),
          controller: goodByeInputCtrl,
          decoration: InputDecoration(
            hintText: 'Mention the reason why you remove users from this room',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.fromLTRB(
              12.0,
              10.0,
              12.0,
              10.0,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        )),
      ],
    ),
  );
}

void togglePresenceInMembersMap(
    ValueNotifier<Map<int, RoomMemberDto>> map, RoomMemberDto member) {
  if (map.value.containsKey(member.person)) {
    map.value.remove(member.person);
  } else {
    map.value.putIfAbsent(member.person, () => member);
  }
  map.notifyListeners();
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
