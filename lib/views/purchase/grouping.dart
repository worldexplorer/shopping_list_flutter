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

  int? get lastGroup {
    try {
      return pgroupById.keys.last;
    } catch (e) {
      return null;
    }
  }

  String? get lastGroupName {
    return pgroupById[lastGroup];
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
      final pgroup_name =
          purItem.pgroup_name ?? pgroupById[pgroup_id] ?? newPgroupName;

      // final product_id = purItem.product_id!;
      // final product_name = purItem.product_name!;

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
    if (!canDeleteGroup(pgroupId)) {
      return;
    }
    // delete only empty group
    pgroupById.remove(pgroupId);

    // if (pgroupId < 0) {
    //   // negativeGroupsViolateForeignKey
    //   final resetToNull = productsByPgroup[pgroupId];
    //   if (resetToNull != null) {
    //     for (var newProduct in resetToNull) {
    //       newProduct.pgroup_id = null;
    //     }
    //   }
    // }
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
        //add new group
        final newGroupId = --pgroupNegSeq;
        pgroupById[newGroupId] = newPgroupName;
        emptyNamePgroupId = newGroupId;

        //add empty products[] into this group
        productsByPgroup[newGroupId] = [];
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

  bool productNameChanged(PurItemDto product) {
    bool shouldAddProductBelow = false;
    final productsInGroup = productsByPgroup[product.pgroup_id];
    if (productsInGroup == null) {
      return shouldAddProductBelow;
    }

    shouldAddProductBelow = allPurItemsHaveName(productsInGroup);
    return shouldAddProductBelow;
  }

  addProduct(PurItemDto product) {
    final shouldBeInt = product.pgroup_id;
    if (shouldBeInt == null) {
      return;
    }
    final shouldExist = productsByPgroup[shouldBeInt];
    if (shouldExist == null) {
      // should never happen: add empty products[] into this group
      productsByPgroup[shouldBeInt] = [product];
      return;
    }
    shouldExist.add(product);
  }

  deleteProduct(PurItemDto product) {
    final shouldBeInt = product.pgroup_id;
    if (shouldBeInt == null) {
      return;
    }
    final shouldExist = productsByPgroup[shouldBeInt];
    if (shouldExist == null) {
      productsByPgroup[shouldBeInt] = [product]; // should never happen
      return;
    }
    if (!shouldExist.contains(product)) {
      return;
    }
    shouldExist.remove(product);
  }
}

allPurItemsHaveName(List<PurItemDto> items) {
  int positionFound = items.indexWhere((element) => element.name == '');
  return positionFound == -1;
}

removeEmptyPuritemsLeaveOnlyLast(List<PurItemDto> items) {
  List<PurItemDto> withEmptyNames =
      items.where((element) => element.name == '').toList();
  if (withEmptyNames.length > 1) {
    for (int i = 0; i <= withEmptyNames.length - 2; i++) {
      items.remove(withEmptyNames[i]);
    }
  }
}
