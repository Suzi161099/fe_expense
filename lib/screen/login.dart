// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home.dart';
// import 'signup.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> loginUser() async {
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showMessage("Vui lòng nhập đầy đủ thông tin", isError: true);
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final url = Uri.parse("http://10.0.2.2:3000/api/auth/login"); // Cập nhật cổng theo backend
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200 && responseData["success"] == true) {
//         String token = responseData["token"];

//         try {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString("token", token); // Lưu token vào local storage
//         } catch (e) {
//           _showMessage("Lỗi lưu trữ dữ liệu!", isError: true);
//           return;
//         }

//         _showMessage("Đăng nhập thành công!", isError: false);
//         Future.delayed(const Duration(seconds: 1), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         });
//       } else {
//         _showMessage(responseData["message"] ?? "Sai email hoặc mật khẩu", isError: true);
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
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.pink.shade700, Colors.black],
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Log in",
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Please sign in to continue",
//                   style: TextStyle(fontSize: 16, color: Colors.white70),
//                 ),
//                 const SizedBox(height: 32),
//                 _buildTextField(icon: Icons.email, hintText: "Email", controller: _emailController),
//                 const SizedBox(height: 16),
//                 _buildTextField(icon: Icons.lock, hintText: "Password", controller: _passwordController, isPassword: true),
//                 const SizedBox(height: 8),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       "FORGOT?",
//                       style: TextStyle(color: Colors.pink.shade300, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 isLoading
//                     ? const CircularProgressIndicator(color: Colors.pinkAccent)
//                     : ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                           backgroundColor: Colors.pinkAccent,
//                         ),
//                         onPressed: loginUser,
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "LOGIN",
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 8),
//                             Icon(Icons.arrow_right_alt),
//                           ],
//                         ),
//                       ),
//                 const SizedBox(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Don't have an account? ",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const SignUpScreen()),
//                         );
//                       },
//                       child: const Text(
//                         "Sign up",
//                         style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required IconData icon,
//     required String hintText,
//     required TextEditingController controller,
//     bool isPassword = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white10,
//         prefixIcon: Icon(icon, color: Colors.white70),
//         hintText: hintText,
//         hintStyle: const TextStyle(color: Colors.white70),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: const TextStyle(color: Colors.white),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'signup.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  bool isLoading = false;

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade700, Colors.black],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Log in",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please sign in to continue",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 32),
                _buildTextField(icon: Icons.email, hintText: "Email", controller: _controller.emailController),
                const SizedBox(height: 16),
                _buildTextField(icon: Icons.lock, hintText: "Password", controller: _controller.passwordController, isPassword: true),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "FORGOT?",
                      style: TextStyle(color: Colors.pink.shade300, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                isLoading
                    ? const CircularProgressIndicator(color: Colors.pinkAccent)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.pinkAccent,
                        ),
                        onPressed: () => _controller.loginUser(context, setLoading),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "LOGIN",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_right_alt),
                          ],
                        ),
                      ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white10,
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

