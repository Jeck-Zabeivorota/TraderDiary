import 'package:flutter/material.dart';

/// Widget that displays an `label` on the left side and `actions` on the right
class RowPanel extends StatelessWidget {
  final Widget label;
  final List<Widget> actions;
  final CrossAxisAlignment crossAxisAlignment;

  const RowPanel({
    super.key,
    required this.label,
    required this.actions,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        label,
        Row(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ],
    );
  }
}
