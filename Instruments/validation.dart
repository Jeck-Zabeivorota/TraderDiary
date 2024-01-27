import 'package:flutter/cupertino.dart';
import 'package:trader_diary/View/msg_box.dart';

abstract class Validation {
  static void showErrorMessage(BuildContext context, String text) {
    MsgBox.show(
      context,
      title: 'Ошибка',
      content: text,
      icon: MsgBoxIcon.error,
    );
  }

  static T? getNumber<T extends num>(
    BuildContext context, {
    required String value,
    required String errorMessage,
    bool onlyPositive = true,
  }) {
    String numStr = value.replaceAll(' ', '');
    dynamic number = T == int ? int.tryParse(numStr) : double.tryParse(numStr);
    if (number == null) {
      Validation.showErrorMessage(context, errorMessage);
      return null;
    }
    if (onlyPositive && number < 0) number *= -1;
    return number;
  }
}
