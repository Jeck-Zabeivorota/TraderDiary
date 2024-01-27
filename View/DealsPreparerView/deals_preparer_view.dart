import 'package:flutter/material.dart';
import 'dart:io';
import 'package:trader_diary/View/colors.dart';
import 'package:trader_diary/View/elements.dart';
import '../Widgets/time_field.dart';
import 'deals_preparer.dart';
import 'deals_preparer_viewmodel.dart';
//
import 'package:trader_diary/View/DealView/tags_chips.dart';
import 'package:trader_diary/View/Widgets/blur_appbar.dart';
import 'package:trader_diary/View/Widgets/profitability_toggler.dart';
import 'package:trader_diary/View/Widgets/checkbox.dart';
import 'package:trader_diary/View/Widgets/date_field.dart';

/// Screen where the user can set the method for sorting and filtering deals
/// to the passed object `DealsPreparer`
class DealsPreparerView extends StatefulWidget {
  final DealsPreparer preparer;

  const DealsPreparerView({super.key, required this.preparer});

  @override
  State<DealsPreparerView> createState() => _DealsPreparerViewState();
}

class _DealsPreparerViewState extends State<DealsPreparerView> {
  late final DealsPreparerViewModel data;

  @override
  void initState() {
    super.initState();
    data = DealsPreparerViewModel(onUpdate: setState, preparer: widget.preparer);
  }

  Widget _createField({required String capture, required Widget child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(capture, style: TextStyles.capture()),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _createProfitabilityField() {
    return _createField(
      capture: 'Тип',
      child: ProfitabilityToggler(
        onToggle: (value) => setState(() => data.profitabilityControl = value),
        profitability: data.profitabilityControl,
        isShowBreakeven: true,
        isUnselect: true,
      ),
    );
  }

  Widget _createSortField() {
    return _createField(
      capture: 'Сортировка',
      child: ToggleButtons(
        mouseCursor: SystemMouseCursors.click,
        color: ViewColors.secondText,
        selectedColor: ViewColors.mainText,
        fillColor: ViewColors.click,
        borderColor: ViewColors.click,
        borderRadius: BorderRadius.circular(5),
        constraints: const BoxConstraints(minHeight: 25, minWidth: 90),
        isSelected: [data.sortControl, !data.sortControl],
        onPressed: (i) => setState(() => data.sortControl = i == 0),
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.arrow_downward_rounded, size: 15),
            const SizedBox(width: 3),
            Text('С новых', style: TextStyles.text()),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.arrow_upward_rounded, size: 15),
            const SizedBox(width: 3),
            Text('С старых', style: TextStyles.text()),
          ]),
        ],
      ),
    );
  }

  Widget _createDateField(DateFieldController controller) {
    final isStart = controller == data.startDateControl;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isStart ? 'Начало' : 'Конец',
                style: TextStyles.text(color: ViewColors.secondText)),
            const SizedBox(width: 90),
            CheckBox(
              isCheck: isStart ? data.startDateIsEnable : data.endDateIsEnable,
              onChanged: (check) => setState(() => isStart
                  ? data.startDateIsEnable = check
                  : data.endDateIsEnable = check),
            ),
          ],
        ),
        const SizedBox(height: 5),
        DateField(controller: controller),
      ],
    );
  }

  Widget _createPeriodFieldsHorizontal() {
    return _createField(
      capture: 'Период',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _createDateField(data.startDateControl),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: Icon(Icons.keyboard_double_arrow_right,
                size: 20, color: ViewColors.mainText),
          ),
          _createDateField(data.endDateControl),
        ],
      ),
    );
  }

  Widget _createPeriodFieldsVertical() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Период', style: TextStyles.capture()),
        const SizedBox(height: 10),
        _createDateField(data.startDateControl),
        Padding(
          padding: const EdgeInsets.only(left: 60, top: 10, bottom: 10),
          child: Icon(Icons.keyboard_double_arrow_down,
              size: 20, color: ViewColors.mainText),
        ),
        _createDateField(data.endDateControl),
      ],
    );
  }

  Widget _createTimeField(TimeFieldController controller) {
    final isStart = controller == data.startTimeControl;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isStart ? 'Начало' : 'Конец',
                style: TextStyles.text(color: ViewColors.secondText)),
            const SizedBox(width: 35),
            CheckBox(
              isCheck: isStart ? data.startTimeIsEnable : data.endTimeIsEnable,
              onChanged: (check) => setState(() => isStart
                  ? data.startTimeIsEnable = check
                  : data.endTimeIsEnable = check),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TimeField(controller: controller),
      ],
    );
  }

  Widget _createTimeFieldsHorizontal() {
    return _createField(
      capture: 'Время',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _createTimeField(data.startTimeControl),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: Icon(Icons.keyboard_double_arrow_right,
                size: 20, color: ViewColors.mainText),
          ),
          _createTimeField(data.endTimeControl),
        ],
      ),
    );
  }

  Widget _createTimeFieldsVertical() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Время', style: TextStyles.capture()),
        const SizedBox(height: 10),
        _createTimeField(data.startTimeControl),
        Padding(
          padding: const EdgeInsets.only(left: 60, top: 10, bottom: 10),
          child: Icon(Icons.keyboard_double_arrow_down,
              size: 20, color: ViewColors.mainText),
        ),
        _createTimeField(data.endTimeControl),
      ],
    );
  }

  Widget _createSymbolField() {
    return _createField(
      capture: 'Символ',
      child: TextField(
        controller: data.symbolControl,
        style: TextStyles.text(),
        decoration: InputDecorations.field(width: 150),
      ),
    );
  }

  Widget _createRatioField(TextEditingController controller) {
    return Templates.field(
      label: '${controller == data.minRatioControl ? 'Мин' : 'Макс'} п/р',
      child: TextField(
        controller: controller,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        style: TextStyles.text(),
        decoration:
            InputDecorations.field(width: 60, suffix: const Text(':1')),
      ),
    );
  }

  Widget _createRatioRangeFields() {
    return _createField(
      capture: 'Диапазон прибыль/риска',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createRatioField(data.minRatioControl),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Icon(Icons.remove, size: 15, color: ViewColors.mainText),
          ),
          _createRatioField(data.maxRatioControl),
        ],
      ),
    );
  }

  Widget _createTagsField() {
    return _createField(
      capture: 'Теги',
      child: TagsChips(controller: data.tagsControl),
    );
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
        child: Text(
          'Сортировка и фильтрация сделок',
          style: TextStyles.capture(),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => data.onSave(context),
          style: ButtonStyles.elevatedButton(
            backgroundColor: ViewColors.mainText,
            overlayColor: ViewColors.card,
            padding: const EdgeInsets.all(10),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Text(
            'Задать',
            style: TextStyles.text(color: ViewColors.card),
          ),
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
              top: Platform.isAndroid || Platform.isIOS ? 95 : 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            children: [
              _createProfitabilityField(),
              const SizedBox(height: 40),
              _createSortField(),
              const SizedBox(height: 40),
              MediaQuery.of(context).size.width < 450
                  ? _createPeriodFieldsVertical()
                  : _createPeriodFieldsHorizontal(),
              const SizedBox(height: 40),
              MediaQuery.of(context).size.width < 300
                  ? _createTimeFieldsVertical()
                  : _createTimeFieldsHorizontal(),
              const SizedBox(height: 40),
              _createSymbolField(),
              const SizedBox(height: 40),
              _createRatioRangeFields(),
              const SizedBox(height: 40),
              _createTagsField(),
            ],
          ),
          _createAppBar(),
        ],
      ),
    );
  }
}
