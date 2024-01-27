import 'package:flutter/material.dart';
import 'package:trader_diary/Instruments/date_duration.dart';
import 'package:trader_diary/Instruments/validation.dart';
import 'package:trader_diary/View/HomeView/DealsBlock/DealGrouper/deals_grouper.dart';
import 'package:trader_diary/global_data.dart';

class DealsGrouperViewModel {
  // data
  final void Function(void Function()) onUpdate;

  // bindings
  late final TextEditingController lengthControl;
  late final DateDuration periodControl;

  // methods

  void onSetPeriod(BuildContext context) {
    if (periodControl.isNullPeriod) {
      Validation.showErrorMessage(context, 'Период не может быть нулевым');
      return;
    }
    Navigator.pop(
      context,
      DealsGrouper(type: DealsGroupType.byPeriod, value: periodControl),
    );
  }

  void onSetLength(BuildContext context) {
    int? length = Validation.getNumber(
      context,
      value: lengthControl.text,
      errorMessage: 'Количество введенно не корректно',
    );
    if (length == null) return;

    Navigator.pop(
      context,
      DealsGrouper(type: DealsGroupType.byLength, value: length),
    );
  }

  // initialization
  DealsGrouperViewModel({required this.onUpdate}) {
    final oldGrouper = GlobalData.account.dealsGrouper;

    lengthControl = TextEditingController(
        text: oldGrouper.type == DealsGroupType.byLength
            ? oldGrouper.value.toString()
            : '10');

    periodControl = oldGrouper.type == DealsGroupType.byPeriod
        ? DateDuration.fromMap(oldGrouper.value.toMap())
        : DateDuration();
  }
}
