import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:trader_diary/View/colors.dart';
import 'global_data.dart';
import 'View/HomeView/home_view.dart';
//
import 'Database/model_adapter.dart';
import 'Database/Models/account_model.dart';
import 'Database/Models/deal_model.dart';
import 'Database/Models/tag_model.dart';
import 'Database/Models/settings_model.dart';

Future<void> requestRermissions() async {
  if ((Platform.isAndroid || Platform.isIOS) &&
      await Permission.storage.request().isDenied) exit(0);
}

Future<void> setWindowSize() async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await DesktopWindow.setMinWindowSize(const Size(400, 500));
  }
}

void initHive() {
  if (Platform.isWindows) {
    GlobalData.dbPath = 'Data\\';
  } else if (Platform.isLinux || Platform.isMacOS) {
    GlobalData.dbPath = 'Data/';
  } else if (Platform.isAndroid) {
    GlobalData.dbPath = '/storage/emulated/0/Trader diary/';
  } else {
    exit(0);
  }
  GlobalData.imagesPath =
      '${GlobalData.dbPath}images${Platform.isWindows ? '\\' : '/'}';

  Hive.registerAdapter(ModelAdapter<DealModel>(typeId: 0));
  Hive.registerAdapter(ModelAdapter<AccountModel>(typeId: 1));
  Hive.registerAdapter(ModelAdapter<TagModel>(typeId: 2));
  Hive.registerAdapter(ModelAdapter<SettingsModel>(typeId: 3));
  Hive.init(GlobalData.dbPath);

  var dir = Directory(GlobalData.dbPath);
  if (!dir.existsSync()) dir.createSync();

  dir = Directory(GlobalData.imagesPath);
  if (!dir.existsSync()) dir.createSync();
}

void main() async {
  runApp(const App());
  await requestRermissions();
  await setWindowSize();
  initHive();
  await GlobalData.init();
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget startScreen = Container(
    color: ViewColors.profit,
    child: Center(child: Icon(
      Icons.bar_chart_rounded,
      color: ViewColors.card,
      size: 50,
    )),
  );

  @override
  void initState() {
    super.initState();
    GlobalData.afterInit = () => setState(() => startScreen = const HomeView());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trader diary',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ViewColors.profit,
          selectionColor: ViewColors.profit.withOpacity(0.2),
        ),
      ),
      home: startScreen,
    );
  }
}
