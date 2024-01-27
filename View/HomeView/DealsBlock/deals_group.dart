import 'package:flutter/material.dart';
import 'package:trader_diary/View/colors.dart';
import 'package:trader_diary/View/elements.dart';
import 'package:trader_diary/View/HomeView/DealsBlock/groups_deal_items.dart';
import 'package:trader_diary/View/HomeView/home_viewmodel.dart';

/// Widget that displays information about the passed group of deals (`DealsGroupItemData`)
/// and displays information about each deal separately
class DealsGroup extends StatefulWidget {
  final DealsGroupItemData groupData;
  final HomeViewModel data;

  const DealsGroup({
    super.key,
    required this.data,
    required this.groupData,
  });

  @override
  State<DealsGroup> createState() => _DealsGroupState();
}

class _DealsGroupState extends State<DealsGroup> {
  bool isOpen = false;

  Widget _createGrid({
    required Widget topLeft,
    required Widget topRight,
    required Widget bottomLeft,
    required Widget bottomRight,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [topLeft, topRight],
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [bottomLeft, bottomRight],
        )
      ],
    );
  }

  Widget _createDealButton(DealItemData dealData) {
    return Templates.dismissible(
      id: dealData.id,
      onDismiss: (_) async =>
          await widget.data.deleteDeal(context, dealId: dealData.id),
      child: TextButton(
        onPressed: () =>
            widget.data.pushToDealView(context, dealId: dealData.id),
        style: ButtonStyles.flatButton(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: _createGrid(
            topLeft: Text(dealData.symbol, style: TextStyles.capture()),
            topRight: Text(
              dealData.amount,
              style: TextStyles.capture(
                color: dealData.amount[0] == '+'
                    ? ViewColors.profit
                    : ViewColors.loss,
              ),
            ),
            bottomLeft: Text(dealData.date, style: TextStyles.second()),
            bottomRight: Text(dealData.ratio, style: TextStyles.second()),
          ),
        ),
      ),
    );
  }

  Widget _createGroupButton() {
    final group = widget.groupData;

    return ElevatedButton(
      onPressed: () => setState(() => isOpen = !isOpen),
      style: ButtonStyles.elevatedButton(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: _createGrid(
          topLeft: Text(group.dealsCount, style: TextStyles.capture()),
          topRight: Text(
            group.amountsSum,
            style: TextStyles.capture(
              color: widget.groupData.amountsSum[0] == '+'
                  ? ViewColors.profit
                  : ViewColors.loss,
            ),
          ),
          bottomLeft: Text(group.minMaxDates, style: TextStyles.second()),
          bottomRight: Icon(
            !isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            size: 15,
            color: ViewColors.secondText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [_createGroupButton()];
    if (isOpen) {
      rows.addAll(
        widget.groupData.deals
            .map((dealData) => _createDealButton(dealData))
            .toList(),
      );
    }

    return Templates.card(
      margin: const EdgeInsets.only(bottom: 7),
      child: Column(children: rows),
    );
  }
}
