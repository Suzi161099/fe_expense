import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_expense/screen/home.dart';
import 'package:fe_expense/screen/login.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final http.Client httpClient; // Dependency Injection
  bool isLoading = false;

  LoginController({http.Client? httpClient}) : httpClient = httpClient ?? http.Client(); // Sử dụng httpClient nếu có, nếu không sẽ tạo mặc định

  Future<void> loginUser(BuildContext context, Function(bool) setLoading) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage(context, "Vui lòng nhập đầy đủ thông tin", isError: true);
      return;
    }

    setLoading(true); // Bật trạng thái loading

    try {
      final url = Uri.parse("http://10.0.2.2:3000/api/auth/login"); 
      final response = await httpClient.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["success"] == true) {
        String token = responseData["token"];
         String userId = responseData["user"]["id"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token); 
        await prefs.setString("userId", userId);
        print("Response: $responseData");
        _showMessage(context, "Đăng nhập thành công!", isError: false);

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } else {
        _showMessage(context, responseData["message"] ?? "Sai email hoặc mật khẩu", isError: true);
      }
    } catch (e) {
      _showMessage(context, "Lỗi kết nối đến server!", isError: true);
    } finally {
      setLoading(false); // Tắt trạng thái loading
    }
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
