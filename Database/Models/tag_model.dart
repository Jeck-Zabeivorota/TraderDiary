import 'package:trader_diary/extension_methods.dart';
import '../i_model.dart';

enum TagType { profit, general, loss }

class TagModel implements IModel {
  @override
  late int? id;
  late String name;
  late TagType type;
  late int accountId;

  static const Map<int, TagType> _tagsTypes = {
    1: TagType.profit,
    0: TagType.general,
    -1: TagType.loss,
  };

  static List<TagModel> selectTags({
    required List<TagModel> tags,
    bool isGeneral = false,
    bool isProfit = false,
    bool isLoss = false,
  }) {
    return tags
        .where((tag) =>
            (isGeneral && tag.type == TagType.general) ||
            (isProfit && tag.type == TagType.profit) ||
            (isLoss && tag.type == TagType.loss))
        .toList();
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': _tagsTypes.getKey(type),
        'accountId': accountId,
      };

  @override
  TagModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    type = _tagsTypes[map['type']]!;
    accountId = map['accountId'];
  }

  TagModel({
    this.id,
    required this.name,
    required this.type,
    required this.accountId,
  });
}
