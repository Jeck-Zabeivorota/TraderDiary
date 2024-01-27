import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trader_diary/View/colors.dart';
import 'package:trader_diary/View/elements.dart';
import 'deals_grouper_viewmodel.dart';
import 'package:trader_diary/View/Widgets/period_field.dart';

/// Dialog where the user can specify the method of grouping deals (by quantity or by period)
class DealsGrouperDialog extends StatefulWidget {
  const DealsGrouperDialog({super.key});

  @override
  State<DealsGrouperDialog> createState() => _DealsGrouperDialogState();
}

class _DealsGrouperDialogState extends State<DealsGrouperDialog> {
  late final DealsGrouperViewModel data;

  @override
  void initState() {
    super.initState();
    data = DealsGrouperViewModel(onUpdate: setState);
  }

  Widget _createTabView({
    required void Function() onPressed,
    required Widget field,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(),
        Center(child: field),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyles.flatButton(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Отменить'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: onPressed,
                style: ButtonStyles.flatButton(
                  color: ViewColors.profit,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Задать'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _createLengthField() {
    return Templates.field(
      label: 'Количесво',
      child: TextField(
        onChanged: (value) =>
            setState(() => value == '0' ? data.lengthControl.text = '1' : null),
        controller: data.lengthControl,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyles.text(),
        decoration: InputDecorations.field(width: 100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Templates.card(
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                labelPadding: const EdgeInsets.symmetric(vertical: 7),
                indicatorColor: ViewColors.profit,
                overlayColor: MaterialStateProperty.all(ViewColors.profit.withAlpha(5)),
                tabs: [
                  Text('По количеству', style: TextStyles.text()),
                  Text('По периоду', style: TextStyles.text()),
                ],
              ),
              SizedBox(
                height: 120,
                child: TabBarView(
                  children: [
                    _createTabView(
                      onPressed: () => data.onSetLength(context),
                      field: _createLengthField(),
                    ),
                    _createTabView(
                      onPressed: () => data.onSetPeriod(context),
                      field: PeriodField(controller: data.periodControl),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
