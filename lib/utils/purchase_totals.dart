import '../network/incoming/purchase_dto.dart';

class PurchaseTotals {
  double tQnty = .0;
  double tPrice = .0;
  double tWeight = .0;

  recalculateTotals(PurchaseDto purchase) {
    tQnty = .0;
    tPrice = .0;
    tWeight = .0;
    for (var purItem in purchase.purItems) {
      if (purItem.bought == null || purItem.bought! == false) {
        continue;
      }
      tQnty += purItem.bought_qnty ?? 0.0;
      tPrice += purItem.bought_price ?? 0.0;
      tWeight += purItem.bought_weight ?? 0.0;
    }
  }
}
