Map<String, dynamic> _values = {};
Map<String, DateTime> _times = {};

const Duration defaultCacheDuration = Duration(seconds: 20);

mixin Cache {
  static Future<T> get<T>({
    required String key,
    required Future<T> Function() func,
    Duration? cacheDuration,
  }) async {
    if (!_values.containsKey(key) || !_times.containsKey(key)) {
      final T value = await func.call();
      if (!_values.containsKey(key)) {
        _values.addAll({
          key: value,
        });
      }
      if (!_times.containsKey(key)) {
        _times.addAll({
          key: DateTime.now(),
        });
      }
      return value;
    }

    if (_times[key]!.isBefore(
      DateTime.now().subtract(cacheDuration ?? defaultCacheDuration),
    )) {
      _times[key] = DateTime.now();
      return func.call();
    } else {
      return _values[key] as T;
    }
  }
}
