import 'package:flutter/material.dart';
import 'package:trader_diary/View/colors.dart';

enum ProfitabilityType { profit, breakeven, loss, none }

class _ProfitabilityData {
  final ProfitabilityType profitability;
  late final List<bool> selectedList;
  late final Color? fillColor;

  ProfitabilityType getProfitability(int index) {
    if (index == 0) return ProfitabilityType.profit;
    if (index == selectedList.length - 1) return ProfitabilityType.loss;
    return ProfitabilityType.breakeven;
  }

  _ProfitabilityData(this.profitability, bool isShowOther) {
    selectedList = List.filled(isShowOther ? 3 : 2, false);

    switch (profitability) {
      case ProfitabilityType.none:
        fillColor = null;
        return;
      case ProfitabilityType.profit:
        selectedList[0] = true;
        fillColor = ViewColors.profit;
        break;
      case ProfitabilityType.breakeven:
        selectedList[1] = true;
        fillColor = ViewColors.secondText;
        break;
      case ProfitabilityType.loss:
        selectedList[selectedList.length - 1] = true;
        fillColor = ViewColors.loss;
        break;
    }
  }
}

class ProfitabilityToggler extends StatelessWidget {
  final ProfitabilityType profitability;
  final bool isShowBreakeven, isUnselect;
  final void Function(ProfitabilityType) onToggle;

  const ProfitabilityToggler({
    super.key,
    required this.onToggle,
    required this.profitability,
    this.isShowBreakeven = false,
    this.isUnselect = false,
  });

  void _onPressed(int index, _ProfitabilityData data) {
    var profitability = data.getProfitability(index);

    if (profitability == data.profitability) {
      if (!isUnselect) return;
      profitability = ProfitabilityType.none;
    }

    onToggle(profitability);
  }

  @override
  Widget build(BuildContext context) {
    // check exception
    if (!isShowBreakeven && profitability == ProfitabilityType.breakeven) {
      throw Exception(
          'It is impossible to select breakeven if it is not showed');
    }

    // add toggle button
    List<Widget> buttons = [const Icon(Icons.add, size: 15)];
    if (isShowBreakeven) {
      buttons.add(const Icon(Icons.circle_outlined, size: 15));
    }
    buttons.add(const Icon(Icons.remove, size: 15));

    // build toggler
    final data = _ProfitabilityData(profitability, isShowBreakeven);

    return ToggleButtons(
      mouseCursor: SystemMouseCursors.click,
      color: ViewColors.secondText,
      selectedColor: ViewColors.card,
      fillColor: data.fillColor,
      borderColor: ViewColors.click,
      borderRadius: BorderRadius.circular(15),
      constraints: const BoxConstraints(minHeight: 25, minWidth: 35),
      isSelected: data.selectedList,
      onPressed: (index) => _onPressed(index, data),
      children: buttons,
    );
  }
}
