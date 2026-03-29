import 'package:flutter/material.dart';
import 'package:kavkazway/app/theme/app_colors.dart';
import 'models/trip_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Текущий фильтр
  String _currentFilter = 'all'; // all, completed, cancelled

  // Тестовые данные
  final List<Trip> _trips = [
    Trip(
      id: '1',
      driverName: 'Иван',
      carModel: 'Hyundai Solaris',
      carNumber: 'В456ОР77',
      startAddress: 'ТЦ Гагаринский, пр. Гагарина',
      endAddress: 'Аэропорт Платов',
      price: 1250.0,
      distance: 22.5,
      duration: 35,
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'completed',
      rating: 5.0,
      paymentMethod: 'Карта •••• 5678',
    ),
    Trip(
      id: '2',
      driverName: 'Мария',
      carModel: 'Kia Rio',
      carNumber: 'С789ТУ77',
      startAddress: 'ул. Московская, д. 15',
      endAddress: 'ЖД вокзал Ростов-Главный',
      price: 320.0,
      distance: 8.3,
      duration: 25,
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      status: 'completed',
      rating: 4.5,
      paymentMethod: 'Наличные',
    ),
    Trip(
      id: '3',
      driverName: 'Дмитрий',
      carModel: 'Lada Granta',
      carNumber: 'О321АВ77',
      startAddress: 'ул. Красноармейская, д. 100',
      endAddress: 'ТРК Горизонт',
      price: 180.0,
      distance: 4.2,
      duration: 12,
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      status: 'cancelled',
      rating: 0.0,
    ),
    Trip(
      id: '4',
      driverName: 'Анна',
      carModel: 'Skoda Octavia',
      carNumber: 'Р159УК77',
      startAddress: 'Парк Горького',
      endAddress: 'Набережная Дона',
      price: 280.0,
      distance: 6.8,
      duration: 18,
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      status: 'completed',
      rating: 4.9,
      paymentMethod: 'Карта •••• 9012',
    ),
    Trip(
      id: '5',
      driverName: 'Сергей',
      carModel: 'Volkswagen Polo',
      carNumber: 'Н753ЕК77',
      startAddress: 'ул. Буденновская, д. 50',
      endAddress: 'ТЦ Вавилон',
      price: 210.0,
      distance: 5.1,
      duration: 15,
      dateTime: DateTime.now().subtract(const Duration(days: 7)),
      status: 'completed',
      rating: 4.7,
      paymentMethod: 'Apple Pay',
    ),
  ];

  // Получить отфильтрованные поездки
  List<Trip> get _filteredTrips {
    if (_currentFilter == 'all') return _trips;
    return _trips.where((trip) => trip.status == _currentFilter).toList();
  }

  // Форматирование даты
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tripDate = DateTime(date.year, date.month, date.day);

    if (tripDate == today) return 'Сегодня';
    if (tripDate == yesterday) return 'Вчера';

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  // Форматирование времени
  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text(
          'История поездок',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Статистика
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Всего поездок',
                  '${_trips.length}',
                  Icons.directions_car,
                  AppColors.primaryYellow,
                ),
                _buildStatItem(
                  'Потрачено',
                  '${_trips.where((t) => t.status == 'completed').fold(0.0, (sum, trip) => sum + trip.price).toInt()} ₽',
                  Icons.attach_money,
                  Colors.green,
                ),
                _buildStatItem(
                  'Средний рейтинг',
                  (_trips
                              .where((t) => t.rating > 0)
                              .fold(0.0, (sum, trip) => sum + trip.rating) /
                          _trips.where((t) => t.rating > 0).length)
                      .toStringAsFixed(1),
                  Icons.star,
                  Colors.orange,
                ),
              ],
            ),
          ),

          // Фильтры
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                _buildFilterChip('Все', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Завершенные', 'completed'),
                const SizedBox(width: 8),
                _buildFilterChip('Отмененные', 'cancelled'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Список поездок
          Expanded(
            child: _filteredTrips.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = _filteredTrips[index];
                      return _buildTripCard(trip);
                    },
                  ),
          ),
        ],
      ),

      // Плавающая кнопка для подробной статистики
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showStatisticsDialog();
        },
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.bar_chart),
        label: const Text('Статистика'),
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _currentFilter = value;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppColors.primaryYellow,
      checkmarkColor: Colors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхняя часть с датой и статусом
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(trip.status).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(trip.dateTime),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatTime(trip.dateTime),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(trip.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(trip.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Детали поездки
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Информация о водителе
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryYellow.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primaryYellow,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.driverName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${trip.carModel} • ${trip.carNumber}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (trip.rating > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.primaryYellow,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  trip.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Маршрут
                _buildRoutePoint(
                  Icons.my_location,
                  trip.startAddress,
                  'Откуда',
                  isFirst: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 2,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      const Icon(
                        Icons.arrow_downward,
                        color: AppColors.primaryYellow,
                        size: 20,
                      ),
                      Container(
                        width: 2,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                _buildRoutePoint(
                  Icons.location_on,
                  trip.endAddress,
                  'Куда',
                  isFirst: false,
                ),

                const SizedBox(height: 16),

                // Статистика поездки
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTripStat(
                      '${trip.distance.toStringAsFixed(1)} км',
                      'Расстояние',
                      Icons.directions_car,
                    ),
                    _buildTripStat(
                      '${trip.duration} мин',
                      'Время',
                      Icons.access_time,
                    ),
                    _buildTripStat(
                      '${trip.price.toInt()} ₽',
                      'Стоимость',
                      Icons.attach_money,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Кнопки действий
                if (trip.status == 'completed')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _rateTrip(trip);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: AppColors.primaryYellow),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.star,
                            color: AppColors.primaryYellow,
                            size: 20,
                          ),
                          label: Text(
                            trip.rating > 0 ? 'Изменить оценку' : 'Оценить',
                            style: const TextStyle(
                              color: AppColors.primaryYellow,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _repeatTrip(trip);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlack,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.repeat, size: 20),
                          label: const Text(
                            'Повторить',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Информация об оплате
                if (trip.paymentMethod != null)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.payment,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Оплата: ${trip.paymentMethod!}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
    );
  }

  Widget _buildRoutePoint(IconData icon, String address, String label,
      {required bool isFirst}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFirst
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: isFirst ? Colors.green : Colors.red,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Icon(
              Icons.history_toggle_off,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Поездок пока нет',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _currentFilter == 'completed'
                  ? 'У вас нет завершенных поездок'
                  : _currentFilter == 'cancelled'
                      ? 'У вас нет отмененных поездок'
                      : 'Совершите первую поездку, и она появится здесь',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _currentFilter = 'all';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.map),
            label: const Text(
              'Заказать такси',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Завершена';
      case 'cancelled':
        return 'Отменена';
      case 'in_progress':
        return 'В процессе';
      default:
        return 'Неизвестно';
    }
  }

  void _rateTrip(Trip trip) {
    double currentRating = trip.rating;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Оцените поездку'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${trip.driverName}, ${trip.carModel}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          currentRating = (index + 1).toDouble();
                        });
                      },
                      icon: Icon(
                        index < currentRating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.primaryYellow,
                        size: 40,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  currentRating == 0
                      ? 'Выберите оценку'
                      : '${currentRating.toInt()} звезд',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Спасибо! Вы поставили $currentRating звезд'),
                      backgroundColor: AppColors.primaryYellow,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Подтвердить'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _repeatTrip(Trip trip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Повторяем поездку: ${trip.startAddress} → ${trip.endAddress}'),
        backgroundColor: AppColors.primaryYellow,
        action: SnackBarAction(
          label: 'ОК',
          textColor: Colors.black,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showStatisticsDialog() {
    final completedTrips = _trips.where((t) => t.status == 'completed').length;
    final totalSpent = _trips
        .where((t) => t.status == 'completed')
        .fold(0.0, (sum, trip) => sum + trip.price);
    final avgRating = _trips
            .where((t) => t.rating > 0)
            .fold(0.0, (sum, trip) => sum + trip.rating) /
        (_trips.where((t) => t.rating > 0).isEmpty
            ? 1
            : _trips.where((t) => t.rating > 0).length);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Статистика поездок',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('Всего поездок', '${_trips.length}'),
            _buildStatRow('Завершено', '$completedTrips'),
            _buildStatRow('Отменено',
                '${_trips.where((t) => t.status == 'cancelled').length}'),
            _buildStatRow('Общая сумма', '${totalSpent.toInt()} ₽'),
            _buildStatRow('Средний чек',
                '${(totalSpent / (completedTrips == 0 ? 1 : completedTrips)).toInt()} ₽'),
            _buildStatRow('Средний рейтинг', avgRating.toStringAsFixed(1)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: Colors.black,
              ),
              child: const Text('Закрыть'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
