import 'package:finance/authentication/auth_service.dart';
import 'package:finance/menu/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:finance/authentication/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color(0xFF388b85),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: Column(
                children: [
                  const Text(
                    'Тавтай морилно уу!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Image.asset(
                    'assets/images/login.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          // Form Container
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.35),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.05,
                  horizontal: screenWidth * 0.05,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Email Field
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email address',
                          label: Text(
                            'Gmail',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388b85),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          hintText: 'Enter your password',
                          label: Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388b85),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.07),
                      // Login Button
                      GestureDetector(
                        onTap: () {
                          //_login();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavigation()),
                          );
                        },
                        child: Container(
                          height: screenHeight * 0.07,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFF388b85),
                          ),
                          child: const Center(
                            child: Text(
                              'Нэвтрэх',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.1),
                      // Register Section
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Бүртгэл байхгүй юу?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                "Бүртгүүлэх",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _login() async {
    final user = await _auth.logInUserWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    if (user != null) {
      print("User logged in.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
      );
    }
  }
}
