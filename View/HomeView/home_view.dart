import 'package:flutter/material.dart';
import 'dart:io';
import '../colors.dart';
import '../elements.dart';
import '../Widgets/blur_appbar.dart';
import 'home_viewmodel.dart';
//
import 'DealsBlock/deals_block.dart';
import 'balance_block.dart';
import 'statistic_block.dart';

/// Application home screen that displays basic information
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel data;

  @override
  void initState() {
    super.initState();
    data = HomeViewModel(onUpdate: setState);
  }

  Widget _createAppBarAction(
      {required IconData icon, required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyles.flatButton(
          color: ViewColors.mainText,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _createAppBar(BuildContext context,
      {required bool showStatisticButton}) {
    return BlurAppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          data.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.capture(),
        ),
      ),
      actions: [
        _createAppBarAction(
            icon: Icons.local_offer,
            onPressed: () => data.pushToTagsListView(context)),
        showStatisticButton
            ? _createAppBarAction(
                icon: Icons.insert_chart,
                onPressed: () => data.pushToStatisticView(context))
            : const SizedBox(),
        _createAppBarAction(
            icon: Icons.account_circle,
            onPressed: () => data.pushToAccountsListView(context)),
        _createAppBarAction(
            icon: data.colorThemeIcon,
            onPressed: () => data.changeColorTheme()),
      ],
    );
  }

  Widget _createVerticalScreen() {
    return Stack(
      children: [
        ListView(
          children: [
            SizedBox(height: Platform.isAndroid || Platform.isIOS ? 65 : 40),
            BalanceBlock(data: data, margin: const EdgeInsets.all(20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DealsBlock(data: data, scrollable: false),
            ),
          ],
        ),
        _createAppBar(context, showStatisticButton: true),
      ],
    );
  }

  Widget _createHorizontalScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _createAppBar(context, showStatisticButton: false),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: DealsBlock(data: data),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      BalanceBlock(data: data),
                      const SizedBox(height: 20),
                      Expanded(child: StatisticBlock(data: data)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ViewColors.background,
      body: size.width < 600 || size.height < 500
          ? _createVerticalScreen()
          : _createHorizontalScreen(),
    );
  }
}
