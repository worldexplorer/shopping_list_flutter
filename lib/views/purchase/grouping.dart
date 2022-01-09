import 'package:shopping_list_flutter/network/incoming/pur_item_dto.dart';

const newPgroupName = '';

class Grouping {
  final pgroupById = <int, String>{};
  final productsByPgroup = <int, List<PurItemDto>>{};

  int pgroupNegSeq = -1;
  int productsNegSeq = -1;

  int? emptyNamePgroupId;

  List<PurItemDto> purItems;
  Grouping(this.purItems) {
    buildGroups();
  }

  void buildGroups() {
    for (var purItem in purItems) {
      if (purItem.pgroup_id == null) {
        purItem.pgroup_id = pgroupNegSeq;
        purItem.pgroup_name = newPgroupName;
      }

      if (purItem.product_id == null) {
        purItem.product_id = productsNegSeq--;
        purItem.product_name = purItem.name;
      }

      final pgroup_id = purItem.pgroup_id!;
      final pgroup_name = purItem.pgroup_name!;

      final product_id = purItem.product_id!;
      final product_name = purItem.product_name!;

      pgroupById.putIfAbsent(pgroup_id, () => pgroup_name);

      final productsForPgroup = productsByPgroup[pgroup_id];
      if (productsForPgroup != null) {
        productsByPgroup[pgroup_id]!.add(purItem);
      } else {
        productsByPgroup[pgroup_id] = [purItem];
      }
    }
  }

  canDeleteGroup(int pgroupId) {
    final thisPgroupHasNoProducts = productsByPgroup[pgroupId] == null ||
        productsByPgroup[pgroupId]!.isEmpty;
    final thisPgroupIsAutoAdded =
        emptyNamePgroupId != null && pgroupId == emptyNamePgroupId;
    return thisPgroupHasNoProducts && !thisPgroupIsAutoAdded;
  }

  deleteGroup(int pgroupId) {
    pgroupById.remove(pgroupId);
  }

  bool changeGroupName(int pgroupId, String newName) {
    pgroupById[pgroupId] = newName;

    if (newName.isNotEmpty) {
      if (emptyNamePgroupId != null) {
        try {
          final firstEmpty =
              pgroupById.entries.firstWhere((element) => element.value == '');
          emptyNamePgroupId == firstEmpty.key;
        } catch (e) {
          emptyNamePgroupId = null;
        }
      }

      if (emptyNamePgroupId == null) {
        final newGroupId = --pgroupNegSeq;
        pgroupById[newGroupId] = newPgroupName;
        emptyNamePgroupId = newGroupId;
        return true;
      }
    }

    if (newName.isEmpty) {
      // if (pgroupNegSeq + 1 == emptyNamePgroupId) {
      // if (pgroupById[emptyNamePgroupId] == null) {
      //   pgroupById.remove(emptyNamePgroupId);
      //   pgroupNegSeq++;
      //   emptyNamePgroupId ??= pgroupId;
      //   return true;
      // }
      // }
      if (emptyNamePgroupId == null) {
        emptyNamePgroupId = pgroupId;
      }
    }

    return false;
  }

// new ungrouped PurItems arrived from network?
// for (var purItem in purchase.purItems) {
//   if (purItem.pgroup_id != null && pgroupsNegSeq > purItem.pgroup_id!) {
//     pgroupsNegSeq = purItem.pgroup_id!;
//   }
//   if (purItem.product_id != null && productsNegSeq > purItem.product_id!) {
//     productsNegSeq = purItem.product_id!;
//   }
// }

}
