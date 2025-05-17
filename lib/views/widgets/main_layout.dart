import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_icons.dart';
import 'package:flutter_application_1/views/pages/home_screen.dart';
import 'package:flutter_application_1/views/pages/saved_videos_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [HomeScreen(), SavedVideosScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Home' : 'Offline Videos'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.videoLibrary),
            label: 'Offline',
          ),
        ],
      ),
    );
  }
}
