import 'package:flutter/material.dart';
import 'package:trader_diary/extension_methods.dart';
import 'package:trader_diary/global_data.dart';
import 'package:trader_diary/Instruments/validation.dart';
import '../Widgets/profitability_toggler.dart';
import 'package:trader_diary/Database/fast_hive.dart';
import 'package:trader_diary/Database/Models/tag_model.dart';

class TagViewModel {
  // data
  final void Function(void Function()) onUpdate;
  late final TagModel _tag;
  static const Map<ProfitabilityType, TagType> _tagsTypes = {
    ProfitabilityType.profit: TagType.profit,
    ProfitabilityType.none: TagType.general,
    ProfitabilityType.loss: TagType.loss,
  };

  // bindings
  late ProfitabilityType profitabilityControl;
  final TextEditingController nameControl = TextEditingController();

  // methods

  void onSave(BuildContext context) async {
    // validation
    if (nameControl.text.isEmpty) {
      Validation.showErrorMessage(context, 'Название тега не указано');
      return;
    }

    // update/add tag in database
    if (_tag.id != null) {
      GlobalData.tags.removeWhere((tag) => tag.id == _tag.id);
    }
    _tag
      ..name = nameControl.text
      ..type = _tagsTypes[profitabilityControl]!;
    await FastHive.put(_tag);
    GlobalData.tags.add(_tag);

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  void dispose() {
    nameControl.dispose();
  }

  // initialization
  TagViewModel({required this.onUpdate, int? tagId}) {
    _tag = tagId != null
        ? GlobalData.tags.firstWhere((tag) => tag.id == tagId)
        : TagModel(
            name: '', type: TagType.general, accountId: GlobalData.account.id!);

    profitabilityControl = _tagsTypes.getKey(_tag.type);
    nameControl.text = _tag.name;
  }
}
