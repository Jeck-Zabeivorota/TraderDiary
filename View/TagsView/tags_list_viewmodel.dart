import 'package:flutter/material.dart';
import 'package:trader_diary/Database/Models/deal_model.dart';
import 'package:trader_diary/Database/fast_hive.dart';
import 'package:trader_diary/View/msg_box.dart';
import 'package:trader_diary/global_data.dart';
import 'tag_dialog.dart';
import 'package:trader_diary/Database/Models/tag_model.dart';

class TagItemData {
  final int id;
  final String name;

  TagItemData(TagModel tag)
      : id = tag.id!,
        name = tag.name;
}

class TagsListViewModel {
  // data
  final void Function(void Function()) onUpdate;
  bool isHomeViewUpdate = false;

  // bindings
  List<TagItemData> profitTags = [], lossTags = [], generalTags = [];

  // methods

  void pushToTagView(BuildContext context, {int? tagId}) async {
    bool? isUpdate = await showDialog<bool>(
      context: context,
      builder: (_) => Center(child: TagDialog(tagId: tagId)),
    );
    if (isUpdate == true) {
      isHomeViewUpdate = true;
      onUpdate(() => _setData());
    }
  }

  void onBack(BuildContext context) => Navigator.pop(context, isHomeViewUpdate);

  Future<bool?> deleteTag(BuildContext context, {required int tagId}) async {
    String? dialogResult = await MsgBox.show(
      context,
      title: 'Удаление',
      content: 'Удалить тег?',
      icon: MsgBoxIcon.question,
      actions: ['Да', 'Нет'],
    );

    if (dialogResult != 'Да') return false;

    // remove tag from deals
    List<DealModel> changedDeals = [];

    for (var deal in GlobalData.deals) {
      if (deal.tagsIds.remove(tagId)) changedDeals.add(deal);
    }
    await FastHive.putAll(changedDeals);

    // remove tag
    GlobalData.tags.removeWhere((tag) => tag.id == tagId);
    await FastHive.delete<TagModel>(tagId);

    isHomeViewUpdate = true;
    onUpdate(() => _setData());
    return true;
  }

  // initialization

  void _setData() {
    Map<TagType, List<TagItemData>> lists = {
      TagType.profit: profitTags,
      TagType.general: generalTags,
      TagType.loss: lossTags,
    };

    for (var list in lists.values) {
      list.clear();
    }

    for (var tag in GlobalData.tags) {
      lists[tag.type]!.add(TagItemData(tag));
    }
  }

  TagsListViewModel({required this.onUpdate}) {
    _setData();
  }
}
