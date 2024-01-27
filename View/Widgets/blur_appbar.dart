import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui';
import '../colors.dart';
import '../elements.dart';

class BlurAppBar extends StatelessWidget {
  final Widget? first, title, top, bottom;
  final List<Widget>? actions;
  final Color? overColor;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final BorderRadiusGeometry? borderRadius;

  const BlurAppBar({
    super.key,
    this.first,
    this.title,
    this.actions,
    this.top,
    this.bottom,
    this.overColor,
    this.elevation = 0,
    this.padding,
    this.blur = 10,
    this.borderRadius,
  });

  Widget _createMainElements() {
    List<Widget> widgets = [];

    if (first != null) widgets.add(first!);
    if (title != null) widgets.add(Expanded(child: title!));
    if (actions != null && actions!.isNotEmpty) {
      widgets.add(
        actions!.length == 1
            ? actions![0]
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              ),
      );
    }

    return Row(children: widgets);
  }

  Widget _createAppBarContent() {
    List<Widget> widgets = [];

    if (Platform.isAndroid || Platform.isIOS) {
      widgets.add(const SizedBox(height: 25));
    }
    if (top != null) widgets.add(top!);

    widgets.add(Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: _createMainElements(),
    ));

    if (bottom != null) widgets.add(bottom!);

    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Templates.card(
        side: BorderSide(color: ViewColors.click),
        color: overColor ?? ViewColors.card.withOpacity(0.6),
        elevation: elevation,
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(color: Colors.transparent),
            ),
            _createAppBarContent(),
          ],
        ),
      ),
    );
  }
}
