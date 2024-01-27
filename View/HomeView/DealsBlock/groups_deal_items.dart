import 'package:trader_diary/Database/Models/deal_model.dart';
import 'package:trader_diary/extension_methods.dart';

/// Adjusts and stores `DealModel` data for display in the `DealsBlock`
class DealItemData {
  final int id;
  final String symbol, amount, date, ratio;

  DealItemData(DealModel deal, String currency)
      : id = deal.id!,
        symbol = deal.symbol,
        amount = '${deal.amount.toAmountString()} $currency',
        date = deal.date.toStringFormat('dd.MM.yyyy'),
        ratio = '${deal.ratio}:1';
}

/// Adjusts and stores a list of `DealModel` data for display in the `DealsBlock`
class DealsGroupItemData {
  late final String dealsCount, amountsSum, minMaxDates;
  late final List<DealItemData> deals;

  DealsGroupItemData(List<DealModel> group, String currency) {
    String sum = DealModel.amountSum(group).toAmountString();
    var dates = DealModel.maxAndMinDate(group);
    String minDate = dates['min']!.toStringFormat('dd.MM.yyyy');
    String maxDate = dates['max']!.toStringFormat('dd.MM.yyyy');

    dealsCount = '${group.length} сделок';
    amountsSum = '$sum $currency';
    minMaxDates = '$minDate - $maxDate';
    deals = group.map((deal) => DealItemData(deal, currency)).toList();
  }
}
