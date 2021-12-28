import 'dart:convert';

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Setting extends HiveObject {
  static late Box<Setting> BOX;
  late dynamic value;

  Setting(this.value);

  Setting.fromJson(String json) {
    Map map = jsonDecode(json) as Map;
    value = map["value"];
  }

  Object toJSON() => {
        "value": this.value,
      };

  @override
  String toString() => jsonEncode(toJSON());

  static dynamic getValueByKey(String key, dynamic defaultValue) {
    return Setting.BOX.get(key, defaultValue: Setting(defaultValue))?.value ??
        defaultValue;
  }

  static Future<void> saveValue(String key, dynamic value) {
    return Setting.BOX.put(key, Setting(value));
  }
}

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final typeId = 1;

  @override
  Setting read(BinaryReader reader) {
    return Setting.fromJson(reader.read().toString());
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer.write(obj.toString());
  }
}
