import 'package:flutter/material.dart';
import 'package:trader_diary/View/Widgets/profitability_toggler.dart';
import '../../Database/fast_hive.dart';
import '../../global_data.dart';
import '../../extension_methods.dart';
//
import '../Widgets/date_field.dart';
import '../Widgets/time_field.dart';
import 'image_slider.dart';
import 'tags_chips.dart';
import '../../Instruments/validation.dart';
//
import '../../Database/Models/deal_model.dart';
import '../../Database/Models/tag_model.dart';

class DealViewModel {
  // data

  final void Function(void Function()) onUpdate;

  DealModel _deal = DealModel(
    symbol: '',
    amount: 0,
    date: DateTime.now(),
    accountId: GlobalData.account.id!,
  );

  // bindings

  ProfitabilityType _profitabilityControl = ProfitabilityType.profit;
  ProfitabilityType get profitabilityControl => _profitabilityControl;
  set profitabilityControl(ProfitabilityType value) {
    _profitabilityControl = value;
    tagsControl.setData(
      tags: TagModel.selectTags(
        tags: GlobalData.tags,
        isGeneral: true,
        isProfit: value == ProfitabilityType.profit,
        isLoss: value == ProfitabilityType.loss,
      ),
      selectedTagsIds: _deal.tagsIds,
    );
  }

  final dateControl = DateFieldController.fromDateTime(date: DateTime.now());
  final timeControl = TimeFieldController.fromDateTime(date: DateTime.now());
  final symbolControl = TextEditingController(),
      ratioControl = TextEditingController(text: '1'),
      amountControl = TextEditingController(text: '0.00'),
      descriptionControl = TextEditingController();
  final imageSliderControl = ImageSliderController();
  final tagsControl = TagsChipsController();

  final String currency = GlobalData.account.currency;

  // methods

  void onSave(BuildContext context) async {
    // validation
    double? amount = Validation.getNumber(
      context,
      value: amountControl.text,
      errorMessage: 'Сумма введена не корректно',
    );
    double? ratio = Validation.getNumber(
      context,
      value: ratioControl.text,
      errorMessage: 'Риск/профит введён не корректно',
    );
    if (amount == null || ratio == null) return;

    if (symbolControl.text.isEmpty) {
      Validation.showErrorMessage(context, 'Символ не введён');
      return;
    }

    // add to database

    if (_deal.id != null) {
      GlobalData.account.balance -= _deal.amount;
      GlobalData.deals.removeWhere((deal) => deal.id == _deal.id);
    }

    _deal
      ..symbol = symbolControl.text
      ..amount =
          profitabilityControl == ProfitabilityType.profit ? amount : -amount
      ..date = DateTime(
        dateControl.year,
        dateControl.month,
        dateControl.day,
        timeControl.hour,
        timeControl.minute,
      )
      ..ratio = ratio
      ..description = descriptionControl.text
      ..imagesNames = imageSliderControl.imagesNames
      ..tagsIds = tagsControl.getSelectedTagsIds()
      ..accountId = GlobalData.account.id!;
    await FastHive.put(_deal);
    GlobalData.deals.add(_deal);

    await imageSliderControl.saveChanges();

    GlobalData.account.balance += _deal.amount;
    await FastHive.put(GlobalData.account);

    // returned to home

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  void dispose() {
    symbolControl.dispose();
    amountControl.dispose();
    descriptionControl.dispose();
    ratioControl.dispose();
  }

  // initialization

  Future<void> _setData(int dealId) async {
    _deal = GlobalData.deals.firstWhere((deal) => deal.id == dealId);

    // set data in controllers
    profitabilityControl =
        _deal.isProfit ? ProfitabilityType.profit : ProfitabilityType.loss;
    dateControl.setValues(_deal.date);
    timeControl.setValues(_deal.date);
    symbolControl.text = _deal.symbol;
    ratioControl.text = _deal.ratio.toString();
    amountControl.text = (_deal.isLoss ? -_deal.amount : _deal.amount)
        .toAmountString(addPlus: false);
    descriptionControl.text = _deal.description;
    imageSliderControl.loadImages(_deal.imagesNames);
  }

  DealViewModel({required this.onUpdate, int? dealId}) {
    if (dealId != null) {
      _setData(dealId).then((_) => onUpdate(() {}));
    } else {
      profitabilityControl = ProfitabilityType.profit;
    }
  }
}
