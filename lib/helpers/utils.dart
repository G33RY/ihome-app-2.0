class DeviceInfo {
  String name;
  String id;
  DeviceInfo({required this.name, required this.id});
}

mixin Utils {
  static late bool canVibrate;
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension GetOnIndexExtension<E> on List<E> {
  E? get(int index) {
    if (index < 0 || index >= this.length) return null;
    return this[index];
  }
}
