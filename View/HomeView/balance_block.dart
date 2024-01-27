import 'package:flutter/material.dart';
import '../colors.dart';
import '../elements.dart';
import '../Widgets/row_panel.dart';
import 'home_viewmodel.dart';

class BalanceBlock extends StatelessWidget {
  final HomeViewModel data;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;

  const BalanceBlock({
    super.key,
    required this.data,
    this.borderRadius,
    this.margin,
  });

  Widget _createDelta() {
    return Container(
      decoration: BoxDecoration(
        color: data.delta[0] == '+' ? ViewColors.profit : ViewColors.loss,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      child: Text(
        data.delta,
        style: TextStyles.text(
          color: ViewColors.card,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _createBalance() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowPanel(
            crossAxisAlignment: CrossAxisAlignment.start,
            label: Text('Баланс',
                style: TextStyles.second(color: ViewColors.mainText)),
            actions: [_createDelta()],
          ),
          const SizedBox(height: 5),
          Text(data.balance, style: TextStyles.bigCapture()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Templates.card(
      borderRadius: borderRadius,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createBalance(),
          Divider(height: 0, color: ViewColors.click),
          TextButton.icon(
            onPressed: () => data.pushToDealView(context),
            style: ButtonStyles.flatButton(
              color: ViewColors.profit,
              borderRadius: BorderRadius.zero,
            ),
            icon: const Icon(Icons.add, size: 20),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Добавить сделку',
                style:
                    TextStyles.text(color: ViewColors.profit, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
