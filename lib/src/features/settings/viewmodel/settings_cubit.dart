import 'package:flash_angebote/src/features/settings/viewmodel/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
}
