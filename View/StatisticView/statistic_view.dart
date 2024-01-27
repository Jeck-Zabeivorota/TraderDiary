import 'package:flutter/material.dart';
import 'dart:io';
import '../colors.dart';
import '../elements.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../Widgets/blur_appbar.dart';
import '../Widgets/winrate.dart';
import 'statistic_viewmodel.dart';

/// Screen displaying deals statistics
class StatisticView extends StatefulWidget {
  const StatisticView({super.key});

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView> {
  late final StatisticViewModel data;

  @override
  void initState() {
    super.initState();
    data = StatisticViewModel(onUpdate: setState);
  }

  TableRow _createTableRow(InfoItemData itemData) {
    Widget createItem(String? value) => value != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child:
                Text(value, style: TextStyles.text(color: itemData.color)),
          )
        : const SizedBox();

    return TableRow(children: [
      Text(itemData.name, style: TextStyles.text()),
      createItem(itemData.amountValue),
      createItem(itemData.percentValue),
      createItem(itemData.ratioValue),
    ]);
  }

  Widget _createInfoTable({bool isRestrict = false}) {
    Widget createColumnName(String value) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(value, style: TextStyles.second()),
        );

    List<TableRow> rows = [
      TableRow(children: [
        createColumnName('Название'),
        createColumnName('Количество'),
        createColumnName('Проценты'),
        createColumnName('Риск/профит')
      ]),
    ];

    for (var itemData in data.infoList) {
      rows.add(_createTableRow(itemData));

      if (itemData.isAfterDivide) {
        rows.add(TableRow(children: [
          Divider(color: ViewColors.click),
          Divider(color: ViewColors.click),
          Divider(color: ViewColors.click),
          Divider(color: ViewColors.click),
        ]));
      }
    }

    var table = Table(
      columnWidths: const {
        0: FixedColumnWidth(250),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(0.8)
      },
      children: rows,
    );

    final scrollController = ScrollController();
    return isRestrict
        ? Scrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: 900, child: table),
            ),
          )
        : table;
  }

  Widget _createAppBar() {
    return BlurAppBar(
      first: Templates.iconButton(
        onPressed: () => Navigator.pop(context),
        color: ViewColors.mainText,
        iconSize: 20,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        icon: Icons.arrow_back,
      ),
      title: Center(
        child: Text('Статистика', style: TextStyles.capture()),
      ),
      actions: [
        Templates.iconButton(
          onPressed: () => data.pushToPreparerView(context),
          color: ViewColors.mainText,
          iconSize: 20,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          icon: Icons.filter_list,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ViewColors.card,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              top: Platform.isAndroid || Platform.isIOS ? 105 : 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            children: [
              SfSparkLineChart(
                color: ViewColors.profit,
                axisLineWidth: 0,
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                data: data.chartData,
              ),
              const SizedBox(height: 20),
              Winrate(
                wins: data.winsDeals,
                losses: data.lossesDeals,
              ),
              const SizedBox(height: 30),
              _createInfoTable(
                  isRestrict: MediaQuery.of(context).size.width < 900),
            ],
          ),
          _createAppBar(),
        ],
      ),
    );
  }
}
