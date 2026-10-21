import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'chat/chat_list_page.dart';
import 'favorite/favorite_page.dart';
import 'home/home_page.dart';
import 'profile/profile_page.dart';
import 'sell/sell_page.dart';

/// Kerangka utama dengan 5 menu bawah. Menu Jual (tengah) berupa tombol bulat.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  static const List<Widget> _pages = [
    HomePage(),
    FavoritePage(),
    SellPage(),
    ChatListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: 'Favorit',
              ),
              // Ikon disembunyikan; diganti tombol bulat di atasnya.
              NavigationDestination(
                icon: Icon(Icons.add, color: Colors.transparent),
                selectedIcon: Icon(Icons.add, color: Colors.transparent),
                label: 'Jual',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
          Positioned(
            top: -22,
            child: GestureDetector(
              onTap: () => setState(() => _index = 2),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.beige, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x660A8CFF),
                      blurRadius: 12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}