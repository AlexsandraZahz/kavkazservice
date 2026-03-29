import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kavkaz_service/app/theme/app_colors.dart';
import 'package:kavkaz_service/features/driver/models/filter_model.dart';
import 'package:kavkaz_service/features/driver/widgets/filter_bottom_sheet.dart';

class OrdersScreen extends StatefulWidget {
  final bool isOnline;
  const OrdersScreen({super.key, required this.isOnline});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isCardVisible = true;
  bool _isMap3D = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Фильтр
  FilterModel _currentFilter = FilterModel();

  // Заказы
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-001',
      'from': 'ул. Ленина, 15',
      'to': 'ТЦ Грозный-Молл',
      'price': 350,
      'distance': '3.2 км',
      'time': '5 мин',
      'client': 'Анна',
      'rating': 4.9,
      'tariff': 'Эконом',
      'payment': 'Карта',
      'lat': 43.317,
      'lng': 45.693,
    },
    {
      'id': 'ORD-002',
      'from': 'ЖК Грозный-Сити',
      'to': 'Аэропорт Грозный',
      'price': 850,
      'distance': '8.5 км',
      'time': '12 мин',
      'client': 'Максим',
      'rating': 5.0,
      'tariff': 'Бизнес',
      'payment': 'Наличные',
      'lat': 43.388,
      'lng': 45.698,
    },
    {
      'id': 'ORD-003',
      'from': 'пр. Кадырова, 12',
      'to': 'Ресторан "Лама"',
      'price': 220,
      'distance': '1.8 км',
      'time': '3 мин',
      'client': 'Елена',
      'rating': 4.8,
      'tariff': 'Эконом',
      'payment': 'Карта',
      'lat': 43.305,
      'lng': 45.688,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilter: _currentFilter,
        onApply: _applyFilter,
      ),
    );
  }

  void _applyFilter(FilterModel filter) {
    setState(() {
      _currentFilter = filter;
      print(
          'Фильтр применен: tariff=${filter.tariff}, payment=${filter.paymentMethod}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Фильтр применен'),
        backgroundColor: AppColors.primaryYellow,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _centerMap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Карта центрирована'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _toggleMapStyle() {
    setState(() {
      _isMap3D = !_isMap3D;
    });
  }

  void _acceptOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Заказ принят!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectOrder() {
    setState(() {
      if (_currentIndex < _orders.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Заказ отклонен'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOnline) {
      return _buildOfflineScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // КАРТА
          _buildStyledMap(),

          // Верхняя панель
          _buildTopPanel(),

          // Кнопки управления
          Positioned(
            bottom: _isCardVisible ? 280 : 20,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _centerMap,
                  backgroundColor: Colors.white,
                  mini: true,
                  child: const Icon(Icons.my_location,
                      color: Colors.black, size: 20),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: _toggleMapStyle,
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(
                    _isMap3D ? Icons.layers_clear : Icons.layers,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Карточка заказа
          if (_isCardVisible && _orders.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: _buildOrderCard(_orders[_currentIndex]),
            ),

          // Кнопка скрытия карточки
          if (_orders.isNotEmpty)
            Positioned(
              bottom: _isCardVisible ? 280 : 20,
              right: 80,
              child: GestureDetector(
                onTap: () => setState(() => _isCardVisible = !_isCardVisible),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 5),
                    ],
                  ),
                  child: Icon(
                    _isCardVisible
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStyledMap() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _isMap3D
              ? [
                  const Color(0xFF0A2F44),
                  const Color(0xFF1B4A6E),
                  const Color(0xFF2C6E8F),
                ]
              : [
                  const Color(0xFF1A472A),
                  const Color(0xFF2A5A3A),
                  const Color(0xFF3A6E4A),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Анимированная сетка
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: AnimatedMapGridPainter(
                  animation: _pulseAnimation.value,
                  is3D: _isMap3D,
                ),
              );
            },
          ),

          // Декоративные точки
          ...List.generate(20, (index) {
            return Positioned(
              left: (index * 50) % MediaQuery.of(context).size.width,
              top: (index * 40) % MediaQuery.of(context).size.height,
              child: Container(
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          // Метка "Вы здесь"
          Positioned(
            left: 80,
            top: 180,
            child: _buildLocationMarker('Вы здесь', Colors.green),
          ),

          // Метка А
          Positioned(
            left: 100,
            top: 200,
            child: _buildAnimatedMarker('A', Colors.green),
          ),

          // Метка Б
          Positioned(
            left: 250,
            top: 350,
            child: _buildAnimatedMarker('B', Colors.red),
          ),

          // Анимированная линия маршрута
          Positioned(
            left: 120,
            top: 220,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 150,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green,
                        AppColors.primaryYellow,
                        Colors.red,
                      ],
                      stops: [
                        0.0,
                        _pulseAnimation.value,
                        1.0,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),

          // Здания
          ...List.generate(8, (index) {
            return Positioned(
              left: 50 + (index * 30),
              top: 400 + (index * 20),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.business, size: 12, color: Colors.white54),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLocationMarker(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMarker(String label, Color color) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40 + (20 * _pulseAnimation.value),
              height: 40 + (20 * _pulseAnimation.value),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopPanel() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Онлайн',
              style: TextStyle(
                fontSize: 13,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _showFilter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, size: 14),
                    const SizedBox(width: 4),
                    Text('Фильтр',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.power_off_rounded,
                  size: 60, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Вы офлайн',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Включите онлайн, чтобы видеть карту и заказы',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхняя строка
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order['tariff'],
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Text(
                '${order['price']} ₽',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Адреса
          Row(
            children: [
              Column(
                children: [
                  Container(width: 8, height: 8, color: Colors.green),
                  Container(width: 2, height: 40, color: Colors.grey[300]),
                  Container(width: 8, height: 8, color: Colors.red),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['from'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order['to'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Детали
          Row(
            children: [
              _buildDetail(Icons.place, order['distance']),
              const SizedBox(width: 16),
              _buildDetail(Icons.access_time, order['time']),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text('${order['rating']}'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Клиент
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[200],
                child: Text(order['client'][0]),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order['client'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      order['payment'] == 'Наличные'
                          ? Icons.money
                          : Icons.credit_card,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(order['payment'],
                        style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Кнопки
          Row(
            children: [
              if (_orders.length > 1)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _currentIndex > 0
                            ? () => setState(() => _currentIndex--)
                            : null,
                        icon: const Icon(Icons.chevron_left, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text('${_currentIndex + 1}/${_orders.length}'),
                      IconButton(
                        onPressed: _currentIndex < _orders.length - 1
                            ? () => setState(() => _currentIndex++)
                            : null,
                        icon: const Icon(Icons.chevron_right, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Expanded(
                child: ElevatedButton(
                  onPressed: _acceptOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Принять'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _rejectOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Отказ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Анимированная сетка карты
class AnimatedMapGridPainter extends CustomPainter {
  final double animation;
  final bool is3D;

  AnimatedMapGridPainter({required this.animation, required this.is3D});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1 + (animation * 0.1))
      ..strokeWidth = 0.5 + (animation * 0.5);

    const step = 50.0;

    // Горизонтальные линии
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Вертикальные линии
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Диагональные линии для 3D эффекта
    if (is3D) {
      final diagonalPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05 + (animation * 0.05))
        ..strokeWidth = 0.5;

      for (double i = -size.height; i < size.width + size.height; i += 80) {
        canvas.drawLine(
          Offset(i, 0),
          Offset(i + size.height, size.height),
          diagonalPaint,
        );
      }
    }

    // Радиальные линии (эффект компаса)
    final radialPaint = Paint()
      ..color = AppColors.primaryYellow.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final angle = i * (pi * 2 / 8);
      final endX = size.width / 2 + (size.width / 3) * cos(angle);
      final endY = size.height / 2 + (size.height / 3) * sin(angle);
      canvas.drawLine(
        Offset(size.width / 2, size.height / 2),
        Offset(endX, endY),
        radialPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedMapGridPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.is3D != is3D;
  }
}
