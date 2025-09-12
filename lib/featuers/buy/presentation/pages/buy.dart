import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/dependencies.dart';
import '../../../../core/utils/requests_status.dart';
import '../../../favorite/presentation/bloc/favorite_bloc.dart';
import '../bloc/buy_bloc.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السيارات المتاحة'), centerTitle: true),
      body: BlocBuilder<BuyBloc, BuyState>(
        bloc: getIt<BuyBloc>()..add(GetBuyCarEvent()),
        builder: (context, state) {
          return state.carBuyStatus == RequestStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : state.carBuyStatus == RequestStatus.failed
              ? Center(
                  child: IconButton.filled(
                    onPressed: () {
                      getIt<BuyBloc>().add(GetBuyCarEvent());
                    },
                    icon: Icon(Icons.refresh),
                  ),
                )
              : RefreshIndicator.adaptive(
                  onRefresh: () {
                    getIt<BuyBloc>().add(GetBuyCarEvent());
                    return Future.delayed(const Duration(seconds: 1), () {});
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: state.cars.length,
                    itemBuilder: (context, index) => _buildCarCard(state.cars[index]),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildCarCard(CarListing car) {
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.network(
                    car.imageUrls.first,
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
                    child: BlocBuilder<FavoriteBloc, FavoriteState>(
                      bloc: getIt<FavoriteBloc>(),
                      builder: (context, state) {
                        final isFavorite = state.cars.contains(car);
                        return IconButton(
                          onPressed: () {
                            getIt<FavoriteBloc>().add(ToggleFavoriteEvent(carListing: car));
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                        );
                      },
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
                    car.carModel,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${priceFormat.format(car.price)} دولار',
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(car.city, style: const TextStyle(fontSize: 12)),
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

  void _showSimpleCarDetails(CarListing car) {
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
              child: Image.network(
                car.imageUrls.first,
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
            Text(car.carModel, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '${NumberFormat('#,###', 'ar').format(car.price)} ر.س',
              style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
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
