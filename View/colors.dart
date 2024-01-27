import 'package:flutter/material.dart';

abstract class _IColorsSet {
  abstract final Color mainText, secondText, background, card, click, shadow;
}

class _LigthColors implements _IColorsSet {
  @override
  final Color mainText = const Color.fromARGB(255, 35, 35, 35);
  @override
  final Color secondText = const Color.fromARGB(255, 115, 115, 115);
  @override
  final Color background = const Color.fromARGB(255, 245, 250, 245);
  @override
  final Color card = Colors.white;
  @override
  final Color click = const Color.fromARGB(255, 245, 245, 245);
  @override
  final Color shadow = const Color.fromARGB(50, 0, 0, 0);
}

class _DarkColors implements _IColorsSet {
  @override
  final Color mainText = Colors.white;
  @override
  final Color secondText = const Color.fromARGB(255, 125, 145, 165);
  @override
  final Color background = const Color.fromARGB(255, 25, 35, 45);
  @override
  final Color card = const Color.fromARGB(255, 30, 40, 55);
  @override
  final Color click = const Color.fromARGB(255, 30, 45, 55);
  @override
  final Color shadow = const Color.fromARGB(50, 0, 0, 0);
}

/// Class for storing application colors
abstract class ViewColors {
  static _IColorsSet _data = _LigthColors();
  static bool get isDarkMode => _data.runtimeType == _DarkColors;

  static Color get mainText => _data.mainText;
  static Color get secondText => _data.secondText;
  static Color get background => _data.background;
  static Color get card => _data.card;
  static Color get click => _data.click;
  static Color get shadow => _data.shadow;
  static const Color profit = Color.fromARGB(255, 0, 170, 30);
  static const Color loss = Color.fromARGB(255, 230, 40, 0);

  static setColors({required bool isDarkMode}) =>
      _data = isDarkMode ? _DarkColors() : _LigthColors();
}
