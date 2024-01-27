import 'package:flutter/material.dart';
import 'package:trader_diary/View/colors.dart';
import 'package:trader_diary/View/elements.dart';
import 'package:trader_diary/View/HomeView/home_viewmodel.dart';
//
import 'package:trader_diary/View/Widgets/row_panel.dart';
import 'package:trader_diary/View/HomeView/DealsBlock/deals_group.dart';

class DealsBlock extends StatelessWidget {
  final HomeViewModel data;
  final bool scrollable;

  const DealsBlock({
    super.key,
    required this.data,
    this.scrollable = true,
  });

  Widget _createRowPanel(BuildContext context) {
    return RowPanel(
      label:
          Text('Сделки (${data.dealsCount})', style: TextStyles.capture()),
      actions: [
        Templates.iconButton(
          onPressed: () => data.showGroupingDialog(context),
          icon: Icons.folder_open,
        ),
        Templates.iconButton(
          onPressed: () => data.pushToPreparerView(context),
          icon: Icons.filter_list,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [_createRowPanel(context), const SizedBox(height: 10)];

    if (data.dealsGroups.isNotEmpty) {
      List<Widget> dealsGroups = data.dealsGroups
          .map((group) => DealsGroup(data: data, groupData: group))
          .toList();

      if (scrollable) {
        rows.add(Expanded(child: ListView(children: dealsGroups)));
      } else {
        rows.addAll(dealsGroups);
      }
    } else {
      rows.addAll([
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Сделки отсутствуют',
            style: TextStyles.text(color: ViewColors.secondText),
          ),
        ),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
