import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:trader_diary/extension_methods.dart';
import '../../global_data.dart';
import '../colors.dart';
import '../elements.dart';
import '../Widgets/checkbox.dart';
import '../Widgets/row_panel.dart';
import 'upload_image_dialog.dart';
import 'package:uuid/uuid.dart';

class ImageSliderController {
  final List<bool> _selectedList = [];
  final List<String> _imagesNames = [];
  final List<Uint8List> _images = [];
  final List<String> _deletedNames = [];

  List<bool> get selectedList => _selectedList;
  List<Uint8List> get images => _images;
  List<String> get imagesNames => _imagesNames;

  void addImages(List<Uint8List> images) {
    const uuid = Uuid();
    _imagesNames.addAll(List.generate(images.length, (i) => uuid.v1()));
    _images.addAll(images);
    _selectedList.addAll(List.filled(images.length, false));
  }

  void putImage(Uint8List image, int index) {
    _deletedNames.add(_imagesNames[index]);
    _imagesNames[index] = const Uuid().v1();
    _images[index] = image;
    _selectedList[index] = false;
  }

  void removeAllSelectedImages() {
    int i = 0;
    while (i < _selectedList.length) {
      if (_selectedList[i]) {
        _deletedNames.add(_imagesNames[i]);
        _imagesNames.removeAt(i);
        _images.removeAt(i);
        _selectedList.removeAt(i);
      } else {
        i++;
      }
    }
  }

  void loadImages(List<String> imagesNames) {
    _imagesNames.addAll(imagesNames);
    _selectedList.addAll(List.filled(imagesNames.length, false));

    for (String name in imagesNames) {
      final file = File('${GlobalData.imagesPath}$name.png');
      if (file.existsSync()) _images.add(file.readAsBytesSync());
    }
  }

  Future<void> saveChanges() async {
    for (int i = 0; i < images.length; i++) {
      final file = File('${GlobalData.imagesPath}${imagesNames[i]}.png');
      if (!(await file.exists())) await file.writeAsBytes(images[i]);
    }

    for (String name in _deletedNames) {
      final file = File('${GlobalData.imagesPath}$name.png');
      if (await file.exists()) await file.delete();
    }
  }

  ImageSliderController({List<String>? imagesNames}) {
    if (imagesNames != null) loadImages(imagesNames);
  }
}

/// Widget that displays an image slider taken from passed object `ImageSliderController`
class ImageSlider extends StatefulWidget {
  final ImageSliderController controller;
  final Axis axis;

  const ImageSlider({
    super.key,
    required this.controller,
    required this.axis,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  Future<void> _showImage(Image image) async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                image,
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyles.elevatedButton(
                    backgroundColor: Colors.black26,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          );
        });
  }

  Widget _createImage(int index) {
    final image = Image.memory(widget.controller.images[index]);
    final selectedList = widget.controller.selectedList;

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        InkWell(onTap: () => _showImage(image), child: image),
        Padding(
          padding: const EdgeInsets.all(5),
          child: CheckBox(
            onChanged: (value) => setState(() => selectedList[index] = value),
            isCheck: selectedList[index],
          ),
        ),
      ],
    );
  }

  Future<void> _onAddImage() async {
    final images = await UploadImagesDialog.show(context, isOneFile: false);
    if (images == null) return;

    widget.controller.addImages(images);

    setState(() {});
  }

  Future<void> _onEditImage() async {
    final images = await UploadImagesDialog.show(context);
    if (images == null) return;

    int index = widget.controller.selectedList.indexOf(true);
    widget.controller.putImage(images[0], index);

    setState(() {});
  }

  Future<void> _onSaveImage() async {
    String? path = Platform.isAndroid || Platform.isIOS
        ? await FlutterFileDialog.saveFile(params: SaveFileDialogParams())
        : await FilePicker.platform.saveFile(
            dialogTitle: 'Сохранение изображения',
            type: FileType.image,
            lockParentWindow: true,
          );
    if (path == null) return;

    int index = widget.controller.selectedList.indexOf(true);
    await File(path).writeAsBytes(widget.controller.images[index]);
    setState(() => widget.controller.selectedList[index] = false);
  }

  Widget _createRowPanel() {
    final selectedList = widget.controller.selectedList;

    List<Widget> actions = [];
    int selectedCount = selectedList.count((value) => value);

    if (selectedCount > 0) {
      actions.add(Templates.iconButton(
        onPressed: () =>
            setState(() => widget.controller.removeAllSelectedImages()),
        icon: Icons.delete,
      ));

      if (selectedCount == 1) {
        actions.addAll([
          Templates.iconButton(
            onPressed: _onSaveImage,
            icon: Icons.download,
          ),
          Templates.iconButton(
            onPressed: _onEditImage,
            icon: Icons.edit,
          ),
        ]);
      }
    }
    actions.add(Templates.iconButton(
      onPressed: _onAddImage,
      icon: Icons.add,
    ));

    return RowPanel(
      label: Text('Изображения', style: TextStyles.second()),
      actions: actions,
    );
  }

  Widget _verticalScreen() {
    List<Widget> rows = [_createRowPanel(), const SizedBox(height: 5)];
    final imagesLength = widget.controller.images.length;

    imagesLength > 0
        ? rows.addAll(
            List.generate(
              imagesLength,
              (i) => _createImage(i),
            ).insertSepars(const SizedBox(height: 5)),
          )
        : rows.addAll([
            const SizedBox(height: 10),
            Text(
              'Изображения отсутствуют',
              style: TextStyles.text(color: ViewColors.secondText),
            )
          ]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget _horizontalScreen() {
    final scrollController = ScrollController();
    final imagesLength = widget.controller.images.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _createRowPanel(),
        const SizedBox(height: 5),
        SizedBox(
          height: 120,
          child: imagesLength > 0
              ? Scrollbar(
                  controller: scrollController,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    itemCount: imagesLength,
                    itemBuilder: (context, i) => _createImage(i),
                    separatorBuilder: (context, i) => const SizedBox(width: 5),
                  ),
                )
              : Center(
                  child: Text(
                    'Изображения отсутствуют',
                    style: TextStyles.text(color: ViewColors.secondText),
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.axis == Axis.vertical
        ? _verticalScreen()
        : _horizontalScreen();
  }
}
