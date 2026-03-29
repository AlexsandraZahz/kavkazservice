class Trip {
  final String id;
  final String driverName;
  final String carModel;
  final String carNumber;
  final String startAddress;
  final String endAddress;
  final double price;
  final double distance;
  final int duration;
  final DateTime dateTime;
  final String status; // 'completed', 'cancelled', 'in_progress'
  final double rating;
  final String? paymentMethod;

  Trip({
    required this.id,
    required this.driverName,
    required this.carModel,
    required this.carNumber,
    required this.startAddress,
    required this.endAddress,
    required this.price,
    required this.distance,
    required this.duration,
    required this.dateTime,
    required this.status,
    this.rating = 0.0,
    this.paymentMethod,
  });

  // Для тестовых данных
  factory Trip.mock() {
    return Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      driverName: 'Александр',
      carModel: 'Toyota Camry',
      carNumber: 'А123ВС77',
      startAddress: 'ул. Пушкина, д. 10',
      endAddress: 'ул. Лермонтова, д. 25',
      price: 450.0,
      distance: 5.2,
      duration: 18,
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      status: 'completed',
      rating: 4.8,
      paymentMethod: 'Карта •••• 1234',
    );
  }
}
