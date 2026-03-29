import 'package:flutter/material.dart';
import 'package:kavkazway/app/theme/app_colors.dart';
import 'package:kavkazway/features/main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Offset> _pathAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Плавное появление
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Масштабирование с эффектом пружины
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Скольжение снизу
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Вращение
    _rotateAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Анимация пути (для машинки)
    _pathAnimation = Tween<Offset>(
      begin: const Offset(-50, 0),
      end: const Offset(350, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Переход на главный экран
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryYellow,
              AppColors.primaryYellow.withValues(alpha: 0.9),
              Colors.orange.shade100,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Анимированные фоновые элементы
            ..._buildAnimatedBackground(),

            // Основной контент
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Контейнер с логотипом
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Transform.rotate(
                              angle: _rotateAnimation.value,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                          spreadRadius: 5,
                                        ),
                                        BoxShadow(
                                          color: AppColors.primaryYellow
                                              .withValues(alpha: 0.4),
                                          blurRadius: 50,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        'assets/logo.png', // Путь к логотипу
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: AppColors.primaryYellow,
                                            child: Icon(
                                              Icons.route_rounded,
                                              size: 100,
                                              color: Colors.black
                                                  .withValues(alpha: 0.7),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Анимированная линия с машинкой
                      SizedBox(
                        height: 100,
                        width: 300,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: RoadPainter(
                                progress: _controller.value,
                                carOffset: _pathAnimation.value,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Текст с анимацией
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.black87,
                                  Colors.black87,
                                  Colors.black54,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Text(
                                'КАВКАЗ ПУТЬ',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 15,
                                      offset: Offset(3, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'транспортная платформа',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Анимированный индикатор загрузки
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 1500),
                          tween: Tween<double>(begin: 0, end: 2 * 3.14159),
                          builder: (context, double angle, child) {
                            return Transform.rotate(
                              angle: angle,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black87,
                                    width: 3,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.black87,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedBackground() {
    return [
      // Большое пульсирующее кольцо
      Positioned(
        top: -50,
        right: -50,
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 4),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Container(
              width: 200 + value * 50,
              height: 200 + value * 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            );
          },
        ),
      ),

      // Движущиеся круги
      ...List.generate(3, (index) {
        final duration = Duration(seconds: 3 + index * 2);
        final beginOffset = Offset(index * 30.0, index * 20.0);
        final endOffset = Offset(index * 30.0 + 50, index * 20.0 + 30);

        return Positioned(
          left: 20 + index * 40.0,
          top: 100 + index * 60.0,
          child: TweenAnimationBuilder(
            duration: duration,
            tween: Tween<Offset>(begin: beginOffset, end: endOffset),
            builder: (context, Offset offset, child) {
              return Transform.translate(
                offset: offset,
                child: Container(
                  width: 60 + index * 20,
                  height: 60 + index * 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              );
            },
          ),
        );
      }),

      // Парящие точки
      ...List.generate(30, (index) {
        final randomX = (index * 23) % 400;
        final randomY = (index * 17) % 800;
        final duration = Duration(seconds: 2 + (index % 4));

        return Positioned(
          left: randomX.toDouble(),
          top: randomY.toDouble(),
          child: TweenAnimationBuilder(
            duration: duration,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Container(
                width: 2 + value * 3,
                height: 2 + value * 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.3 + value * 0.2),
                ),
              );
            },
          ),
        );
      }),
    ];
  }
}

// Кастомный painter для отрисовки дороги и машинки
class RoadPainter extends CustomPainter {
  final double progress;
  final Offset carOffset;

  RoadPainter({
    required this.progress,
    required this.carOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем линию дороги
    final roadPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Основная линия
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.3,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.7,
        size.width,
        size.height * 0.5,
      );

    canvas.drawPath(path, roadPaint);

    // Рисуем пунктирную линию
    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pathMetrics = path.computeMetrics();
    if (pathMetrics.isNotEmpty) {
      final metric = pathMetrics.first;

      // Рисуем пунктир
      for (double i = 0; i < metric.length; i += 15) {
        if (i + 10 <= metric.length) {
          final startTangent = metric.getTangentForOffset(i);
          final endTangent = metric.getTangentForOffset(i + 10);

          if (startTangent != null && endTangent != null) {
            canvas.drawLine(
              startTangent.position,
              endTangent.position,
              dashPaint,
            );
          }
        }
      }

      // Рисуем машинку в зависимости от прогресса
      if (progress > 0.3) {
        final carTangent = metric.getTangentForOffset(
          metric.length * ((progress - 0.3) / 0.6).clamp(0.0, 1.0),
        );

        if (carTangent != null) {
          _drawCar(canvas, carTangent.position, carTangent.angle);
        }
      }
    }
  }

  void _drawCar(Canvas canvas, Offset position, double angle) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    // Кузов машинки
    final carPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final carRect = Rect.fromCenter(
      center: Offset.zero,
      width: 30,
      height: 15,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(carRect, const Radius.circular(5)),
      carPaint,
    );

    // Окна
    final windowPaint = Paint()..color = Colors.white;
    canvas.drawRect(
      Rect.fromCenter(center: const Offset(-5, -3), width: 8, height: 6),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: const Offset(5, -3), width: 8, height: 6),
      windowPaint,
    );

    // Колеса
    final wheelPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(-10, 5), 4, wheelPaint);
    canvas.drawCircle(const Offset(10, 5), 4, wheelPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RoadPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.carOffset != carOffset;
  }
}
