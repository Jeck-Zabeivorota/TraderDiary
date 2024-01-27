import 'package:flutter/material.dart';
import 'package:trader_diary/Instruments/validation.dart';
import 'package:trader_diary/global_data.dart';
import '../HomeView/DealsBlock/DealGrouper/deals_grouper.dart';
//
import 'package:trader_diary/Database/fast_hive.dart';
import 'package:trader_diary/Database/Models/account_model.dart';

class AccountViewModel {
  // data

  final void Function(void Function()) onUpdate;

  AccountModel _account = AccountModel(
    name: '',
    startBalance: 0,
    currency: '',
    dealsGrouper: DealsGrouper(type: DealsGroupType.byLength, value: 10),
  );

  // bindings

  final nameControl = TextEditingController(),
      startBalanceControl = TextEditingController(text: '0.00'),
      currencyControl = TextEditingController();

  // methods

  void onSave(BuildContext context) async {
    // validation
    double? startBalance = Validation.getNumber(
      context,
      value: startBalanceControl.text,
      errorMessage: 'Начальный баланс введён не корректно',
    );
    if (startBalance == null) return;

    if (nameControl.text.isEmpty) {
      Validation.showErrorMessage(context, 'Название не введено');
      return;
    }

    if (currencyControl.text.isEmpty) {
      Validation.showErrorMessage(context, 'Валюта не введена');
      return;
    }

    // add to database
    double balance = _account.balance - _account.startBalance + startBalance;

    _account
      ..name = nameControl.text
      ..startBalance = startBalance
      ..balance = balance
      ..currency = currencyControl.text;
    await FastHive.put(_account);

    if (GlobalData.account.id == _account.id) {
      await GlobalData.loadAccountData();
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context, _account);
  }

  void dispose() {
    nameControl.dispose();
    startBalanceControl.dispose();
    currencyControl.dispose();
  }

  // initialization

  Future<void> _setData(int accountId) async {
    _account = await FastHive.get(accountId);

    nameControl.text = _account.name;
    startBalanceControl.text = _account.startBalance.toString();
    currencyControl.text = _account.currency;
  }

  AccountViewModel({required this.onUpdate, int? accountId}) {
    if (accountId != null) _setData(accountId).then((_) => onUpdate(() {}));
  }
}
