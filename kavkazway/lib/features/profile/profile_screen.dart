import 'package:flutter/material.dart';
import 'package:kavkazway/app/theme/app_colors.dart';
import 'package:kavkazway/features/profile/models/user_model.dart';
import 'package:kavkazway/features/support/help_screen.dart';
import 'package:kavkazway/features/support/chat_support_screen.dart';
// Удален импорт contact_screen.dart

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onProfileChanged;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onProfileChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = _userProfile.gender == Gender.female;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Шапка с аватаром
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isFemale
                              ? [Colors.pink.shade300, Colors.purple.shade300]
                              : [
                                  Colors.blue.shade300,
                                  Colors.lightBlue.shade300
                                ],
                        ),
                        border: Border.all(
                          color: isFemale
                              ? Colors.pink.shade200
                              : Colors.blue.shade200,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isFemale ? Colors.pink : Colors.blue)
                                .withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFemale ? Icons.face_3 : Icons.face_2,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryYellow,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _userProfile.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isFemale ? Colors.pink.shade50 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isFemale ? '👩 Женщина' : '👨 Мужчина',
                    style: TextStyle(
                      fontSize: 13,
                      color: isFemale
                          ? Colors.pink.shade700
                          : Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userProfile.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (_userProfile.email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _userProfile.email!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.5),

          // Личные данные
          _buildSection(
            title: 'Личные данные',
            icon: Icons.person_outline,
            children: [
              _buildInfoTile('Имя', _userProfile.name),
              _buildInfoTile('Телефон', _userProfile.phone),
              if (_userProfile.email != null)
                _buildInfoTile('Email', _userProfile.email!),
            ],
          ),

          // Настройки
          _buildSection(
            title: 'Настройки',
            icon: Icons.settings_outlined,
            children: [
              _buildSwitchTile(
                'Темная тема',
                _userProfile.settings.darkMode,
                (value) {
                  setState(() {
                    _userProfile = _userProfile.copyWith(
                      settings: _userProfile.settings.copyWith(darkMode: value),
                    );
                  });
                  widget.onProfileChanged(_userProfile);
                },
              ),
              _buildSwitchTile(
                'Уведомления',
                _userProfile.settings.notificationsEnabled,
                (value) {
                  setState(() {
                    _userProfile = _userProfile.copyWith(
                      settings: _userProfile.settings.copyWith(
                        notificationsEnabled: value,
                      ),
                    );
                  });
                  widget.onProfileChanged(_userProfile);
                },
              ),
              _buildMenuTile(
                'Язык',
                _userProfile.settings.language,
                Icons.language_outlined,
                () => _showLanguageDialog(),
              ),
            ],
          ),

          // Тарифы (для женщин)
          if (isFemale)
            _buildSection(
              title: 'Тарифы',
              icon: Icons.local_taxi_outlined,
              children: [
                _buildSwitchTile(
                  'Женский тариф',
                  _userProfile.settings.womenTariffEnabled,
                  (value) {
                    setState(() {
                      _userProfile = _userProfile.copyWith(
                        settings: _userProfile.settings.copyWith(
                          womenTariffEnabled: value,
                        ),
                      );
                    });
                    widget.onProfileChanged(_userProfile);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? '✅ Женский тариф включен'
                              : '❌ Женский тариф выключен',
                        ),
                        backgroundColor: value ? Colors.pink : Colors.grey,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),

          // Поддержка (только Помощь и Чат)
          _buildSection(
            title: 'Поддержка',
            icon: Icons.support_outlined,
            children: [
              _buildMenuTile(
                'Помощь',
                'Часто задаваемые вопросы',
                Icons.help_outline,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpScreen(),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                'Чат с поддержкой',
                'Написать в чат',
                Icons.support_agent_rounded,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatSupportScreen(),
                    ),
                  );
                },
              ),
              // Удалены пункты "Связаться с нами" и "Телефон поддержки"
            ],
          ),

          // О приложении
          _buildSection(
            title: 'О приложении',
            icon: Icons.info_outline,
            children: [
              _buildInfoTile('Версия', '1.0.0'),
              _buildMenuTile(
                'Правовая информация',
                'Политика конфиденциальности',
                Icons.description_outlined,
                () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Кнопка выхода
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Выйти из аккаунта',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: label == 'Женский тариф'
                ? Colors.pink
                : AppColors.primaryYellow,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    String label,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.grey[700]),
      ),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Выберите язык'),
        children: [
          _buildLanguageOption('Русский', true),
          _buildLanguageOption('English', false),
          _buildLanguageOption('Deutsch', false),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _userProfile = _userProfile.copyWith(
            settings: _userProfile.settings.copyWith(language: language),
          );
        });
        widget.onProfileChanged(_userProfile);
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(language),
          if (isSelected) Icon(Icons.check, color: AppColors.primaryYellow),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Вы вышли из аккаунта'),
                  backgroundColor: AppColors.primaryYellow,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
