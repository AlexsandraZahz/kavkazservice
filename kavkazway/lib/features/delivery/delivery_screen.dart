import 'package:flutter/material.dart';
import 'package:kavkazway/app/theme/app_colors.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Доставка грузов',
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
        padding: const EdgeInsets.all(16),
        children: [
          // Быстрый выбор адресов
          _buildAddressCard(),

          const SizedBox(height: 20),

          // Тип груза (простой выбор)
          const Text(
            'Что везем?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildCargoTypeSelector(),

          const SizedBox(height: 20),

          // Тип машины (три варианта)
          const Text(
            'Какая машина нужна?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildVehicleSelector(),

          const SizedBox(height: 20),

          // Вес (простой слайдер)
          _buildWeightSelector(),

          const SizedBox(height: 20),

          // Итого и кнопка заказа
          _buildTotalCard(context),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Откуда
          Row(
            children: [
              const Icon(Icons.circle, color: Colors.green, size: 12),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Откуда забрать?',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          // Куда
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 12),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Куда доставить?',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCargoTypeSelector() {
    final types = ['📦 Посылка', '🪑 Мебель', '📺 Техника', '📦 Другое'];
    return Container(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: index == 0 ? AppColors.primaryYellow : Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color:
                    index == 0 ? AppColors.primaryYellow : Colors.grey.shade300,
              ),
            ),
            child: Center(
              child: Text(
                types[index],
                style: TextStyle(
                  color: index == 0 ? Colors.black : Colors.grey[600],
                  fontWeight: index == 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleSelector() {
    return Row(
      children: [
        Expanded(
            child: _buildVehicleCard('Легковая', 'до 50 кг', 'от 299₽', true)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildVehicleCard(
                'Микроавтобус', 'до 300 кг', 'от 499₽', false)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildVehicleCard('Грузовая', 'до 1 т', 'от 799₽', false)),
      ],
    );
  }

  Widget _buildVehicleCard(
      String title, String capacity, String price, bool selected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primaryYellow.withValues(alpha: 0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppColors.primaryYellow : Colors.grey.shade200,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            title == 'Легковая'
                ? Icons.directions_car
                : title == 'Микроавтобус'
                    ? Icons.airport_shuttle
                    : Icons.local_shipping,
            color: selected ? AppColors.primaryYellow : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(capacity,
              style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(price,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildWeightSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Вес груза', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('15 кг', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: 15,
            min: 1,
            max: 100,
            divisions: 99,
            activeColor: AppColors.primaryYellow,
            inactiveColor: Colors.grey.shade300,
            onChanged: (value) {},
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 кг', style: TextStyle(fontSize: 11, color: Colors.grey)),
              Text('100 кг',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Итого:',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text('от 750 ₽',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('включая все услуги',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Icon(Icons.check_circle,
                        color: Colors.green, size: 60),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Заказ принят!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Водитель едет к вам',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Отслеживать'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow),
                        child: const Text('Ок'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Заказать'),
          ),
        ],
      ),
    );
  }
}
