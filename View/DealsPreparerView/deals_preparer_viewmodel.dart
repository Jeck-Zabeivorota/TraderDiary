import 'package:flutter/material.dart';
import 'package:trader_diary/View/Widgets/profitability_toggler.dart';
import 'package:trader_diary/extension_methods.dart';
import 'package:trader_diary/global_data.dart';
import '../Widgets/time_field.dart';
import 'deals_preparer.dart';
import 'package:trader_diary/Instruments/validation.dart';
import 'package:trader_diary/View/DealView/tags_chips.dart';
import 'package:trader_diary/View/Widgets/date_field.dart';

class DealsPreparerViewModel {
  // data

  final void Function(void Function()) onUpdate;
  final DealsPreparer _preparer;
  static const Map<ProfitabilityType, DealType> _dealsTypes = {
    ProfitabilityType.profit: DealType.profit,
    ProfitabilityType.breakeven: DealType.breakevent,
    ProfitabilityType.loss: DealType.loss,
    ProfitabilityType.none: DealType.all,
  };

  // bindings

  ProfitabilityType profitabilityControl;
  bool sortControl,
      startDateIsEnable,
      endDateIsEnable,
      startTimeIsEnable,
      endTimeIsEnable;
  final DateFieldController startDateControl, endDateControl;
  final TimeFieldController startTimeControl, endTimeControl;
  final TextEditingController symbolControl, minRatioControl, maxRatioControl;
  final TagsChipsController tagsControl;

  // methods

  void onSave(BuildContext context) {
    // validation
    if (startDateIsEnable &&
        endDateIsEnable &&
        startDateControl.date > endDateControl.date) {
      Validation.showErrorMessage(context, 'Начальная дата опережает конечную');
      return;
    }

    double? minRatio;
    if (minRatioControl.text.isNotEmpty) {
      minRatio = Validation.getNumber(
        context,
        value: minRatioControl.text,
        errorMessage: 'Минимальное соотношение введено не корректно',
      );
      if (minRatio == null) return;
    }

    double? maxRatio;
    if (maxRatioControl.text.isNotEmpty) {
      maxRatio = Validation.getNumber(
        context,
        value: maxRatioControl.text,
        errorMessage: 'Максимальное соотношение введено не корректно',
      );
      if (maxRatio == null) return;
    }

    // set data to preparer
    _preparer
      ..dealType = _dealsTypes[profitabilityControl]!
      ..isSortNewToOld = sortControl
      ..startDate = startDateIsEnable ? startDateControl.date : null
      ..endDate = endDateIsEnable ? endDateControl.date : null
      ..startTime = startTimeIsEnable ? startTimeControl.time : null
      ..endTime = endTimeIsEnable ? endTimeControl.time : null
      ..symbol = symbolControl.text.isNotEmpty ? symbolControl.text : null
      ..minRatio = minRatio
      ..maxRatio = maxRatio
      ..tagsIds = tagsControl.getSelectedTagsIds();

    Navigator.pop(context, true);
  }

  // initialization

  DealsPreparerViewModel(
      {required this.onUpdate, required DealsPreparer preparer})
      : _preparer = preparer,
        profitabilityControl = _dealsTypes.getKey(preparer.dealType),
        sortControl = preparer.isSortNewToOld,
        startDateIsEnable = preparer.startDate != null,
        endDateIsEnable = preparer.endDate != null,
        startTimeIsEnable = preparer.startTime != null,
        endTimeIsEnable = preparer.endTime != null,
        startDateControl = DateFieldController.fromDateTime(
            date: preparer.startDate ?? DateTime.now()),
        endDateControl = DateFieldController.fromDateTime(
            date: preparer.endDate ?? DateTime.now()),
        startTimeControl = TimeFieldController.fromDateTime(
            date: preparer.startTime ?? DateTime.now()),
        endTimeControl = TimeFieldController.fromDateTime(
            date: preparer.endTime ?? DateTime.now()),
        symbolControl = TextEditingController(text: preparer.symbol),
        minRatioControl = TextEditingController(
          text: preparer.minRatio != null ? preparer.minRatio.toString() : '',
        ),
        maxRatioControl = TextEditingController(
          text: preparer.maxRatio != null ? preparer.maxRatio.toString() : '',
        ),
        tagsControl = TagsChipsController(
          tags: GlobalData.tags,
          selectedTagsIds: preparer.tagsIds,
        );
}
