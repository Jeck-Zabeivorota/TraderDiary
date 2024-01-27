import 'package:flutter/material.dart';
import 'package:trader_diary/extension_methods.dart';
import 'package:trader_diary/global_data.dart';
import '../colors.dart';
import '../DealsPreparerView/deals_preparer_view.dart';
import '../DealsPreparerView/deals_preparer.dart';
import 'package:trader_diary/Database/Models/deal_model.dart';

/// Adjusts and stores passed data for display in the `StatisticView`
class InfoItemData {
  final String name;
  final String? amountValue, percentValue, ratioValue;
  final Color? color;
  final bool isAfterDivide;

  InfoItemData({
    required this.name,
    required num amount,
    double? percent,
    double? ratio,
    bool addPlus = true,
    this.color,
    this.isAfterDivide = false,
  })  : amountValue = amount.runtimeType == double
            ? '${(amount as double).toAmountString(addPlus: addPlus)} ${GlobalData.account.currency}'
            : amount.toString(),
        percentValue = percent != null
            ? '${percent.toAmountString(addPlus: addPlus)}%'
            : null,
        ratioValue = ratio != null
            ? '${ratio.toAmountString(latestNumbers: 1, addPlus: addPlus)}:1'
            : null;
}

/// Calculated and stores statistic data
class StatisticData {
  late final double totalAmount, totalPercent, totalRatio;
  late final double avrAmount, avrPercent, avrRatio;
  late final double countPercent;
  late final List<DealModel> deals;

  StatisticData(
    List<DealModel> allDeals, {
    required bool isProfit,
  }) {
    deals = allDeals
        .where(isProfit ? (deal) => deal.isProfit : (deal) => deal.isLoss)
        .toList();

    if (deals.isNotEmpty) {
      totalAmount = DealModel.amountSum(deals);
      totalPercent = totalAmount / GlobalData.account.startBalance * 100;
      totalRatio =
          isProfit ? DealModel.ratioSum(deals) : -deals.length.toDouble();

      avrAmount = totalAmount / deals.length;
      avrPercent = totalPercent / deals.length;
      avrRatio = totalRatio / deals.length;
    } else {
      totalAmount = totalPercent = totalRatio = 0;
      avrAmount = avrPercent = avrRatio = 0;
    }

    countPercent = deals.length / allDeals.length * 100;
  }
}

class StatisticViewModel {
  // data
  final void Function(void Function()) onUpdate;
  final DealsPreparer _preparer = DealsPreparer();

  // bindings

  late List<double> _chartData;
  List<double> get chartData => _chartData;

  late int _winsDeals, _lossesDeals;
  int get winsDeals => _winsDeals;
  int get lossesDeals => _lossesDeals;

  List<InfoItemData> infoList = [];

  // methods

  Color _getColorByValue(num value) => value == 0
      ? ViewColors.secondText
      : value > 0
          ? ViewColors.profit
          : ViewColors.loss;

  Future<void> pushToPreparerView(BuildContext context) async {
    final isUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DealsPreparerView(preparer: _preparer)),
    );
    if (isUpdate != true) return;

    onUpdate(() => _updateData());
  }

  // initialization

  void _updateData() {
    var account = GlobalData.account;
    var deals = _preparer.filter(GlobalData.deals);

    double totalAmount = DealModel.amountSum(deals);
    var profitData = StatisticData(deals, isProfit: true);
    var lossData = StatisticData(deals, isProfit: false);

    // chart
    _chartData = DealModel.createChartData(deals);

    // winrate
    _winsDeals = profitData.deals.length;
    _lossesDeals = lossData.deals.length;

    // rows
    double efficiencyAmount = totalAmount / deals.length;
    int breakeventsCount = deals.count((deal) => deal.isBreakeven);

    infoList.clear();
    infoList.addAll([
      // balance
      InfoItemData(
          name: 'Начальный баланс:',
          amount: account.startBalance,
          addPlus: false),
      InfoItemData(
          name: 'Нынешний баланс:',
          amount: account.startBalance + totalAmount,
          addPlus: false),
      InfoItemData(
          name: 'Результат:',
          amount: totalAmount,
          percent: totalAmount / account.startBalance * 100,
          ratio: profitData.totalRatio + lossData.totalRatio,
          color: _getColorByValue(totalAmount),
          isAfterDivide: true),

      // total
      InfoItemData(
          name: 'Общаяя прибыль:',
          amount: profitData.totalAmount,
          percent: profitData.totalPercent,
          ratio: profitData.totalRatio,
          color: ViewColors.profit),
      InfoItemData(
          name: 'Общий убыток:',
          amount: lossData.totalAmount,
          percent: lossData.totalPercent,
          ratio: lossData.totalRatio,
          color: ViewColors.loss),
      InfoItemData(
          name: 'Общий результат:',
          amount: profitData.totalAmount + lossData.totalAmount,
          percent: profitData.totalPercent + lossData.totalPercent,
          ratio: profitData.totalRatio + lossData.totalRatio,
          color:
              _getColorByValue(profitData.totalAmount + lossData.totalAmount),
          isAfterDivide: true),

      // count
      InfoItemData(
          name: 'Количество прибыльних сделок:',
          amount: profitData.deals.length,
          percent: profitData.countPercent,
          addPlus: false,
          color: ViewColors.profit),
      InfoItemData(
          name: 'Количество убыточных сделок:',
          amount: lossData.deals.length,
          percent: lossData.countPercent,
          addPlus: false,
          color: ViewColors.loss),
      InfoItemData(
          name: 'Количество безубыточных сделок:',
          amount: breakeventsCount,
          percent: breakeventsCount / deals.length * 100,
          addPlus: false,
          color: ViewColors.secondText),
      InfoItemData(
          name: 'Общее количество сделок:',
          amount: deals.length,
          isAfterDivide: true),

      // deals info
      InfoItemData(
          name: 'Средняя прибыль:',
          amount: profitData.avrAmount,
          percent: profitData.avrPercent,
          ratio: profitData.avrRatio,
          color: ViewColors.profit),
      InfoItemData(
          name: 'Средний убыток:',
          amount: lossData.avrAmount,
          percent: lossData.avrPercent,
          ratio: lossData.avrRatio,
          color: ViewColors.loss),
      InfoItemData(
          name: 'Средний результат:',
          amount: profitData.avrAmount + lossData.avrAmount,
          percent: profitData.avrPercent + lossData.avrPercent,
          ratio: profitData.avrRatio + lossData.avrRatio,
          color: _getColorByValue(profitData.avrAmount + lossData.avrAmount)),
      InfoItemData(
          name: 'Эффективность (результат на сделку):',
          amount: efficiencyAmount,
          percent: efficiencyAmount / account.startBalance * 100,
          ratio: (profitData.totalRatio + lossData.totalRatio) / deals.length,
          color: _getColorByValue(efficiencyAmount)),
    ]);
  }

  StatisticViewModel({required this.onUpdate}) {
    _updateData();
  }
}
