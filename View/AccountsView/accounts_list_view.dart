import 'package:flutter/material.dart';
import 'dart:io';
import '../colors.dart';
import '../elements.dart';
import '../Widgets/blur_appbar.dart';
import 'package:trader_diary/View/Widgets/checkbox.dart';
import 'accounts_list_viewmodel.dart';

/// Screen that displays a list of accounts
///
/// Returns `true` if home screen data needs to be updated
class AccountsListView extends StatefulWidget {
  const AccountsListView({super.key});

  @override
  State<AccountsListView> createState() => _AccountsListViewState();
}

class _AccountsListViewState extends State<AccountsListView> {
  late final AccountsListViewModel data;

  @override
  void initState() {
    super.initState();
    data = AccountsListViewModel(onUpdate: setState);
  }

  Widget _createAccountItem(AccountItemData itemData) {
    return Templates.dismissible(
      id: itemData.id,
      onDismiss: (_) async =>
          await data.deleteAccount(context, itemData: itemData),
      child: TextButton(
        onPressed: () => data.pushToAccountView(context, itemData: itemData),
        style: ButtonStyles.flatButton(padding: const EdgeInsets.all(20)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CheckBox(
                    isCheck: itemData.isCheck,
                    onChanged: (_) => data.selectAccount(itemData: itemData),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      itemData.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text(),
                    ),
                  ),
                ],
              ),
            ),
            Text(itemData.balance, style: TextStyles.capture()),
          ],
        ),
      ),
    );
  }

  Widget _createAppBar() {
    return BlurAppBar(
      first: Templates.iconButton(
        onPressed: () => data.onBack(context),
        color: ViewColors.mainText,
        iconSize: 20,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        icon: Icons.arrow_back,
      ),
      title: Center(
        child: Text('Список аккаунтов', style: TextStyles.capture()),
      ),
      actions: [
        Templates.iconButton(
          onPressed: () => data.pushToAccountView(context),
          color: ViewColors.mainText,
          iconSize: 20,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          icon: Icons.add,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ViewColors.card,
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
              top: Platform.isAndroid || Platform.isIOS ? 85 : 60,
              left: 20,
              right: 20,
            ),
            itemCount: data.accounts.length,
            itemBuilder: (context, i) => _createAccountItem(data.accounts[i]),
          ),
          _createAppBar(),
        ],
      ),
    );
  }
}
