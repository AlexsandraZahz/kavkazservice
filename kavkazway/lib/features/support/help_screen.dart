import 'package:flutter/material.dart';
import 'package:kavkazway/app/theme/app_colors.dart';
import 'package:kavkazway/features/support/chat_support_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Помощь',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Поиск по вопросам
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск по вопросам',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),

          // Категории
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Категории',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _CategoryChip('🚗', 'Поездки', true),
                SizedBox(width: 8),
                _CategoryChip('💳', 'Оплата', false),
                SizedBox(width: 8),
                _CategoryChip('👤', 'Аккаунт', false),
                SizedBox(width: 8),
                _CategoryChip('🎁', 'Бонусы', false),
                SizedBox(width: 8),
                _CategoryChip('🔒', 'Безопасность', false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Популярные вопросы
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Популярные вопросы',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _FaqItem(
                  question: 'Как заказать такси?',
                  answer: '1. Откройте приложение\n2. Укажите адрес подачи\n3. Выберите тариф\n4. Подтвердите заказ',
                  icon: Icons.taxi_alert_rounded,
                  color: Colors.blue,
                ),
                _FaqItem(
                  question: 'Как отменить поездку?',
                  answer: 'Отменить можно в разделе "Мои поездки". В первые 2 минуты - бесплатно, после - комиссия 50₽',
                  icon: Icons.cancel_rounded,
                  color: Colors.red,
                ),
                _FaqItem(
                  question: 'Какие способы оплаты?',
                  answer: 'Наличные, банковские карты, Apple Pay, Google Pay, бонусы KavkazWay',
                  icon: Icons.payment_rounded,
                  color: Colors.green,
                ),
                _FaqItem(
                  question: 'Как работает женский тариф?',
                  answer: 'Только женщины-водители. Доступен в настройках профиля',
                  icon: Icons.female_rounded,
                  color: Colors.pink,
                ),
                _FaqItem(
                  question: 'Что делать, если забыл вещи?',
                  answer: 'Свяжитесь с поддержкой - мы поможем связаться с водителем',
                  icon: Icons.shopping_bag_rounded,
                  color: Colors.orange,
                ),
                _FaqItem(
                  question: 'Как копить бонусы?',
                  answer: 'За каждую поездку начисляется 5% от стоимости бонусами',
                  icon: Icons.stars_rounded,
                  color: AppColors.primaryYellow,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Не нашли ответ?
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      const SizedBox(height: 4),
                      Text(
                        'Свяжитесь с поддержкой',
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
                      MaterialPageRoute(builder: (_) => const ChatSupportScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Связаться'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;

  const _CategoryChip(this.emoji, this.label, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryYellow : Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? AppColors.primaryYellow : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final IconData icon;
  final Color color;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.icon,
    required this.color,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(widget.icon, color: widget.color, size: 20),
        ),
        title: Text(
          widget.question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
            child: Text(
              widget.answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}