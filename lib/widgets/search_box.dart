import 'package:flutter/material.dart';
import '/generated/l10n.dart';

class ListItem {
  String index;
  String title;

  ListItem(this.index, this.title);
}

class SearchBox extends StatefulWidget {
  List<ListItem> list = [];
  String selected = "";
  Function(String index) onChange;
  TextStyle selectTextStyle;
  TextStyle unSelectTextStyle;

  SearchBox({
    required this.list,
    required this.selected,
    required this.selectTextStyle,
    required this.unSelectTextStyle,
    required this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController controller;

  List<ListItem> filtered = [];
  String selected = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      controller = TextEditingController();
      filtered = widget.list;
      selected = widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: (v) {
                setState(() {
                  filtered = widget.list
                      .where((item) =>
                          item.title.toLowerCase().contains(v.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: filtered.map((data) {
                return ListTile(
                  title: Text(data.title,
                      style: data.index == selected
                          ? widget.selectTextStyle
                          : widget.unSelectTextStyle),
                  onTap: () {
                    setState(() {
                      selected = data.index;
                      widget.onChange.call(data.index);
                    });
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
