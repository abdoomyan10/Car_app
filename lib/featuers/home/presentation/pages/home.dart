// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:car_appp/featuers/buy/presentation/pages/buy.dart';
import 'package:car_appp/featuers/favorite/presentation/pages/favorite_screen.dart';
import 'package:car_appp/featuers/home/presentation/pages/drawer.dart';
import 'package:car_appp/featuers/rent/presentation/pages/rent.dart';
import 'package:car_appp/featuers/sale/presentation/pages/sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/dependencies.dart';
import '../../../../core/utils/requests_status.dart';
import '../../../favorite/presentation/bloc/favorite_bloc.dart';
import '../bloc/home_bloc.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

int currentIndex = 0;

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const BuyScreen(),
    const RentScreen(),
    const SaleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'شراء',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              activeIcon: Icon(Icons.payment),
              label: 'تأجير',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              activeIcon: Icon(Icons.monetization_on),
              label: 'بيع',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getIt<HomeBloc>().add(GetCarsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),

      appBar: AppBar(
        title: const Text('Car Market'),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})],
      ),
      body: const HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(),
            SizedBox(height: 20),
            SectionTitle(
              title: 'السيارات المميزة',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
              },
            ),
            SizedBox(height: 10),
            FeaturedCarsSection(),
            SizedBox(height: 20),
            SectionTitle(title: 'فئات السيارات'),
            SizedBox(height: 10),
            CategoriesSection(),
            SizedBox(height: 20),
            SectionTitle(title: 'إعلانات حديثة'),
            SizedBox(height: 10),
            RecentListingsSection(),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن سيارة...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onTap, child: onTap == null ? Text('') : const Text('عرض الكل')),
      ],
    );
  }
}

class FeaturedCarsSection extends StatelessWidget {
  const FeaturedCarsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      bloc: getIt<FavoriteBloc>(),
      builder: (context, state) {
        return state.cars.isEmpty
            ? Center(child: Text('لا يوجد سيارات مفضلة بعد'))
            : SizedBox(
                height: 220,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: state.cars.length > 3 ? 3 : state.cars.length,
                  scrollDirection: Axis.horizontal,

                  itemBuilder: (context, index) => CarCard(car: state.cars[index]),
                ),
              );
      },
    );
  }
}

class CarCard extends StatelessWidget {
  final CarListing car;
  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  car.imageUrls.firstOrNull ?? '',
                  height: 120,
                  width: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    width: 180,
                    color: Colors.grey[200],
                    child: const Icon(Icons.car_repair, size: 40),
                  ),
                ),
              ),
              BlocBuilder<FavoriteBloc, FavoriteState>(
                bloc: getIt<FavoriteBloc>(),
                builder: (context, state) {
                  final isFavorite = state.cars.contains(car);
                  return Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        getIt<FavoriteBloc>().add(ToggleFavoriteEvent(carListing: car));
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(car.carModel, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  car.price.toStringAsFixed(0),
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('حلب', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CategoryItem(icon: Icons.directions_car, label: 'جميع السيارات'),
          CategoryItem(icon: Icons.electric_car, label: 'كهربائية'),
          CategoryItem(icon: Icons.local_shipping, label: 'نقل'),
          CategoryItem(icon: Icons.time_to_leave, label: 'كلاسيكية'),
          CategoryItem(icon: Icons.two_wheeler, label: 'دراجات'),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class RecentListingsSection extends StatelessWidget {
  const RecentListingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: getIt<HomeBloc>(),
      builder: (context, state) {
        return state.carBuyStatus == RequestStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : state.cars.isEmpty
            ? const Center(child: Text('لا توجد إعلانات حديثة'))
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: state.cars.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final car = state.cars[index];
                  return ListingItem(
                    image: car.imageUrls.firstOrNull ?? '',
                    title: car.carModel,
                    price: '${car.price.toStringAsFixed(0)} ل.س',
                    location: car.city,
                    date: '${car.createdAt.day}/${car.createdAt.month}/${car.createdAt.year}',
                  );
                },
              );
      },
    );
  }
}

class ListingItem extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String location;
  final String date;

  const ListingItem({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.car_rental, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
