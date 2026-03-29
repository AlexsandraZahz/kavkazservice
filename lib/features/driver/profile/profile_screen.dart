import 'package:flutter/material.dart';
import 'package:kavkaz_service/app/theme/app_colors.dart';
import 'package:kavkaz_service/features/support/help_screen.dart';
import 'package:kavkaz_service/features/support/chat_support_screen.dart';
import 'package:kavkaz_service/features/driver/models/document_model.dart'; // ДОБАВЛЕН ИМПОРТ

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Настройки уведомлений
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

// Статусы документов (теперь используется импортированный DocumentStatus)
  final Map<String, DocumentStatus> _documents = {
    'Паспорт': DocumentStatus(
      status: DocumentStatusType.verified,
      date: 'Проверен 15.01.2024',
      icon: Icons
          .person_outline_rounded, // ИСПРАВЛЕНО: passport_rounded не существует
    ),
    'Водительское удостоверение': DocumentStatus(
      status: DocumentStatusType.verified,
      date: 'Действительно до 10.05.2028',
      icon: Icons.drive_eta_rounded,
    ),
    'СТС': DocumentStatus(
      status: DocumentStatusType.verified,
      date: 'Проверен 20.02.2024',
      icon: Icons.description_rounded,
    ),
    'Страховка ОСАГО': DocumentStatus(
      status: DocumentStatusType.expiring,
      date: 'Истекает через 14 дней',
      icon: Icons.security_rounded,
    ),
    'Медицинская справка': DocumentStatus(
      status: DocumentStatusType.pending,
      date: 'Ожидает проверки',
      icon: Icons.medical_information_rounded,
    ),
  };

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - скоро появится'),
        backgroundColor: AppColors.primaryYellow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
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
                  behavior: SnackBarBehavior.floating,
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

  void _showDocumentDetails(String docName, DocumentStatus doc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    doc.icon,
                    color: AppColors.primaryYellow,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    docName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDocumentInfoRow('Статус', _getStatusText(doc.status)),
            _buildDocumentInfoRow('Информация', doc.date),
            if (doc.status == DocumentStatusType.expiring)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_rounded, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Необходимо обновить документ в ближайшее время',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            if (doc.status == DocumentStatusType.pending)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.hourglass_empty_rounded, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Документ на проверке. Обычно это занимает 1-2 рабочих дня',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Закрыть'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(DocumentStatusType status) {
    switch (status) {
      case DocumentStatusType.verified:
        return '✅ Подтвержден';
      case DocumentStatusType.pending:
        return '⏳ На проверке';
      case DocumentStatusType.expiring:
        return '⚠️ Истекает';
      case DocumentStatusType.expired:
        return '❌ Просрочен';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showComingSoon('Настройки'),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Шапка профиля
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.primaryYellow.withValues(alpha: 0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ахмед Магомедов',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '4.95',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'ПРОВЕРЕН',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Статистика
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                _buildStatItem('Поездки', '547', Icons.taxi_alert_rounded),
                _buildStatItem('Рейтинг', '4.95', Icons.star_rounded),
                _buildStatItem('Стаж', '2 года', Icons.access_time_rounded),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Раздел: Мой автомобиль
          _buildMenuItem(
            icon: Icons.car_repair_rounded,
            title: 'Мой автомобиль',
            subtitle: 'Hyundai Solaris • X 777 XX',
            onTap: () => _showComingSoon('Автомобиль'),
          ),

          // Раздел: Документы
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // Заголовок раздела
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.folder_rounded,
                          color: AppColors.primaryYellow),
                      SizedBox(width: 12),
                      Text(
                        'Документы',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '4 из 5',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Список документов
                ..._documents.entries.map((entry) {
                  return _buildDocumentItem(
                    docName: entry.key,
                    status: entry.value.status,
                    date: entry.value.date,
                    onTap: () => _showDocumentDetails(entry.key, entry.value),
                  );
                }).toList(),

                // Кнопка загрузки нового документа
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextButton(
                    onPressed: () => _showComingSoon('Загрузка документа'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryYellow,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Загрузить новый документ'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Раздел: Способы вывода
          _buildMenuItem(
            icon: Icons.credit_card_rounded,
            title: 'Способы вывода',
            subtitle: 'Сбербанк •• 4242',
            onTap: () => _showComingSoon('Способы вывода'),
          ),

          // Раздел: Уведомления (с бегунками)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // Заголовок раздела
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_rounded,
                          color: AppColors.primaryYellow),
                      SizedBox(width: 12),
                      Text(
                        'Уведомления',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Бегунок 1: Уведомления вкл/выкл
                _buildSwitchTile(
                  icon: Icons.notifications_active_rounded,
                  title: 'Получать уведомления',
                  value: _notificationsEnabled,
                  onChanged: (value) =>
                      setState(() => _notificationsEnabled = value),
                ),

                // Бегунок 2: Звук (активен только если уведомления вкл)
                _buildSwitchTile(
                  icon: Icons.volume_up_rounded,
                  title: 'Звук',
                  value: _soundEnabled,
                  enabled: _notificationsEnabled,
                  onChanged: (value) => setState(() => _soundEnabled = value),
                ),

                // Бегунок 3: Вибрация (активен только если уведомления вкл)
                _buildSwitchTile(
                  icon: Icons.vibration_rounded,
                  title: 'Вибрация',
                  value: _vibrationEnabled,
                  enabled: _notificationsEnabled,
                  onChanged: (value) =>
                      setState(() => _vibrationEnabled = value),
                ),
              ],
            ),
          ),

          // Раздел: Безопасность
          _buildMenuItem(
            icon: Icons.security_rounded,
            title: 'Безопасность',
            subtitle: 'Двухфакторная аутентификация',
            onTap: () => _showComingSoon('Безопасность'),
          ),

          const Divider(height: 32),

          // Раздел: Поддержка
          _buildMenuItem(
            icon: Icons.help_rounded,
            title: 'Помощь',
            subtitle: 'Часто задаваемые вопросы',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.support_agent_rounded,
            title: 'Чат с поддержкой',
            subtitle: 'Онлайн 24/7',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatSupportScreen()),
              );
            },
          ),

          const Divider(height: 32),

          // Кнопка выхода
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: _showLogoutDialog,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'ВЫЙТИ ИЗ АККАУНТА',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryYellow, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryYellow.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primaryYellow),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.primaryYellow : Colors.grey[400],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: enabled ? Colors.black : Colors.grey[500],
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: AppColors.primaryYellow,
            activeTrackColor: AppColors.primaryYellow.withValues(alpha: 0.5),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String docName,
    required DocumentStatusType status,
    required String date,
    required VoidCallback onTap,
  }) {
    // Инициализируем переменные с значениями по умолчанию
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case DocumentStatusType.verified:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case DocumentStatusType.pending:
        statusColor = Colors.blue;
        statusIcon = Icons.hourglass_empty_rounded;
        break;
      case DocumentStatusType.expiring:
        statusColor = Colors.orange;
        statusIcon = Icons.warning_rounded;
        break;
      case DocumentStatusType.expired:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_rounded,
                color: AppColors.primaryYellow,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    docName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    _getStatusText(status),
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
