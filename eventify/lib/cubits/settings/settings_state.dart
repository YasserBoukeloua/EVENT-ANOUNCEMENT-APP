import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String language;
  final bool notificationsEnabled;
  final String theme;

  const SettingsState({
    this.language = 'en',
    this.notificationsEnabled = true,
    this.theme = 'light',
  });

  SettingsState copyWith({
    String? language,
    bool? notificationsEnabled,
    String? theme,
  }) {
    return SettingsState(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [language, notificationsEnabled, theme];
}
