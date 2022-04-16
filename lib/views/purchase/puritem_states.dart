import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

const int BOUGHT_UNCHECKED = 0;
const int BOUGHT_CHECKED = 1;
const int BOUGHT_UNKNOWN = 2;
const int BOUGHT_STOP = 3;
const int BOUGHT_HALFODNE = 4;
const int BOUGHT_QUESTION = 5;

Icon iconByBought(int bought) {
  switch (bought) {
    case BOUGHT_CHECKED:
      return const Icon(
        Icons.check_circle,
        color: Colors.lightGreenAccent,
      );

    case BOUGHT_UNKNOWN:
      return const Icon(
        Icons.query_builder,
        color: Colors.yellowAccent,
      );

    case BOUGHT_STOP:
      return const Icon(
        Icons.stop_circle_outlined,
        color: Colors.red,
      );

    case BOUGHT_HALFODNE:
      return const Icon(
        Icons.wine_bar,
        color: Colors.purpleAccent,
      );

    case BOUGHT_QUESTION:
      return const Icon(
        FluentIcons.question_16_filled,
        color: Colors.orange,
      );

    case BOUGHT_UNCHECKED:
    default:
      return const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.grey,
      );
  }
}

int cycle012345(int current, bool show_unknown, bool show_stop,
    bool show_halfdone, bool show_question) {
  // 0:unchecked => 1:checked => 2:unknown => 3:stop => 4:halfdone => 5:question => 0
  switch (current) {
    case BOUGHT_UNCHECKED:
      return BOUGHT_CHECKED;

    case BOUGHT_CHECKED:
      if (show_unknown) {
        return BOUGHT_UNKNOWN;
      }
      if (show_stop) {
        return BOUGHT_STOP;
      }
      if (show_halfdone) {
        return BOUGHT_HALFODNE;
      }
      if (show_question) {
        return BOUGHT_QUESTION;
      }
      return BOUGHT_UNCHECKED;

    case BOUGHT_UNKNOWN:
      if (show_stop) {
        return BOUGHT_STOP;
      }
      if (show_halfdone) {
        return BOUGHT_HALFODNE;
      }
      if (show_question) {
        return BOUGHT_QUESTION;
      }
      return BOUGHT_UNCHECKED;

    case BOUGHT_STOP:
      if (show_halfdone) {
        return BOUGHT_HALFODNE;
      }
      if (show_question) {
        return BOUGHT_QUESTION;
      }
      return BOUGHT_UNCHECKED;

    case BOUGHT_HALFODNE:
      if (show_question) {
        return BOUGHT_QUESTION;
      }
      return BOUGHT_UNCHECKED;

    case BOUGHT_QUESTION:
      return BOUGHT_UNCHECKED;
  }

  return BOUGHT_UNCHECKED;
}

// int cycle0231(current, bool show_unknown, bool show_stop) {
//   // 0:unchecked => 2:unknown => 3:stop => 1:checked => 0
//   switch (current) {
//     case BOUGHT_UNCHECKED:
//       if (show_unknown) {
//         return BOUGHT_UNKNOWN;
//       }
//       if (show_stop) {
//         return BOUGHT_STOP;
//       }
//       return BOUGHT_CHECKED;
//
//     case BOUGHT_UNKNOWN:
//       if (show_stop) {
//         return BOUGHT_STOP;
//       }
//       return BOUGHT_CHECKED;
//
//     case BOUGHT_STOP:
//       return BOUGHT_CHECKED;
//
//     case BOUGHT_CHECKED:
//       return BOUGHT_UNCHECKED;
//   }
//   return BOUGHT_UNCHECKED;
// }

String bought2str(int current) {
  switch (current) {
    case BOUGHT_UNCHECKED:
      return "BOUGHT_UNCHECKED";
    case BOUGHT_CHECKED:
      return "BOUGHT_CHECKED";
    case BOUGHT_UNKNOWN:
      return "BOUGHT_UNKNOWN";
    case BOUGHT_STOP:
      return "BOUGHT_STOP";
    case BOUGHT_HALFODNE:
      return "BOUGHT_HALFDONE";
    case BOUGHT_QUESTION:
      return "BOUGHT_QUESTION";
  }

  return "BOUGHT_UNRESOLVED";
}
