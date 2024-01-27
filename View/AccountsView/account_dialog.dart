import 'package:flutter/material.dart';
import '../colors.dart';
import '../elements.dart';
import 'account_viewmodel.dart';

/// Dialog where the user can set values for a new or existing account
///
/// In case of creating or changing an account, the corresponding `AccountModel` object will be returned
class AccountDialog extends StatefulWidget {
  final int? accountId;

  const AccountDialog({super.key, this.accountId});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  late final AccountViewModel data;

  @override
  void initState() {
    super.initState();
    data = AccountViewModel(onUpdate: setState, accountId: widget.accountId);
  }

  @override
  void dispose() {
    super.dispose();
    data.dispose();
  }

  Widget _createBalanceAndCurrencyFields() {
    return Row(
      children: [
        Expanded(
          child: Templates.field(
            label: 'Начальный баланс',
            child: TextField(
              controller: data.startBalanceControl,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              style: TextStyles.text(),
              decoration:InputDecorations.field(),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Templates.field(
          label: 'Валюта',
          child: TextField(
            controller: data.currencyControl,
            style: TextStyles.text(),
            decoration: InputDecorations.field(width: 50),
          ),
        ),
      ],
    );
  }

  Widget _createButton({
    required String text,
    required void Function() onPressed,
    Color? color,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyles.flatButton(color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Templates.card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              '${widget.accountId == null ? 'Создание' : 'Изминение'} аккаунта',
              style: TextStyles.text(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Templates.field(
                label: 'Название',
                child: TextField(
                  controller: data.nameControl,
                  style: TextStyles.text(),
                  decoration: InputDecorations.field(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: _createBalanceAndCurrencyFields(),
            ),
            Row(
              children: [
                Expanded(
                  child: _createButton(
                    text: 'Отмена',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: _createButton(
                    text: widget.accountId == null ? 'Создать' : 'Сохранить',
                    onPressed: () => data.onSave(context),
                    color: ViewColors.profit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
