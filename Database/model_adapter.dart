import 'package:hive/hive.dart';
import 'Models/account_model.dart';
import 'Models/deal_model.dart';
import 'Models/tag_model.dart';
import 'Models/settings_model.dart';
import 'i_model.dart';

class ModelAdapter<T extends IModel> extends TypeAdapter<T> {
  @override
  final int typeId;

  static const Map<Type, dynamic Function(Map<String, dynamic>)> constructors =
      {
    DealModel: DealModel.fromMap,
    AccountModel: AccountModel.fromMap,
    TagModel: TagModel.fromMap,
    SettingsModel: SettingsModel.fromMap,
  };

  @override
  T read(BinaryReader reader) =>
      constructors[T]!(Map<String, dynamic>.from(reader.readMap()));

  @override
  void write(BinaryWriter writer, T obj) => writer.writeMap(obj.toMap());

  ModelAdapter({required this.typeId});
}
