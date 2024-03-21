abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsComplete extends SettingsState {
  const SettingsComplete();
}

class SettingsError extends SettingsState {
  final String error;
  const SettingsError(this.error);
}
