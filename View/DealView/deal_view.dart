import 'package:flutter/material.dart';
import 'dart:io';
import '../Widgets/time_field.dart';
import '../colors.dart';
import '../elements.dart';
import '../Widgets/blur_appbar.dart';
import '../Widgets/date_field.dart';
import '../Widgets/profitability_toggler.dart';
import 'tags_chips.dart';
import 'image_slider.dart';
import 'deal_viewmodel.dart';

/// Screen where the user can set values for a new or existing deal
///
/// Returns `true` if the deal was created or updated
class DealView extends StatefulWidget {
  final int? dealId;

  const DealView({super.key, this.dealId});

  @override
  State<DealView> createState() => _DealViewState();
}

class _DealViewState extends State<DealView> {
  late final DealViewModel data;

  @override
  void initState() {
    super.initState();
    data = DealViewModel(onUpdate: setState, dealId: widget.dealId);
  }

  @override
  void dispose() {
    super.dispose();
    data.dispose();
  }

  Widget _createDateAndTimeFields() {
    return Row(children: [
      DateField(controller: data.dateControl),
      const SizedBox(width: 40),
      TimeField(controller: data.timeControl),
    ]);
  }

  Widget _createSymbolAndRatioFields() {
    return Row(
      children: [
        Expanded(
          child: Templates.field(
            label: 'Символ',
            child: TextField(
              controller: data.symbolControl,
              style: TextStyles.text(),
              decoration: InputDecorations.field(),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Templates.field(
          label: 'Прибыль/риск',
          child: TextField(
            controller: data.ratioControl,
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            style: TextStyles.text(),
            decoration:
                InputDecorations.field(width: 60, suffix: const Text(':1')),
          ),
        ),
      ],
    );
  }

  Widget _createAmountFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Templates.field(
          label: 'Результат',
          child: ProfitabilityToggler(
            onToggle: (value) =>
                setState(() => data.profitabilityControl = value),
            profitability: data.profitabilityControl,
          ),
          indent: 5,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Templates.field(
            label: 'Сумма',
            child: TextField(
              controller: data.amountControl,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              style: TextStyles.text(),
              decoration:
                  InputDecorations.field(suffix: Text(data.currency)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createDescriptionField() {
    return Templates.field(
      label: 'Описание',
      child: TextField(
        controller: data.descriptionControl,
        style: TextStyles.text(),
        minLines: 5,
        maxLines: 10,
        decoration: InputDecorations.field(outline: true),
      ),
    );
  }

  Widget _createTagsField() {
    return Templates.field(
      label: 'Теги',
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
          '${widget.dealId == null ? 'Создание' : 'Изминение'} сделки',
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
            widget.dealId == null ? 'Создать' : 'Сохранить',
            style: TextStyles.text(color: ViewColors.card),
          ),
        ),
      ],
    );
  }

  Widget _verticalLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createDateAndTimeFields(),
        const SizedBox(height: 30),
        _createSymbolAndRatioFields(),
        const SizedBox(height: 30),
        _createAmountFields(),
        const SizedBox(height: 30),
        ImageSlider(controller: data.imageSliderControl, axis: Axis.horizontal),
        const SizedBox(height: 30),
        _createDescriptionField(),
        const SizedBox(height: 30),
        _createTagsField(),
      ],
    );
  }

  Widget _horizontalLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createDateAndTimeFields(),
              const SizedBox(height: 30),
              _createSymbolAndRatioFields(),
              const SizedBox(height: 30),
              _createAmountFields(),
              const SizedBox(height: 30),
              _createDescriptionField(),
              const SizedBox(height: 30),
              _createTagsField(),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: ImageSlider(
            controller: data.imageSliderControl,
            axis: Axis.vertical,
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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: Platform.isAndroid || Platform.isIOS ? 100 : 60,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    MediaQuery.of(context).size.width < 600
                        ? _verticalLayout()
                        : _horizontalLayout(),
              ),
            ),
          ),
          _createAppBar(),
        ],
      ),
    );
  }
}
