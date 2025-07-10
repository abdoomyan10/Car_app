import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final List<Map<String, dynamic>> cars = [
    {
      'image': 'assets/santafe.png.png',
      'model': '  سنتافيه 2014',
      'price': 12000,
      'location': 'حلب',
      'isFavorite': false,
    },
    {
      'image': 'assets/sportage.png',
      'model': '  سبورتاج 2010',
      'price': 8000,
      'location': 'الشام',
      'isFavorite': true,
    },
    {
      'image': 'assets/Rio.png',
      'model': '  كيا ريو 2008',
      'price': 5000,
      'location': 'حلب',
      'isFavorite': false,
    },
    {
      'image': 'assets/lxs.png.png',
      'model': 'لكزس LX570 2020',
      'price': 25000,
      'location': 'سرمدا',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السيارات المتاحة'), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: cars.length,
        itemBuilder: (context, index) => _buildCarCard(cars[index]),
      ),
    );
  }

  Widget _buildCarCard(Map<String, dynamic> car) {
    final priceFormat = NumberFormat('#,###', 'ar');

    return GestureDetector(
      onTap: () => _showSimpleCarDetails(car),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة السيارة
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    car['image'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      height: 120,
                      child: const Icon(Icons.car_repair, size: 40),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: Icon(
                        car['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: car['isFavorite'] ? Colors.red : Colors.white,
                      ),
                      onPressed: () => _toggleFavorite(car),
                    ),
                  ),
                ],
              ),
            ),

            // تفاصيل السيارة
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['model'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${priceFormat.format(car['price'])} ر.س',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          car['location'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> car) {
    setState(() {
      car['isFavorite'] = !car['isFavorite'];
    });
  }

  void _showSimpleCarDetails(Map<String, dynamic> car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                car['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  height: 200,
                  child: const Icon(Icons.car_repair, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              car['model'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${NumberFormat('#,###', 'ar').format(car['price'])} ر.س',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Container(child: Text('thank'));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('تواصل مع البائع'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
