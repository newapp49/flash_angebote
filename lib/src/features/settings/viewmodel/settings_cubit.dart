import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/src/features/settings/viewmodel/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/init/manager/locale_manager.dart';
import '../../../shared/utils/enums/prefererences_keys.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsInitial());

  List<int> distanceDropdownList = [5, 10, 100, 1000];
  List<String> locationDropdownList = [
    'Istanbul',
    'Berlin',
    'Paris',
    'Konumum'
  ];
  List<String> languageDropdownList = ['en-US', 'tr-TR', 'de-DE'];

  Future<void> init() async {
    emit(const SettingsLoading());

    emit(const SettingsComplete());
  }

  Future<void> changeMaxDistance(
    int? value,
    VoidCallback callback,
  ) async {
    switch (value) {
      case 5:
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.MAX_DISTANCE, value.toString());
        callback();

        break;
      case 10:
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.MAX_DISTANCE, value.toString());
        callback();
        break;
      case 100:
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.MAX_DISTANCE, value.toString());
        callback();
        break;
      case 1000:
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.MAX_DISTANCE, value.toString());
        callback();
        break;
      default:
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.MAX_DISTANCE, 1000.toString());
        callback();
    }
  }

  Future<void> changeLanguage(
    BuildContext context,
    String? value,
  ) async {
    switch (value) {
      case 'tr-TR':
        await context.setLocale(const Locale('tr', 'TR'));
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.LANGUAGE, 'T');

        break;
      case 'en-US':
        await context.setLocale(const Locale('en', 'US'));
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.LANGUAGE, 'E');

        break;
      case 'de-DE':
        await context.setLocale(const Locale('de', 'DE'));
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.LANGUAGE, 'D');

        break;

      default:
    }
  }

  Future<void> changeLocation(
      BuildContext context, String? value, VoidCallback callback) async {
    switch (value) {
      case 'Istanbul':
        await LocaleManager.instance.setStringValue(
            PreferencesKeys.CONSTANT_LOCATION, value!.toLowerCase());
        callback();
        break;
      case 'Berlin':
        await LocaleManager.instance.setStringValue(
            PreferencesKeys.CONSTANT_LOCATION, value!.toLowerCase());
        callback();

        break;
      case 'Paris':
        await LocaleManager.instance.setStringValue(
            PreferencesKeys.CONSTANT_LOCATION, value!.toLowerCase());
        callback();

        break;
      case 'Konumum':
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.CONSTANT_LOCATION, '');
        callback();

        break;

      default:
        await LocaleManager.instance
            .setStringValue(PreferencesKeys.CONSTANT_LOCATION, '');
        callback();
    }
  }
}
