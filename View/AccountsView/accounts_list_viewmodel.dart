import 'package:flutter/material.dart';
import 'package:trader_diary/extension_methods.dart';
import 'package:trader_diary/global_data.dart';
import 'package:trader_diary/Instruments/validation.dart';
//
import '../msg_box.dart';
import 'account_dialog.dart';
//
import 'package:trader_diary/Database/fast_hive.dart';
import 'package:trader_diary/Database/Models/account_model.dart';
import 'package:trader_diary/Database/Models/deal_model.dart';
import 'package:trader_diary/Database/Models/tag_model.dart';

/// Adjusts and stores `AccountModel` data for display in the `AccountsList`
class AccountItemData {
  late int id;
  late String name;
  late String balance;
  bool isCheck = false;

  void setData(AccountModel account) {
    id = account.id!;
    name = account.name;
    balance =
        '${account.balance.toAmountString(addPlus: false)} ${account.currency}';
  }

  AccountItemData(AccountModel account) {
    setData(account);
  }
}

class AccountsListViewModel {
  // data

  final void Function(void Function()) onUpdate;
  bool isUpdateHomeView = false;

  // bindings

  final List<AccountItemData> _accounts = [];
  List<AccountItemData> get accounts => _accounts;

  // methods

  void onBack(BuildContext context) => Navigator.pop(context, isUpdateHomeView);

  Future<void> pushToAccountView(BuildContext context,
      {AccountItemData? itemData}) async {
    AccountModel? account = await showDialog<AccountModel>(
      context: context,
      builder: (_) => Center(child: AccountDialog(accountId: itemData?.id)),
    );
    if (account == null) return;

    if (account.id == GlobalData.account.id) isUpdateHomeView = true;

    onUpdate(() => itemData != null
        ? itemData.setData(account)
        : _accounts.add(AccountItemData(account)));
  }

  Future<void> selectAccount({required AccountItemData itemData}) async {
    if (itemData.isCheck) return;

    await GlobalData.loadAccountData(accountId: itemData.id);
    onUpdate(() {
      _accounts.firstWhere((item) => item.isCheck).isCheck = false;
      itemData.isCheck = true;
    });
    isUpdateHomeView = true;
  }

  Future<void> _deleteModelsWithAccountBindings(int accountId) async {
    // delete deals and their additions
    var deals = await FastHive.openBox<DealModel>();
    for (var deal in deals.values) {
      if (deal.accountId == accountId) await deals.delete(deal.id);
    }
    await deals.close();

    // delete tags
    var tags = await FastHive.openBox<TagModel>();
    for (var tag in tags.values) {
      if (tag.accountId == accountId) await tags.delete(tag.id);
    }
    await tags.close();
  }

  Future<bool?> deleteAccount(BuildContext context,
      {required AccountItemData itemData}) async {
    // validation
    if (_accounts.length == 1) {
      Validation.showErrorMessage(
          context, 'Должен присутстувать хотя бы один акаунт');
      return false;
    }

    // deletion confirmation
    String? dialogResult = await MsgBox.show(
      context,
      title: 'Удаление',
      content: 'Удалить аккаунт?',
      icon: MsgBoxIcon.question,
      actions: ['Да', 'Нет'],
    );
    if (dialogResult != 'Да') return false;

    // delete account
    await _deleteModelsWithAccountBindings(itemData.id);
    await FastHive.delete<AccountModel>(itemData.id);

    // update data
    _accounts.remove(itemData);
    if (itemData.isCheck) {
      await GlobalData.loadAccountData(accountId: _accounts[0].id);
      _accounts[0].isCheck = true;
      isUpdateHomeView = true;
    }

    onUpdate(() {});
    return true;
  }

  // initialization

  Future<void> _setAccounts() async {
    _accounts.clear();

    var accounts = await FastHive.openBox<AccountModel>();

    for (var account in accounts.values) {
      _accounts.add(AccountItemData(account));
      if (GlobalData.account.id == account.id) {
        _accounts.last.isCheck = true;
      }
    }

    await accounts.close();
  }

  AccountsListViewModel({required this.onUpdate}) {
    _setAccounts().then((_) => onUpdate(() {}));
  }
}
