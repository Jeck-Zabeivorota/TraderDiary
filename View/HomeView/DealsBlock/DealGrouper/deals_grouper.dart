import 'package:trader_diary/Database/Models/deal_model.dart';
import 'package:trader_diary/Instruments/date_duration.dart';
import 'package:trader_diary/extension_methods.dart';

enum DealsGroupType { byLength, byPeriod }

/// Class that groups a list with `DealModel` elements, depending on the relevant parameters
class DealsGrouper {
  late DealsGroupType type;
  late dynamic value;

  // grouping

  List<List<DealModel>> _groupByLength(int length, List<DealModel> deals) {
    // input deals: 987654321
    List<List<DealModel>> groups = [];
    int i = deals.length;

    // group: (4321) (8765) (9)
    for (; i > length; i -= length) {
      groups.add(deals.getRange(i - length, i).toList());
    }
    if (i > 0) groups.add(deals.getRange(0, i).toList());

    // return: (9) (8765) (4321)
    return groups.reversed.toList();
  }

  List<List<DealModel>> _groupByPeriod(
      DateDuration period, List<DealModel> deals) {
    // input: 10 => 2 5 8 10 11 12 15 18 21 25
    // input: 10 => 25 21 18 15 12 11 10 8 5 2

    bool isNewToOld = deals.first.date > deals.last.date;

    DateTime start = deals.last.date;
    start = DateTime(
      start.year,
      start.month,
      isNewToOld ? 1 : DateDuration.daysInMonth(start.month, start.year),
    );

    DateTime end = isNewToOld ? period.addTo(start) : period.removeFrom(start);

    // group: 10 => (2 5 8 10) (11 12 15 18) (21 25)
    // group: 10 => (25 21) (18 15 12 11) (10 8 5 2)

    int i = deals.length - 1;

    List<List<DealModel>> groups = [];
    List<DealModel> group = [];

    while (i >= 0) {
      if (isNewToOld ? deals[i].date < end : deals[i].date > end) {
        group.add(deals[i--]);
        continue;
      }
      if (group.isNotEmpty) {
        groups.add(group.reversed.toList());
        group = [];
      }
      end = isNewToOld ? period.addTo(end) : period.removeFrom(end);
    }
    if (group.isNotEmpty) groups.add(group);

    return groups.reversed.toList();
  }

  // methods

  List<List<DealModel>> group(List<DealModel> deals) {
    if (deals.isEmpty) return [];

    if (type == DealsGroupType.byLength) {
      return _groupByLength(value, deals);
    }
    return _groupByPeriod(value, deals);
  }

  // initialize and convert

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'type': type.toString()};
    if (value.runtimeType == int) {
      map['value'] = value;
    } else {
      map['value'] = (value as DateDuration).toMap();
    }
    return map;
  }

  DealsGrouper.fromMap(Map<String, dynamic> map) {
    if (DealsGroupType.byLength.toString() == map['type']) {
      type = DealsGroupType.byLength;
      value = map['value'];
    } else {
      type = DealsGroupType.byPeriod;
      value = DateDuration.fromMap(Map<String, int>.from(map['value']));
    }
  }

  DealsGrouper({required this.type, required this.value});
}
