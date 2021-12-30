import 'package:flutter/material.dart';
import 'package:shopping_list_flutter/network/common/purchase_dto.dart';

class Purchase extends StatelessWidget {
  PurchaseDto purchase;

  Purchase({
    Key? key,
    required this.purchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blueGrey, height: 200, width: 400);
  }
}
