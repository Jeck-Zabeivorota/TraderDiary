import 'package:flutter/material.dart';
import 'package:trader_diary/View/colors.dart';
import 'package:trader_diary/View/elements.dart';

/// Widget displaying the ratio of passed won and lost deals
class Winrate extends StatelessWidget {
  final int wins, losses;

  const Winrate({
    super.key,
    required this.wins,
    required this.losses,
  });

  Widget _createProgressBar(Color color) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _createSkewer({
    required String leftLabel,
    required String centerLabel,
    required String rightLabel,
    bool centerIsCapture = false,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(leftLabel,
                style: TextStyles.second(color: ViewColors.profit)),
            Text(rightLabel,
                style: TextStyles.second(color: ViewColors.loss)),
          ],
        ),
        Text(centerLabel,
            style: centerIsCapture
                ? TextStyles.capture()
                : TextStyles.second(color: ViewColors.mainText)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratio =
        wins > 0 ? (wins / (wins + losses) * 100).toStringAsFixed(1) : '0.0';

    return Column(
      children: [
        _createSkewer(
          leftLabel: 'Прибыльные',
          centerLabel: 'Соотношение',
          rightLabel: 'Убыточные',
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: wins,
              child: _createProgressBar(ViewColors.profit),
            ),
            const SizedBox(width: 2),
            Expanded(
              flex: losses,
              child: _createProgressBar(ViewColors.loss),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _createSkewer(
          leftLabel: '$wins',
          centerLabel: '$ratio%',
          rightLabel: '$losses',
          centerIsCapture: true,
        ),
      ],
    );
  }
}
