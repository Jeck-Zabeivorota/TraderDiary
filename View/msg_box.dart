import 'package:flutter/material.dart';
import 'colors.dart';
import 'elements.dart';

enum MsgBoxIcon { info, error, question, warning }

abstract class MsgBox {
  static const Map<MsgBoxIcon, Icon> _icons = {
    MsgBoxIcon.info: Icon(Icons.info, color: ViewColors.profit),
    MsgBoxIcon.error: Icon(Icons.error, color: ViewColors.loss),
    MsgBoxIcon.question: Icon(Icons.question_mark, color: ViewColors.profit),
    MsgBoxIcon.warning: Icon(Icons.warning, color: Colors.orangeAccent)
  };

  static Future<String?> show(
    BuildContext context, {
    String? title,
    String? content,
    MsgBoxIcon? icon,
    List<String> actions = const ['OK'],
  }) {
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ViewColors.card,
        surfaceTintColor: ViewColors.card,
        title:
            title != null ? Text(title, style: TextStyles.capture()) : null,
        content: content != null
            ? Text(content, style: TextStyles.text())
            : null,
        icon: icon != null ? _icons[icon] : null,
        actions: List.generate(
          actions.length,
          (i) => TextButton(
            onPressed: () => Navigator.pop(context, actions[i]),
            style: ButtonStyles.flatButton(color: ViewColors.profit),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(actions[i]),
            ),
          ),
        ),
      ),
    );
  }
}
