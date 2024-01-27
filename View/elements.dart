import 'package:flutter/material.dart';
import 'colors.dart';

abstract class TextStyles {
  static TextStyle text(
          {Color? color,
          double? fontSize,
          String? fontFamily,
          FontWeight? fontWeight}) =>
      TextStyle(
        color: color ?? ViewColors.mainText,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? 'Jost',
        fontWeight: fontWeight ?? FontWeight.normal,
      );

  static TextStyle capture({Color? color}) => text(
        color: color,
        fontWeight: FontWeight.w500,
      );

  static TextStyle second({Color? color}) => text(
        color: color ?? ViewColors.secondText,
        fontSize: 11,
      );

  static TextStyle bigCapture({Color? color}) => text(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
}

abstract class ButtonStyles {
  static ButtonStyle elevatedButton({
    Color? backgroundColor,
    Color? overlayColor,
    double? elevation,
    Color? shadowColor,
    BorderSide side = BorderSide.none,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) =>
      ButtonStyle(
        mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return (overlayColor ?? ViewColors.secondText).withAlpha(5);
          }
          return Colors.white.withAlpha(1);
        }),
        backgroundColor:
            MaterialStateProperty.all(backgroundColor ?? ViewColors.card),
        surfaceTintColor:
            MaterialStateProperty.all(backgroundColor ?? ViewColors.card),
        elevation: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) return 1;
          return elevation ?? 5;
        }),
        shadowColor:
            MaterialStateProperty.all(shadowColor ?? ViewColors.shadow),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: side,
            borderRadius:
                borderRadius ?? const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        padding: padding == null ? null : MaterialStateProperty.all(padding),
        minimumSize: MaterialStateProperty.all(const Size(0, 0)),
      );

  static ButtonStyle flatButton({
    Color? color,
    BorderSide side = BorderSide.none,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) =>
      ButtonStyle(
        mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return (color ?? ViewColors.secondText).withOpacity(0.03);
          }
          return Colors.white.withAlpha(1);
        }),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor:
            MaterialStateProperty.all(color ?? ViewColors.secondText),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: side,
            borderRadius:
                borderRadius ?? const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        padding: MaterialStateProperty.all(padding ?? const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
        minimumSize: MaterialStateProperty.all(const Size(0, 0)),
      );
}

abstract class InputDecorations {
  static InputDecoration field({
    Widget? prefix,
    Widget? suffix,
    double? width,
    bool outline = false,
  }) {
    final enabledBorderSide = BorderSide(color: ViewColors.secondText),
        focusedBorderSide = BorderSide(color: ViewColors.secondText, width: 2),
        errorBorderSide = const BorderSide(color: ViewColors.loss);

    final Function borderConstructor =
        outline ? OutlineInputBorder.new : UnderlineInputBorder.new;

    return InputDecoration(
      isDense: true,
      enabledBorder: borderConstructor(borderSide: enabledBorderSide),
      focusedBorder: borderConstructor(borderSide: focusedBorderSide),
      errorBorder: borderConstructor(borderSide: errorBorderSide),
      constraints: BoxConstraints(maxWidth: width ?? double.infinity),
      prefixStyle: TextStyles.text(color: ViewColors.secondText),
      suffixStyle: TextStyles.text(color: ViewColors.secondText),
      prefix: prefix,
      suffix: suffix,
    );
  }
}

abstract class Templates {
  static Widget card({
    Color? color,
    BorderRadiusGeometry? borderRadius,
    BorderSide side = BorderSide.none,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Widget? child,
  }) =>
      Card(
        color: color ?? ViewColors.card,
        surfaceTintColor: color ?? ViewColors.card,
        shadowColor: ViewColors.shadow,
        elevation: elevation ?? 5,
        shape: RoundedRectangleBorder(
            side: side,
            borderRadius:
                borderRadius ?? const BorderRadius.all(Radius.circular(10))),
        clipBehavior: Clip.hardEdge,
        margin: margin ?? EdgeInsets.zero,
        child: child,
      );

  static TextButton iconButton({
    required void Function()? onPressed,
    required IconData? icon,
    Color? color,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    BorderSide side = BorderSide.none,
    BorderRadius? borderRadius,
  }) =>
      TextButton(
        onPressed: onPressed,
        style: ButtonStyles.flatButton(
          color: color,
          side: side,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(3),
          child: Icon(icon, size: iconSize ?? 17),
        ),
      );

  static Widget field({
    required String label,
    required Widget child,
    double indent = 5,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyles.second()),
          SizedBox(height: indent),
          child,
        ],
      );

  static Widget dismissible({
    required int id,
    required Future<bool?> Function(DismissDirection)? onDismiss,
    required Widget child,
  }) {
    return Dismissible(
      key: ValueKey<int>(id),
      confirmDismiss: onDismiss,
      background: Container(
        color: ViewColors.loss,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.delete, color: Colors.white, size: 25),
              Icon(Icons.delete, color: Colors.white, size: 25),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
