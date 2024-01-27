import '../i_model.dart';

class SettingsModel implements IModel {
  @override
  late int? id;
  late int accountId;
  late bool darkMode;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'accountId': accountId,
        'darkMode': darkMode,
      };

  @override
  SettingsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    accountId = map['accountId'];
    darkMode = map['darkMode'];
  }

  SettingsModel({
    this.id,
    this.accountId = 0,
    this.darkMode = false,
  });
}
