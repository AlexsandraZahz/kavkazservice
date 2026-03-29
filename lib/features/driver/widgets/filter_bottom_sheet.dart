import 'package:flutter/material.dart';
import 'package:kavkaz_service/app/theme/app_colors.dart';
import 'package:kavkaz_service/features/driver/models/filter_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterModel currentFilter;
  final Function(FilterModel) onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterModel _filter;

  RangeValues _priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _priceRange = RangeValues(
      _filter.minPrice?.toDouble() ?? 0,
      _filter.maxPrice?.toDouble() ?? 1000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              const Text(
                'Фильтр',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Тарифы
          const Text('Тариф', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('Все', _filter.tariff == null),
                ...TariffTypes.all.where((t) => t != 'Все').map((tariff) {
                  return _buildChip(tariff, _filter.tariff == tariff);
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Оплата
          const Text('Оплата', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('Все', _filter.paymentMethod == null),
              ...PaymentMethods.all.where((p) => p != 'Все').map((method) {
                return _buildChip(method, _filter.paymentMethod == method);
              }),
            ],
          ),

          const SizedBox(height: 20),

          // Цена
          const Text('Цена', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${_priceRange.start.round()} ₽'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.remove, size: 16),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${_priceRange.end.round()} ₽'),
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 10,
            activeColor: AppColors.primaryYellow,
            onChanged: (values) {
              setState(() {
                _priceRange = values;
                _filter = _filter.copyWith(
                  minPrice: values.start.round(),
                  maxPrice: values.end.round(),
                );
              });
            },
          ),

          const SizedBox(height: 10),

          // Чекбоксы
          CheckboxListTile(
            value: _filter.longTripsOnly ?? false,
            onChanged: (v) =>
                setState(() => _filter = _filter.copyWith(longTripsOnly: v)),
            title: const Text('Длинные поездки (>10 км)'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),

          CheckboxListTile(
            value: _filter.airportTripsOnly ?? false,
            onChanged: (v) =>
                setState(() => _filter = _filter.copyWith(airportTripsOnly: v)),
            title: const Text('Только аэропорт'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),

          const SizedBox(height: 20),

          // Кнопки
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilter,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('СБРОСИТЬ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('ПРИМЕНИТЬ'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'Все') {
            _filter = _filter.copyWith(
              tariff: null,
              paymentMethod: null,
            );
          } else {
            if (TariffTypes.all.contains(label)) {
              _filter = _filter.copyWith(tariff: isSelected ? null : label);
            } else {
              _filter =
                  _filter.copyWith(paymentMethod: isSelected ? null : label);
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryYellow : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _resetFilter() {
    setState(() {
      _filter = FilterModel();
      _priceRange = const RangeValues(0, 1000);
    });
  }

  void _applyFilter() {
    widget.onApply(_filter);
    Navigator.pop(context);
  }
}
