import 'package:flutter/material.dart';
import 'package:trader_diary/View/StatisticView/statistic_view.dart';
import 'package:trader_diary/extension_methods.dart';
import '../colors.dart';
import 'package:trader_diary/global_data.dart';
import '../msg_box.dart';
import 'DealsBlock/DealGrouper/deals_grouper.dart';
import 'DealsBlock/groups_deal_items.dart';
//
import '../DealsPreparerView/deals_preparer_view.dart';
import 'DealsBlock/DealGrouper/deals_grouper_dialog.dart';
import '../DealsPreparerView/deals_preparer.dart';
import '../DealView/deal_view.dart';
import '../TagsView/tags_list_view.dart';
import '../AccountsView/accounts_list_view.dart';
//
import 'package:trader_diary/Database/fast_hive.dart';
import 'package:trader_diary/Database/Models/deal_model.dart';

class HomeViewModel {
  // data

  final void Function(void Function()) onUpdate;

  final _preparer = DealsPreparer();
  late List<DealModel> _preparedDeals;

  // bindings

  String get title => GlobalData.account.name;
  IconData _colorThemeIcon = Icons.brightness_3;
  IconData get colorThemeIcon => _colorThemeIcon;

  late String _balance, _delta;
  String get balance => _balance;
  String get delta => _delta;

  late List<DealsGroupItemData> _dealsGroups;
  List<DealsGroupItemData> get dealsGroups => _dealsGroups;
  late String _dealsCount;
  String get dealsCount => _dealsCount;

  late List<double> _chartData;
  List<double> get chartData => _chartData;

  late int _winsDeals, _lossesDeals;
  int get winsDeals => _winsDeals;
  int get lossesDeals => _lossesDeals;

  // methods

  Future<void> pushToDealView(BuildContext context, {int? dealId}) async {
    final isUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DealView(dealId: dealId)),
    );
    if (isUpdate != true) return;

    onUpdate(() {
      _prepareDeals();
      _setDealsData();
      _setBalanceData();
      _setStatisticData();
    });
  }

  void pushToStatisticView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StatisticView()),
    );
  }

  Future<void> pushToPreparerView(BuildContext context) async {
    final isUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DealsPreparerView(preparer: _preparer)),
    );
    if (isUpdate != true) return;

    onUpdate(() {
      _prepareDeals();
      _setDealsData();
      _setStatisticData();
    });
  }

  Future<void> showGroupingDialog(BuildContext context) async {
    final grouper = await showDialog<DealsGrouper?>(
      context: context,
      builder: (_) => const Center(child: DealsGrouperDialog()),
    );
    if (grouper == null) return;

    GlobalData.account.dealsGrouper = grouper;
    await FastHive.put(GlobalData.account);

    onUpdate(() => _setDealsData());
  }

  Future<void> pushToTagsListView(BuildContext context) async {
    final isUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TagsListView()),
    );
    if (!isUpdate || _preparer.tagsIds.isEmpty) return;

    onUpdate(() {
      _prepareDeals();
      _setDealsData();
      _setStatisticData();
    });
  }

  Future<void> pushToAccountsListView(BuildContext context) async {
    bool isUpdate = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => const AccountsListView()));
    if (!isUpdate) return;

    onUpdate((() {
      _prepareDeals();
      _setDealsData();
      _setBalanceData();
      _setStatisticData();
    }));
  }

  Future<bool> deleteDeal(BuildContext context, {required int dealId}) async {
    String? dialogResult = await MsgBox.show(
      context,
      title: 'Удаление',
      content: 'Удалить сделку?',
      icon: MsgBoxIcon.question,
      actions: ['Да', 'Нет'],
    );

    if (dialogResult != 'Да') return false;

    var deal = _preparedDeals.firstWhere((deal) => deal.id == dealId);

    _preparedDeals.remove(deal);
    GlobalData.deals.remove(deal);
    await FastHive.delete<DealModel>(dealId);

    GlobalData.account.balance -= deal.amount;
    await FastHive.put(GlobalData.account);

    onUpdate(() {
      _setDealsData();
      _setBalanceData();
      _setStatisticData();
    });

    return true;
  }

  Future<void> changeColorTheme() async {
    onUpdate(() {
      ViewColors.setColors(isDarkMode: !ViewColors.isDarkMode);
      _colorThemeIcon =
          ViewColors.isDarkMode ? Icons.sunny : Icons.brightness_3;
    });

    GlobalData.settings.darkMode = ViewColors.isDarkMode;
    await FastHive.put(GlobalData.settings);
  }

  // set data

  void _prepareDeals() {
    _preparedDeals = _preparer.filter(GlobalData.deals);
    _preparer.sort(_preparedDeals);
  }

  void _setDealsData() {
    final account = GlobalData.account;
    _dealsCount = _preparedDeals.length.toString();

    var groups = account.dealsGrouper.group(_preparedDeals);
    _dealsGroups = groups
        .map((group) => DealsGroupItemData(group, account.currency))
        .toList();
  }

  void _setBalanceData() {
    final account = GlobalData.account;
    _balance =
        '${account.balance.toAmountString(addPlus: false)} ${account.currency}';
    _delta = '${account.deltaPercent.toAmountString()}%';
  }

  void _setStatisticData() {
    _chartData = DealModel.createChartData(_preparedDeals);

    _winsDeals = _preparedDeals.count((deal) => deal.isProfit);
    _lossesDeals = _preparedDeals.count((deal) => deal.isLoss);
  }

  // initialization

  HomeViewModel({required this.onUpdate}) {
    _prepareDeals();
    _setDealsData();
    _setBalanceData();
    _setStatisticData();
  }
}
