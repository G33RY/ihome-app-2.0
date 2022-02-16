import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/api/api.dart';
import 'package:ihome/models/api/token.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:ihome/widgets/search_box.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import '/generated/l10n.dart';

enum SettingWidgetType {
  toggle,
  time,
  number,
  token,
}

class SettingWidget extends StatefulWidget {
  final String title;
  final String suffix;
  final int min;
  final int max;
  dynamic value;
  final SettingWidgetType type;
  final Function(dynamic value) onChange;

  SettingWidget({
    required this.title,
    required this.value,
    required this.type,
    this.min = 0,
    this.max = 9999,
    required this.onChange,
    this.suffix = "",
  });

  @override
  State<StatefulWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  Widget? openWidget;
  List<Token> tokens = [];

  @override
  void initState() {
    if (widget.type == SettingWidgetType.token) {
      Token.fetch().then((value) {
        if (mounted) {
          setState(() {
            tokens = value;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 25,
      ),
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              buildInput(),
            ],
          ),
          openWidget ?? Container(),
        ],
      ),
    );
  }

  Widget buildInput() {
    switch (widget.type) {
      case SettingWidgetType.toggle:
        return CupertinoSwitch(
          value: widget.value as bool,
          onChanged: (v) => widget.onChange.call(v),
        );
      case SettingWidgetType.time:
        List<int> time = (widget.value as List<dynamic>)
            .map((e) => int.parse(e.toString()))
            .toList();

        if (time.length != 2) {
          time = [0, 0];
        }
        return MyButton(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          boxDecoration: BoxDecoration(
            color: MyColors.smokewhite,
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            setState(() {
              if (openWidget == null) {
                openWidget = SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WheelChooser(
                        listWidth: 50,
                        startPosition: time[0],
                        onValueChanged: (s) {
                          int n = int.parse(s.toString());
                          setState(() {
                            time[0] = n;
                            widget.value = time;
                            widget.onChange.call(widget.value);
                          });
                        },
                        datas: Utils.makeRange(0, 23)
                            .map((e) => e.toString().padLeft(2, '0'))
                            .toList(),
                        selectTextStyle: const TextStyle(
                          fontFamily: "SFCompact",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        unSelectTextStyle: const TextStyle(
                          fontFamily: "SFCompact",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: MyColors.gray60,
                        ),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(
                          fontFamily: "SFCompact",
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      WheelChooser(
                        listWidth: 50,
                        startPosition: time[1],
                        onValueChanged: (s) {
                          int n = int.parse(s as String);
                          setState(() {
                            time[1] = n;
                            widget.value = time;
                            widget.onChange.call(widget.value);
                          });
                        },
                        datas: Utils.makeRange(0, 59)
                            .map((e) => e.toString().padLeft(2, "0"))
                            .toList(),
                        selectTextStyle: const TextStyle(
                          fontFamily: "SFCompact",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        unSelectTextStyle: const TextStyle(
                          fontFamily: "SFCompact",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: MyColors.gray60,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                openWidget = null;
              }
            });
          },
          child: Text(
            "${time[0].toString().padLeft(2, '0')}:${time[1].toString().padLeft(2, '0')}",
            style: TextStyle(
              fontFamily: "SFCompact",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: openWidget == null ? Colors.black : MyColors.blue,
            ),
          ),
        );
      case SettingWidgetType.number:
        final int number = widget.value as int;
        return MyButton(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          boxDecoration: BoxDecoration(
            color: MyColors.smokewhite,
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            setState(() {
              if (openWidget == null) {
                openWidget = WheelChooser.integer(
                  horizontal: true,
                  initValue: number,
                  listWidth: 50,
                  onValueChanged: (v) {
                    setState(() {
                      widget.value = v;
                      widget.onChange.call(v);
                    });
                  },
                  maxValue: widget.max,
                  minValue: widget.min,
                  selectTextStyle: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  unSelectTextStyle: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MyColors.gray60,
                  ),
                );
              } else {
                openWidget = null;
              }
            });
          },
          child: Text(
            "${widget.value} ${widget.suffix}",
            style: TextStyle(
              fontFamily: "SFCompact",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: openWidget == null ? Colors.black : MyColors.blue,
            ),
          ),
        );

      case SettingWidgetType.token:
        List<String> list = tokens.map((e) => e.name).toList();
        list.sort();

        return MyButton(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          boxDecoration: BoxDecoration(
            color: MyColors.smokewhite,
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            setState(() {
              if (openWidget == null) {
                openWidget = SearchBox(
                  list: tokens.map((e) => ListItem(e.id, e.name)).toList(),
                  selected: widget.value.toString(),
                  onChange: (v) {
                    setState(() {
                      widget.value = v;
                      widget.onChange.call(widget.value);
                    });
                  },
                  selectTextStyle: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  unSelectTextStyle: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MyColors.gray60,
                  ),
                );
              } else {
                openWidget = null;
              }
            });
          },
          child: Text(
            "${tokens.firstWhereOrNull((e) => e.id == widget.value.toString())?.name}",
            style: TextStyle(
              fontFamily: "SFCompact",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: openWidget == null ? Colors.black : MyColors.blue,
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
