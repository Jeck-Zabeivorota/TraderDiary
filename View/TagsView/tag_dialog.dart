import 'package:flutter/material.dart';
import 'package:trader_diary/View/Widgets/profitability_toggler.dart';
import '../colors.dart';
import '../elements.dart';
import 'tag_viewmodel.dart';

/// Dialog where the user can set values for a new or existing tag
///
/// Returns `true` if the tag was created or modified
class TagDialog extends StatefulWidget {
  final int? tagId;

  const TagDialog({super.key, this.tagId});

  @override
  State<TagDialog> createState() => _TagDialogState();
}

class _TagDialogState extends State<TagDialog> {
  late final TagViewModel data;

  @override
  void initState() {
    super.initState();
    data = TagViewModel(onUpdate: setState, tagId: widget.tagId);
  }

  @override
  void dispose() {
    super.dispose();
    data.dispose();
  }

  Widget _createFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Templates.field(
          label: 'Тип',
          child: ProfitabilityToggler(
            onToggle: (value) =>
                setState(() => data.profitabilityControl = value),
            profitability: data.profitabilityControl,
            isUnselect: true,
          ),
          indent: 5,
        ),
        const SizedBox(height: 30),
        Templates.field(
          label: 'Название',
          child: TextField(
            controller: data.nameControl,
            style: TextStyles.text(),
            decoration: InputDecorations.field(),
          ),
        ),
      ],
    );
  }

  Widget _createButton({
    required String text,
    required void Function() onPressed,
    Color? color,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyles.flatButton(color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Templates.card(
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text('${widget.tagId == null ? 'Создание' : 'Изминение'} тега',
                style: TextStyles.text()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: _createFields(),
            ),
            Row(
              children: [
                Expanded(
                  child: _createButton(
                    text: 'Отмена',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: _createButton(
                    text: widget.tagId == null ? 'Создать' : 'Сохранить',
                    onPressed: () => data.onSave(context),
                    color: ViewColors.profit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
