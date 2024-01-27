import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../colors.dart';
import '../elements.dart';
import 'home_viewmodel.dart';
import '../Widgets/winrate.dart';

class StatisticBlock extends StatefulWidget {
  final HomeViewModel data;
  const StatisticBlock({super.key, required this.data});

  @override
  State<StatisticBlock> createState() => _StatisticBlockState();
}

class _StatisticBlockState extends State<StatisticBlock> {
  @override
  Widget build(BuildContext context) {
    return Templates.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text('Статистика', style: TextStyles.capture()),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SfSparkLineChart(
                color: ViewColors.profit,
                axisLineWidth: 0,
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                data: widget.data.chartData,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Winrate(
              wins: widget.data.winsDeals,
              losses: widget.data.lossesDeals,
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 0, color: ViewColors.click),
          TextButton(
            onPressed: () => widget.data.pushToStatisticView(context),
            style: ButtonStyles.flatButton(borderRadius: BorderRadius.zero),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Text('Показать больше',
                  style: TextStyles.text(color: ViewColors.secondText)),
            ),
          ),
        ],
      ),
    );
  }
}
