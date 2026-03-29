import 'package:flutter/material.dart';
import 'package:kavkaz_service/app/theme/app_colors.dart';
import 'package:kavkaz_service/features/support/chat_support_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Помощь'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Часто задаваемые вопросы',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => _buildFaqItem(index)),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Не нашли ответ?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Напишите в чат поддержки',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ChatSupportScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                  ),
                  child: const Text('Чат'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(int index) {
    final questions = [
      'Как получать больше заказов?',
      'Когда приходят выплаты?',
      'Как связаться с поддержкой?',
      'Что делать в случае ДТП?',
      'Как изменить данные автомобиля?',
    ];

    final answers = [
      'Будьте онлайн в часы пик и поддерживайте высокий рейтинг',
      'Выплаты приходят каждый понедельник на привязанную карту',
      'Чат поддержки доступен 24/7 в разделе Профиль → Поддержка',
      'Сообщите в поддержку и следуйте инструкциям оператора',
      'Данные можно изменить в разделе Профиль → Мой автомобиль',
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(questions[index]),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answers[index]),
          ),
        ],
      ),
    );
  }
}
