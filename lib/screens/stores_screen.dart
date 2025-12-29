import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../widgets/stores/stores_map.dart';
import '../widgets/stores/store_card.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  Store? _selectedStore;

  final List<Store> _stores = [
    Store(
      id: '1',
      name: 'г. Новосибирск',
      address: 'ул. Шоссейная, 52/1',
      workingHours: 'Ежедневно с 9:00 до 23:00',
      phone: '+7 (933) 194-62-80',
      latitude: 55.0415,
      longitude: 82.9346,
    ),
  ];

  void _selectStore(Store store) {
    setState(() {
      _selectedStore = store;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Магазины'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Карта из конструктора
          const Padding(
            padding: EdgeInsets.all(16),
            child: StoresMap(height: 300), // Можно изменить высоту
          ),

          // Заголовок списка
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Наши магазины',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D5A3E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_stores.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Список магазинов
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _stores.length,
              itemBuilder: (context, index) {
                final store = _stores[index];
                final isSelected = _selectedStore?.id == store.id;

                return StoreCard(
                  store: store,
                  isSelected: isSelected,
                  onTap: () => _selectStore(store),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
