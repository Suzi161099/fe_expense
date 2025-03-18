// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login.dart';
// import 'home.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> registerUser() async {
//     final String name = _nameController.text.trim();
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text.trim();
//     final String confirmPassword = _confirmPasswordController.text.trim();

//     if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//       _showMessage("Vui lòng điền đầy đủ thông tin", isError: true);
//       return;
//     }

//     if (password != confirmPassword) {
//       _showMessage("Mật khẩu không khớp", isError: true);
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final url = Uri.parse("http://10.0.2.2:3000/api/auth/signup");
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "username": name,
//           "email": email,
//           "password": password,
//         }),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 201 && responseData["success"] == true) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString("token", responseData["token"]);

//         _showMessage("Đăng ký thành công!", isError: false);

//         Future.delayed(const Duration(seconds: 1), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         });
//       } else {
//         _showMessage(responseData["message"] ?? "Đăng ký thất bại", isError: true);
//       }
//     } catch (e) {
//       _showMessage("Lỗi kết nối đến server!", isError: true);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _showMessage(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: const TextStyle(fontSize: 16)),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.pink, Colors.black],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Create account",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   const SizedBox(height: 10),
//                   _buildInputField(Icons.person, "Full name", _nameController),
//                   const SizedBox(height: 10),
//                   _buildInputField(Icons.email, "Email", _emailController),
//                   const SizedBox(height: 10),
//                   _buildInputField(Icons.lock, "Password", _passwordController, isPassword: true),
//                   const SizedBox(height: 10),
//                   _buildInputField(Icons.lock, "Confirm password", _confirmPasswordController, isPassword: true),
//                   const SizedBox(height: 20),
//                   isLoading
//                       ? const CircularProgressIndicator(color: Colors.pinkAccent)
//                       : ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.pinkAccent,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//                           ),
//                           onPressed: registerUser,
//                           child: const Text("SIGN UP →", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                         ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const LoginScreen()),
//                       );
//                     },
//                     child: const Text.rich(
//                       TextSpan(
//                         text: "Already have an account? ",
//                         style: TextStyle(color: Colors.white70),
//                         children: [
//                           TextSpan(
//                             text: "Sign in",
//                             style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.white),
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.white70),
//         filled: true,
//         fillColor: Colors.white12,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: const TextStyle(color: Colors.white),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fe_expense/controllers/signup_controller.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _controller = SignUpController();
  bool isLoading = false;

  void _setLoadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink, Colors.black],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(Icons.person, "Full name", _controller.nameController),
                  const SizedBox(height: 10),
                  _buildInputField(Icons.email, "Email", _controller.emailController),
                  const SizedBox(height: 10),
                  _buildInputField(Icons.lock, "Password", _controller.passwordController, isPassword: true),
                  const SizedBox(height: 10),
                  _buildInputField(Icons.lock, "Confirm password", _controller.confirmPasswordController, isPassword: true),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.pinkAccent)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          ),
                          onPressed: () => _controller.registerUser(context, _setLoadingState),
                          child: const Text("SIGN UP →", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
