import 'package:car_appp/core/services/dependencies.dart';
import 'package:car_appp/featuers/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_appp/featuers/auth/presentation/bloc/auth_event.dart';
import 'package:car_appp/featuers/auth/presentation/pages/splashscreen.dart';
import 'package:car_appp/featuers/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';

import '../../../favorite/presentation/pages/favorite_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'اسم المستخدم',
              ), // Replace with actual user name if available
              accountEmail: Text(
                'user@email.com',
              ), // Replace with actual email if available
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  'U', // First letter of user name
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('الملف الشخصي'),
              onTap: () {
                // Navigate to profile page if exists
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('المفضلة'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('الإعدادات'),
              onTap: () {
                // Navigate to settings page if exists
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                ),
                icon: Icon(Icons.logout),
                label: Text('تسجيل الخروج'),
                onPressed: () {
                  getIt<AuthBloc>().add(LogoutEvent());
                  getIt<FavoriteBloc>().add(ClearFavoriteEvent());
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SplashScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
