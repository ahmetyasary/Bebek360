import 'package:flutter/material.dart';
import 'baby_dashboard_screen.dart';
import 'feeding_screen.dart';
import 'diaper_screen.dart';
import 'sleep_screen.dart';
import 'growth_screen.dart';
import 'moments_screen.dart';
import 'vaccine_screen.dart';
import 'allergy_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BabyDashboardScreen(),
    const FeedingScreen(),
    const DiaperScreen(),
    const SleepScreen(),
    const GrowthScreen(),
    const MomentsScreen(),
    const VaccineScreen(),
    const AllergyScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bebek360'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Özet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Beslenme',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.baby_changing_station),
            label: 'Bez',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bedtime),
            label: 'Uyku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Gelişim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Anılar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vaccines),
            label: 'Aşılar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Alerji',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'İstatistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
