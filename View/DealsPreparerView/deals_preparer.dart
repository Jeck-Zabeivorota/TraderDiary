import 'package:trader_diary/Database/Models/deal_model.dart';
import 'package:trader_diary/extension_methods.dart';

enum DealType { profit, loss, breakevent, all }

/// Class that sorts and filters lists with `DealModel`,
/// depending on the relevant parameters
class DealsPreparer {
  DealType dealType;
  bool isSortNewToOld;
  DateTime? startDate, endDate, startTime, endTime;
  String? symbol;
  double? minRatio, maxRatio;
  List<int> tagsIds;

  bool _findCoincidence(List list1, List list2) {
    for (var item1 in list1) {
      for (var item2 in list2) {
        if (item1 == item2) return true;
      }
    }
    return false;
  }

  int _timeToInt(DateTime time) => time.hour * 100 + time.minute;
  int _dateToInt(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;

  List<DealModel> filter(List<DealModel> deals) {
    // by type
    if (dealType != DealType.all) {
      Map<DealType, bool Function(DealModel)> typeFilter = {
        DealType.profit: (deal) => deal.isProfit,
        DealType.loss: (deal) => deal.isLoss,
        DealType.breakevent: (deal) => deal.isBreakeven,
      };
      deals = deals.where(typeFilter[dealType]!).toList();
    }

    // by period
    if (startDate != null || endDate != null) {
      deals = deals.where((deal) {
        int date = _dateToInt(deal.date);
        return (startDate == null || _dateToInt(startDate!) <= date) &&
            (endDate == null || _dateToInt(endDate!) >= date);
      }).toList();
    }

    // by time
    if (startTime != null || endTime != null) {
      deals = deals.where((deal) {
        int time = _timeToInt(deal.date);
        return (startTime == null || _timeToInt(startTime!) <= time) &&
            (endTime == null || _timeToInt(endTime!) >= time);
      }).toList();
    }

    // by symbol
    if (symbol != null) {
      deals = deals.where((deal) => deal.symbol.contains(symbol!)).toList();
    }

    // by ratio range
    if (minRatio != null || maxRatio != null) {
      deals = deals
          .where((deal) =>
              (minRatio == null || deal.ratio >= minRatio!) &&
              (maxRatio == null || deal.ratio <= maxRatio!))
          .toList();
    }

    // by tags
    if (tagsIds.isNotEmpty) {
      deals = deals
          .where((deal) => _findCoincidence(tagsIds, deal.tagsIds))
          .toList();
    }

    return deals;
  }

  void sort(List<DealModel> deals) {
    deals.sort(isSortNewToOld
        ? ((deal1, deal2) =>
            deal1.date == deal2.date ? 1 : (deal1.date > deal2.date ? -1 : 1))
        : ((deal1, deal2) =>
            deal1.date == deal2.date ? 0 : (deal1.date < deal2.date ? -1 : 1)));
  }

  DealsPreparer({
    this.dealType = DealType.all,
    this.isSortNewToOld = true,
    this.startDate,
    this.endDate,
    this.symbol,
    this.minRatio,
    this.maxRatio,
    this.tagsIds = const [],
  });
}
