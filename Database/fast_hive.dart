import 'package:hive/hive.dart';
import 'i_model.dart';
//
import 'Models/account_model.dart';
import 'Models/deal_model.dart';
import 'Models/tag_model.dart';
import 'Models/settings_model.dart';

/// Class for quick work with the database (Hive)
abstract class FastHive {
  static const Map<Type, String> boxesNames = {
    DealModel: 'deals',
    AccountModel: 'accounts',
    TagModel: 'tags',
    SettingsModel: 'settings'
  };

  static int _getFirstFreeId(LazyBox box) {
    int id = -1;

    while (++id < box.length) {
      if (!box.containsKey(id)) return id;
    }
    return id;
  }

  static Future<void> put<T extends IModel>(T value) async {
    var box = await Hive.openLazyBox<T>(boxesNames[T]!);
    value.id ??= _getFirstFreeId(box);
    await box.put(value.id, value);
    await box.close();
  }

  static Future<void> putAll<T extends IModel>(List<T> values) async {
    var box = await Hive.openLazyBox<T>(boxesNames[T]!);
    for (var value in values) {
      value.id ??= _getFirstFreeId(box);
      await box.put(value.id!, value);
    }
    await box.close();
  }

  static Future<T> get<T extends IModel>(int id, {T? valueIfBoxEmpty}) async {
    var box = await Hive.openLazyBox<T>(boxesNames[T]!);

    if (box.isEmpty && valueIfBoxEmpty != null) {
      valueIfBoxEmpty.id ??= 0;
      await box.put(valueIfBoxEmpty.id, valueIfBoxEmpty);
      await box.close();
      return valueIfBoxEmpty;
    }

    T result = (await box.get(id))!;
    await box.close();

    return result;
  }

  static Future<List<T>> getAll<T extends IModel>() async {
    var box = await Hive.openBox<T>(boxesNames[T]!);
    List<T> values = box.values.toList();
    await box.close();
    return values;
  }

  static Future<void> delete<T extends IModel>(int id) async {
    var box = await Hive.openLazyBox<T>(boxesNames[T]!);
    await box.delete(id);
    await box.close();
  }

  static Future<bool> exists<T extends IModel>(int id) async {
    var box = await Hive.openLazyBox<T>(boxesNames[T]!);
    bool isExists = box.containsKey(id);
    await box.close();
    return isExists;
  }

  static Future<Box<T>> openBox<T extends IModel>() async =>
      await Hive.openBox<T>(boxesNames[T]!);

  static Future<LazyBox<T>> openLazyBox<T extends IModel>() async =>
      await Hive.openLazyBox<T>(boxesNames[T]!);
}
