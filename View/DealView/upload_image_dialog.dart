import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:trader_diary/Instruments/validation.dart';
import '../elements.dart';

/// Dialog through which the user can upload an image from a file or from the clipboard
abstract class UploadImagesDialog {
  static Widget _createButton(
    BuildContext context, {
    required String option,
    required IconData icon,
    required String label,
  }) {
    return TextButton(
      onPressed: () => Navigator.pop(context, option),
      style: ButtonStyles.flatButton(padding: const EdgeInsets.all(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 50),
          Text(label, style: TextStyles.text()),
        ],
      ),
    );
  }

  static Widget _createDialog(BuildContext context) {
    return Templates.card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _createButton(
              context,
              option: 'clipboard',
              icon: Icons.paste,
              label: 'Вставить',
            ),
            const SizedBox(width: 10),
            _createButton(
              context,
              option: 'file',
              icon: Icons.file_open,
              label: 'Выбрать файл',
            ),
          ],
        ),
      ),
    );
  }

  static Future<List<Uint8List>?> _getImageFromFile(bool isOneFile) async {
    final files = await FilePicker.platform.pickFiles(
      dialogTitle: 'Выбрите изображени${isOneFile ? 'е' : 'я'}',
      type: FileType.image,
      allowMultiple: !isOneFile,
      lockParentWindow: true,
    );

    if (files == null) return null;

    List<Uint8List> images = [];
    for (var path in files.paths) {
      images.add(await File(path!).readAsBytes());
    }
    return images;
  }

  static Future<List<Uint8List>?> _getImageFromClipboard(
      BuildContext context) async {
    final image = await Pasteboard.image;
    if (image != null) return [image];

    // ignore: use_build_context_synchronously
    Validation.showErrorMessage(context, 'Изображение в буфере не найдено!');
    return null;
  }

  static Future<List<Uint8List>?> show(
    BuildContext context, {
    bool isOneFile = true,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _getImageFromFile(isOneFile);
    }

    final option = await showDialog<String?>(
      context: context,
      builder: (context) => Center(child: _createDialog(context)),
    );
    if (option == null) return null;

    if (option == 'file') {
      return await _getImageFromFile(isOneFile);
    } else {
      // ignore: use_build_context_synchronously
      return await _getImageFromClipboard(context);
    }
  }
}
