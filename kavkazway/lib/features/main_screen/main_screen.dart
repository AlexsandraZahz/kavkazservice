import 'package:flutter/material.dart';
import 'package:kavkazway/app/theme/app_colors.dart';
import 'package:kavkazway/features/history/history_screen.dart';
import 'package:kavkazway/features/profile/profile_screen.dart';
import 'package:kavkazway/features/profile/models/user_model.dart';
import 'package:kavkazway/features/delivery/delivery_screen.dart';
import 'package:kavkazway/features/payment/payment_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late UserProfile _userProfile;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _userProfile = UserProfile.mock();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _screens = [
      const MainMapScreen(),
      const HistoryScreen(),
      const PaymentScreen(),
      ProfileScreen(
        userProfile: _userProfile,
        onProfileChanged: (updatedProfile) {
          setState(() {
            _userProfile = updatedProfile;
          });
        },
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          items: [
            _buildNavItem(
              index: 0,
              activeIcon: Icons.map_rounded,
              inactiveIcon: Icons.map_outlined,
              label: 'Карта',
            ),
            _buildNavItem(
              index: 1,
              activeIcon: Icons.history_rounded,
              inactiveIcon: Icons.history_outlined,
              label: 'История',
            ),
            _buildNavItem(
              index: 2,
              activeIcon: Icons.payment_rounded,
              inactiveIcon: Icons.payment_outlined,
              label: 'Оплата',
            ),
            _buildNavItem(
              index: 3,
              activeIcon: Icons.person_rounded,
              inactiveIcon: Icons.person_outline_rounded,
              label: 'Профиль',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryYellow,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(_selectedIndex == index ? 8 : 6),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? AppColors.primaryYellow.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _selectedIndex == index ? activeIcon : inactiveIcon,
          size: 24,
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _animationController.reset();
      _animationController.forward();
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

// ЭКРАН КАРТЫ С ТАРИФАМИ
class MainMapScreen extends StatelessWidget {
  const MainMapScreen({super.key});

  void _showOrderDialog(BuildContext context, String tariff,
      {String? driverPreference}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Поиск $tariff'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primaryYellow,
            ),
            const SizedBox(height: 20),
            Text(
              driverPreference == 'women'
                  ? 'Ищем женщину-водителя...'
                  : 'Ищем ближайшего водителя...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(driverPreference == 'women'
                ? 'Женщина-водитель найдена! Через 3 минуты будет'
                : '$tariff найден! Через 3 минуты будет'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          // Карта (заглушка)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade200,
                  Colors.grey.shade100,
                ],
              ),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size.infinite,
                  painter: MapGridPainter(),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.my_location,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Грозный, центр',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Верхняя панель поиска
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Куда едем?',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: Colors.grey[200],
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.tune_rounded, color: Colors.grey[600]),
                ],
              ),
            ),
          ),

          // Нижняя панель с тарифами
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Тарифы',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTariffCard(
                          icon: Icons.directions_car_rounded,
                          title: 'Эконом',
                          price: 'от 150 ₽',
                          time: '5 мин',
                          color: Colors.blue,
                          onTap: () => _showOrderDialog(context, 'Эконом'),
                        ),
                        const SizedBox(width: 12),
                        _buildTariffCard(
                          icon: Icons.directions_car_filled_rounded,
                          title: 'Комфорт',
                          price: 'от 250 ₽',
                          time: '3 мин',
                          color: Colors.green,
                          onTap: () => _showOrderDialog(context, 'Комфорт'),
                        ),
                        const SizedBox(width: 12),
                        _buildTariffCard(
                          icon: Icons.female_rounded,
                          title: 'Женский водитель',
                          price: 'от 150 ₽',
                          time: '5 мин',
                          color: Colors.pink,
                          onTap: () => _showOrderDialog(
                              context, 'Женский водитель',
                              driverPreference: 'women'),
                        ),
                        const SizedBox(width: 12),
                        _buildTariffCard(
                          icon: Icons.airport_shuttle_rounded,
                          title: 'Минивэн',
                          price: 'от 350 ₽',
                          time: '7 мин',
                          color: Colors.purple,
                          onTap: () => _showOrderDialog(context, 'Минивэн'),
                        ),
                        const SizedBox(width: 12),
                        _buildTariffCard(
                          icon: Icons.local_shipping_rounded,
                          title: 'Грузовой',
                          price: 'от 599 ₽',
                          time: '10 мин',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DeliveryScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showOrderDialog(context, 'Такси');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Заказать такси',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Кнопка геолокации
          Positioned(
            right: 16,
            bottom: 200,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.my_location_rounded, color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTariffCard({
    required IconData icon,
    required String title,
    required String price,
    required String time,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Грид для карты
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    final step = 50.0;

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
