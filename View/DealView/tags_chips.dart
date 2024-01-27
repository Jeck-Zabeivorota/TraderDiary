import 'package:flutter/material.dart';
import '../colors.dart';
import '../elements.dart';
import 'package:trader_diary/Database/Models/tag_model.dart';

class TagsChipsController {
  List<bool> _selectedList = [];
  List<TagModel> _tags = [];

  List<bool> get selectedList => _selectedList;
  List<String> get tagsNames => _tags.map((tag) => tag.name).toList();

  List<int> getSelectedTagsIds() {
    final tagsIds = <int>[];

    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) tagsIds.add(_tags[i].id!);
    }

    return tagsIds;
  }

  void setData({List<TagModel>? tags, List<int>? selectedTagsIds}) {
    if (tags != null) _tags = tags;

    _selectedList = selectedTagsIds != null && selectedTagsIds.isNotEmpty
        ? _tags.map((tag) => selectedTagsIds.contains(tag.id)).toList()
        : _selectedList = List.filled(_tags.length, false);
  }

  TagsChipsController({
    List<TagModel>? tags,
    List<int>? selectedTagsIds,
  }) {
    setData(tags: tags, selectedTagsIds: selectedTagsIds);
  }
}

/// Widget that displays tags taken from the passed `TagsChipsController` object
class TagsChips extends StatefulWidget {
  final TagsChipsController controller;

  const TagsChips({super.key, required this.controller});

  @override
  State<TagsChips> createState() => _TagsChipsState();
}

class _TagsChipsState extends State<TagsChips> {
  Widget _createChip(int index, String label) {
    final selectlist = widget.controller.selectedList;

    return ElevatedButton(
      onPressed: () => setState(() => selectlist[index] = !selectlist[index]),
      style: ButtonStyles.elevatedButton(
        backgroundColor: selectlist[index]
            ? ViewColors.profit
            : ViewColors.profit.withOpacity(0.3),
        shadowColor: ViewColors.profit.withOpacity(0.4),
        padding: const EdgeInsets.all(10),
      ),
      child: Text(
        label,
        style: TextStyles.text(color: ViewColors.card),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> tagsNames = widget.controller.tagsNames;

    return tagsNames.isNotEmpty
        ? Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(
              tagsNames.length,
              (i) => _createChip(i, tagsNames[i]),
            ),
          )
        : Center(
            child: Text('Теги отсутствуют',
                style: TextStyles.text(color: ViewColors.secondText)),
          );
  }
}
