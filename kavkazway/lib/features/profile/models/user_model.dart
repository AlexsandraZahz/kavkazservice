enum Gender { male, female }

class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;
  final Gender gender; // Добавляем гендер
  final UserSettings settings;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
    required this.gender, // Обязательный параметр
    required this.settings,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    Gender? gender,
    UserSettings? settings,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      settings: settings ?? this.settings,
    );
  }

  static UserProfile mock() {
    return UserProfile(
      id: 'USR-001',
      name: 'Александр Петров',
      phone: '+7 (999) 123-45-67',
      email: 'alex@example.com',
      photoUrl: null,
      gender: Gender.male, // Мужской по умолчанию
      settings: const UserSettings(
        darkMode: false,
        notificationsEnabled: true,
        language: 'Русский',
        womenTariffEnabled: false, // Добавляем
      ),
    );
  }

  static UserProfile mockFemale() {
    return UserProfile(
      id: 'USR-002',
      name: 'Екатерина Смирнова',
      phone: '+7 (999) 765-43-21',
      email: 'ekaterina@example.com',
      photoUrl: null,
      gender: Gender.female,
      settings: const UserSettings(
        darkMode: false,
        notificationsEnabled: true,
        language: 'Русский',
        womenTariffEnabled: true,
      ),
    );
  }
}

class UserSettings {
  final bool darkMode;
  final bool notificationsEnabled;
  final String language;
  final bool womenTariffEnabled; // Добавляем поле

  const UserSettings({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.language = 'Русский',
    this.womenTariffEnabled = false, // По умолчанию выключено
  });

  UserSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    String? language,
    bool? womenTariffEnabled,
  }) {
    return UserSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      womenTariffEnabled: womenTariffEnabled ?? this.womenTariffEnabled,
    );
  }
}
