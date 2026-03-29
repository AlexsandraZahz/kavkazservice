import 'package:flutter/material.dart';
import 'package:kavkaz_service/app/theme/app_colors.dart';
import 'package:kavkaz_service/features/driver/orders/orders_screen.dart';
import 'package:kavkaz_service/features/driver/earnings/earnings_screen.dart';
import 'package:kavkaz_service/features/driver/profile/profile_screen.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isOnline = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Убрали неиспользуемое поле _screens

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
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
          children: [
            OrdersScreen(isOnline: _isOnline),
            const EarningsScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Премиальный переключатель онлайн/офлайн
              Container(
                margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A1A1A), Color(0xFF2C2C2E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatusButton('Офлайн', false),
                    ),
                    Expanded(
                      child: _buildStatusButton('Онлайн', true),
                    ),
                  ],
                ),
              ),

              // Навигация
              BottomNavigationBar(
                items: [
                  _buildNavItem(Icons.map_outlined, Icons.map_rounded, 0),
                  _buildNavItem(
                      Icons.trending_up_outlined, Icons.trending_up_rounded, 1),
                  _buildNavItem(
                      Icons.person_outline_rounded, Icons.person_rounded, 2),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: AppColors.primaryYellow,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  setState(() => _selectedIndex = index);
                  _animationController.reset();
                  _animationController.forward();
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String text, bool isOnline) {
    final isSelected = _isOnline == isOnline;

    return GestureDetector(
      onTap: () {
        setState(() => _isOnline = isOnline);
        _animationController.reset();
        _animationController.forward();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(36),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryYellow.withValues(alpha: 0.3),
                    blurRadius: 8,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, IconData activeIcon, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(_selectedIndex == index ? 8 : 4),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? AppColors.primaryYellow.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(_selectedIndex == index ? activeIcon : icon, size: 24),
      ),
      label: _getLabel(index),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Заказы';
      case 1:
        return 'Заработок';
      case 2:
        return 'Профиль';
      default:
        return '';
    }
  }
}
