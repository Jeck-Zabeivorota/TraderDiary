import 'package:flutter/material.dart';
import 'dart:io';
import '../colors.dart';
import '../elements.dart';
import '../Widgets/blur_appbar.dart';
import 'tags_list_viewmodel.dart';

/// Screen that displays a list of tags
class TagsListView extends StatefulWidget {
  const TagsListView({super.key});

  @override
  State<TagsListView> createState() => _TagsListViewState();
}

class _TagsListViewState extends State<TagsListView> {
  late final TagsListViewModel data;

  @override
  void initState() {
    super.initState();
    data = TagsListViewModel(onUpdate: setState);
  }

  Widget _createTagItem(TagItemData itemData) {
    return Templates.dismissible(
      id: itemData.id,
      onDismiss: (_) async => await data.deleteTag(context, tagId: itemData.id),
      child: TextButton(
        onPressed: () => data.pushToTagView(context, tagId: itemData.id),
        style: ButtonStyles.flatButton(padding: const EdgeInsets.all(20)),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(itemData.name, style: TextStyles.text()),
        ),
      ),
    );
  }

  Widget _createListView(List<TagItemData> list) {
    return list.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.only(
              top: Platform.isAndroid || Platform.isIOS ? 125 : 100,
              left: 20,
              right: 20,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) => _createTagItem(list[i]),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: Text(
                'Теги отсутствуют',
                style: TextStyles.text(color: ViewColors.secondText),
              ),
            ),
          );
  }

  Widget _createAppBar() {
    return BlurAppBar(
      padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
      first: Templates.iconButton(
        onPressed: () => data.onBack(context),
        color: ViewColors.mainText,
        iconSize: 20,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        icon: Icons.arrow_back,
      ),
      title: Center(
        child: Text('Список тегов', style: TextStyles.capture()),
      ),
      actions: [
        Templates.iconButton(
          onPressed: () => data.pushToTagView(context),
          color: ViewColors.mainText,
          iconSize: 20,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          icon: Icons.add,
        ),
      ],
      bottom: TabBar(
        labelPadding: const EdgeInsets.symmetric(vertical: 7),
        indicatorColor: ViewColors.profit,
        overlayColor: MaterialStateProperty.all(ViewColors.profit.withAlpha(5)),
        tabs: [
          Text('Прибыльные', style: TextStyles.text()),
          Text('Общие', style: TextStyles.text()),
          Text('Убыточные', style: TextStyles.text()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ViewColors.card,
      body: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Stack(
          children: [
            TabBarView(
              children: [
                _createListView(data.profitTags),
                _createListView(data.generalTags),
                _createListView(data.lossTags),
              ],
            ),
            _createAppBar(),
          ],
        ),
      ),
    );
  }
}
