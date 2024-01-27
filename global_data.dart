import 'View/colors.dart';
import 'View/HomeView/DealsBlock/DealGrouper/deals_grouper.dart';
import 'Database/fast_hive.dart';
import 'Database/Models/account_model.dart';
import 'Database/Models/deal_model.dart';
import 'Database/Models/tag_model.dart';
import 'Database/Models/settings_model.dart';

abstract class GlobalData {
  // outputs

  static late String dbPath;
  static late String imagesPath;

  static late AccountModel _account;
  static AccountModel get account => _account;

  static List<DealModel> _deals = [];
  static List<DealModel> get deals => _deals;

  static List<TagModel> _tags = [];
  static List<TagModel> get tags => _tags;

  static late SettingsModel _settings;
  static SettingsModel get settings => _settings;
  static bool _isInit = false;

  // load

  static late void Function() afterInit;

  static Future<void> loadAccountData({int? accountId}) async {
    // open logs
    if (accountId == null) {
      accountId = _settings.accountId;
    } else {
      _settings.accountId = accountId;
      await FastHive.put(_settings);
    }

    // loading last used account
    _account = await FastHive.get(accountId,
        valueIfBoxEmpty: AccountModel(
          name: 'Новий акаунт',
          startBalance: 100,
          currency: '\$',
          dealsGrouper: DealsGrouper(type: DealsGroupType.byLength, value: 10),
        ));

    // loading deals from a recently loaded account
    final deals = await FastHive.openBox<DealModel>();
    _deals = deals.values.where((deal) => deal.accountId == accountId).toList();
    await deals.close();

    // loading tags from a recently loaded account
    final tags = await FastHive.openBox<TagModel>();
    _tags = tags.values.where((tag) => tag.accountId == accountId).toList();
    await tags.close();
  }

  static Future<void> init() async {
    if (_isInit) return;

    _settings = await FastHive.get(0, valueIfBoxEmpty: SettingsModel());
    if (_settings.darkMode) ViewColors.setColors(isDarkMode: true);
    await loadAccountData();

    _isInit = true;
    afterInit();
  }
}
