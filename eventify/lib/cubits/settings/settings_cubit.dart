import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/cubits/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  // Change language
  void changeLanguage(String language) {
    emit(state.copyWith(language: language));
    // TODO: Implement actual language change logic
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
    // TODO: Implement actual notification settings
  }

  // Change theme
  void changeTheme(String theme) {
    emit(state.copyWith(theme: theme));
    // TODO: Implement actual theme change logic
  }

  // Reset to defaults
  void resetToDefaults() {
    emit(const SettingsState());
  }
}
