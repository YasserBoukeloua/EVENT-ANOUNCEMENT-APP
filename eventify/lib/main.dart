import 'package:eventify/screens/home/home_screen.dart';
import 'package:eventify/screens/favorite/favorite_screen.dart';
import 'package:eventify/screens/profile/profile_screen.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'JosefinSans',
      ),
      home: const LoginScreen(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Home(),
    FavoritesScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    // Map navigation indices: 0->Home, 1->Favorites, 2->Profile
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 12, 51),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => _onItemTapped(0),
                      icon: Icon(
                        Icons.home_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _onItemTapped(1),
                      icon: Icon(
                        Icons.star_border_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _onItemTapped(2),
                      icon: Icon(
                        Icons.person_outline_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
