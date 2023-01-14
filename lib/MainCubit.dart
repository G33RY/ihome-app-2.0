import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihome/models/crypto_token.dart';
import 'package:ihome/models/device.dart';
import 'package:ihome/models/device_group.dart';
import 'package:ihome/models/scene.dart';
import 'package:ihome/models/weather_current.dart';
import 'package:ihome/models/weather_daily.dart';
import 'package:ihome/models/weather_hourly.dart';

class MainState {
  List<Scene> scenes = [];
  List<Device> devices = [];
  List<DeviceGroup> deviceGroups = [];
  List<WeatherHourly> weatherHourly = [];
  List<WeatherDaily> weatherDaily = [];
  WeatherCurrent? weatherCurrent;
  Map<String, dynamic> settings = {};
  List<CryptoToken> cryptoTokens = [];
  Map<String, dynamic> sensors = {};

  MainState({
    this.scenes = const [],
    this.devices = const [],
    this.deviceGroups = const [],
    this.weatherHourly = const [],
    this.weatherDaily = const [],
    this.weatherCurrent,
    this.settings = const {},
    this.cryptoTokens = const [],
    this.sensors = const {},
  });

  dynamic getSetting(String key, [dynamic defaultValue]) {
    if (settings.containsKey(key)) {
      return settings[key] ?? defaultValue;
    } else {
      return defaultValue;
    }
  }

  MainState copyWith({
    List<Scene>? scenes,
    List<Device>? devices,
    List<DeviceGroup>? deviceGroups,
    List<WeatherHourly>? weatherHourly,
    List<WeatherDaily>? weatherDaily,
    WeatherCurrent? weatherCurrent,
    Map<String, dynamic>? settings,
    List<CryptoToken>? cryptoTokens,
    Map<String, dynamic>? sensors,
  }) {
    return MainState(
      scenes: scenes ?? this.scenes,
      devices: devices ?? this.devices,
      deviceGroups: deviceGroups ?? this.deviceGroups,
      weatherHourly: weatherHourly ?? this.weatherHourly,
      weatherDaily: weatherDaily ?? this.weatherDaily,
      weatherCurrent: weatherCurrent ?? this.weatherCurrent,
      settings: settings ?? this.settings,
      cryptoTokens: cryptoTokens ?? this.cryptoTokens,
      sensors: sensors ?? this.sensors,
    );
  }
}

class MainCubit extends Cubit<MainState> {
  MainState _mainState = MainState();
  MainCubit({MainState? mainState}) : super(mainState ?? MainState()) {
    _mainState = mainState ?? MainState();
  }

  void setDevices(List<Device> devices) {
    emit(state.copyWith(devices: devices));
  }

  void setDeviceGroups(List<DeviceGroup> deviceGroups) {
    emit(state.copyWith(deviceGroups: deviceGroups));
  }

  void setWeatherHourly(List<WeatherHourly> weatherHourly) {
    emit(state.copyWith(weatherHourly: weatherHourly));
  }

  void setWeatherDaily(List<WeatherDaily> weatherDaily) {
    emit(state.copyWith(weatherDaily: weatherDaily));
  }

  void setWeatherCurrent(WeatherCurrent weatherCurrent) {
    emit(state.copyWith(weatherCurrent: weatherCurrent));
  }

  void setSettings(Map<String, dynamic> settings) {
    emit(state.copyWith(settings: settings));
  }

  void setCryptoTokens(List<CryptoToken> cryptoTokens) {
    emit(state.copyWith(cryptoTokens: cryptoTokens));
  }

  void setSensors(Map<String, dynamic> sensors) {
    emit(state.copyWith(sensors: sensors));
  }

  void setScenes(List<Scene> scenes) {
    emit(state.copyWith(scenes: scenes));
  }

  dynamic getSetting(String key) {
    return state.settings[key];
  }
}
