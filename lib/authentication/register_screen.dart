import 'package:flutter/material.dart';
import 'package:finance/authentication/auth_service.dart';
import 'package:finance/authentication/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background container
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color(0xFF388b85),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.07),
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
          // Form container
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.33),
            child: Container(
              height: screenHeight,
              width: screenWidth,
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
                  horizontal: screenWidth * 0.07,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Name field
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Бүтэн нэрээ оруулна уу',
                          label: Text(
                            'Нэр',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388b85),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Email field
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'И-мэйлээ орлууна уу',
                          label: Text(
                            'И-мэйл',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388b85),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Нууц үгээ оруулна уу',
                          label: Text(
                            'Нууц үг',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388b85),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Confirm password field
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Нууц үгээ давтан оруулна уу',
                          label: Text(
                            'Нууц үг баталгаажуулалт',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388b85),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.07),
                      // Register button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(screenWidth * 0.8, screenHeight * 0.07),
                          backgroundColor: const Color(0xFF388b85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _signup,
                        child: const Text(
                          'Бүртгүүлэх',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.07),
                      // Login redirect
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Бүртгэл байгаа уу?",
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
                                          const LoginScreen()),
                                );
                              },
                              child: const Text(
                                "Нэвтрэх",
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

  _signup() async {
    // Check if the passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      print("Passwords don't match");
      return;
    }

    final user = await _auth.createUserWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      print("User created successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      print("Failed to create user");
    }
  }
}
