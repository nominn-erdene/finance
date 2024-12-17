import 'package:finance/screens/add_screen.dart';
import 'package:finance/screens/bar_screen.dart';
import 'package:finance/screens/home_screen.dart';
import 'package:finance/screens/profile_screen.dart';
import 'package:finance/screens/wallet_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int index = 0;
  final List<Widget> screen = [
    const HomeScreen(),
    const BarScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screen[index],
      floatingActionButton: index == 0
          ? GestureDetector(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AddScreen()),
                  );
                },
                backgroundColor: const Color(0xFF388b85),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation:
          index == 0 ? FloatingActionButtonLocation.centerDocked : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, -2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: index == 0 ? const CircularNotchedRectangle() : null,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: index == 0
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: Icon(
                    Icons.home,
                    size: 35,
                    color: index == 0 ? const Color(0xFF388b85) : Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 1;
                    });
                  },
                  child: Icon(
                    Icons.bar_chart,
                    size: 35,
                    color: index == 1 ? const Color(0xFF388b85) : Colors.grey,
                  ),
                ),
                if (index == 0) const SizedBox(width: 10), // For FAB space
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 2;
                    });
                  },
                  child: Icon(
                    Icons.wallet,
                    size: 35,
                    color: index == 2 ? const Color(0xFF388b85) : Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 3;
                    });
                  },
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: index == 3 ? const Color(0xFF388b85) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
