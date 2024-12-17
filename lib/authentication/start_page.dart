import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.1), // 10% of screen height
              child: Image.asset(
                'assets/images/home.png',
                width: screenWidth * 0.8, // 80% of screen width
                height: screenHeight * 0.3, // 30% of screen height
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1, // 10% of screen height
            ),
            Text(
              'Ухаалаг Зарцуулж Илүү Хэмнэе',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.08, // 8% of screen width
                fontWeight: FontWeight.bold,
                color: const Color(0xFF388b85),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05, // 5% of screen height
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Container(
                height: screenHeight * 0.07, // 7% of screen height
                width: screenWidth * 0.8, // 80% of screen width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF388b85)),
                ),
                child: const Center(
                  child: Text(
                    'Нэвтрэх',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388b85),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05, // 5% of screen height
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              },
              child: Container(
                height: screenHeight * 0.07, // 7% of screen height
                width: screenWidth * 0.8, // 80% of screen width
                decoration: BoxDecoration(
                  color: const Color(0xFF388b85),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF388b85)),
                ),
                child: const Center(
                  child: Text(
                    'Бүртгүүлэх',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
