class FilterModel {
  String? tariff;
  String? paymentMethod;
  int? minPrice;
  int? maxPrice;
  double? minDistance;
  double? maxDistance;
  double? minRating;
  bool? urgentOnly;
  bool? longTripsOnly;
  bool? airportTripsOnly;

  FilterModel({
    this.tariff,
    this.paymentMethod,
    this.minPrice,
    this.maxPrice,
    this.minDistance,
    this.maxDistance,
    this.minRating,
    this.urgentOnly,
    this.longTripsOnly,
    this.airportTripsOnly,
  });

  FilterModel copyWith({
    String? tariff,
    String? paymentMethod,
    int? minPrice,
    int? maxPrice,
    double? minDistance,
    double? maxDistance,
    double? minRating,
    bool? urgentOnly,
    bool? longTripsOnly,
    bool? airportTripsOnly,
  }) {
    return FilterModel(
      tariff: tariff ?? this.tariff,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      minRating: minRating ?? this.minRating,
      urgentOnly: urgentOnly ?? this.urgentOnly,
      longTripsOnly: longTripsOnly ?? this.longTripsOnly,
      airportTripsOnly: airportTripsOnly ?? this.airportTripsOnly,
    );
  }
}

// Список тарифов
class TariffTypes {
  static const List<String> all = [
    'Все',
    'Эконом',
    'Комфорт',
    'Бизнес',
    'Грузовой',
  ];
}

// Список оплаты
class PaymentMethods {
  static const List<String> all = [
    'Все',
    'Наличные',
    'Карта',
  ];
}
