import 'package:flutter/material.dart';
import 'package:trader_diary/View/colors.dart';

class CheckBox extends StatelessWidget {
  final bool isCheck;
  final void Function(bool) onChanged;
  final double width;
  final Color? activeColor;
  final BoxBorder? border;

  const CheckBox({
    super.key,
    required this.isCheck,
    required this.onChanged,
    this.width = 15,
    this.activeColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () => onChanged(!isCheck),
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: isCheck ? activeColor ?? ViewColors.profit : Colors.white12,
          shape: BoxShape.circle,
          border: border ??
              Border.all(color: ViewColors.secondText.withOpacity(0.6)),
        ),
        child: isCheck
            ? Icon(Icons.check, color: Colors.white, size: width * 0.66)
            : null,
      ),
    );
  }
}
