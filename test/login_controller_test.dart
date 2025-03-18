import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fe_expense/controllers/login_controller.dart';
import 'package:fe_expense/screen/home.dart';
import 'package:fe_expense/screen/login.dart';

import 'login_controller_test.mocks.dart'; 

// Tạo mock class tự động
@GenerateMocks([http.Client])
void main() {
  late LoginController loginController;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    loginController = LoginController(httpClient: mockHttpClient);
    SharedPreferences.setMockInitialValues({}); // Khởi tạo mock SharedPreferences
  });

  tearDown(() {
    loginController.dispose();
  });

  test('Nhập email và password hợp lệ', () {
    loginController.emailController.text = "test@gmail.com";
    loginController.passwordController.text = "123456";

    expect(loginController.emailController.text, "test@gmail.com");
    expect(loginController.passwordController.text, "123456");
  });

  testWidgets('Đăng nhập thành công', (WidgetTester tester) async {
    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) async => http.Response(jsonEncode({"success": true, "token": "fake_token"}), 200));

    bool isLoading = false;
    void setLoading(bool value) => isLoading = value;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        loginController.loginUser(context, setLoading);
        return Container();
      },
    ))));

    final prefs = await SharedPreferences.getInstance();
    expect(await prefs.getString("token"), "fake_token");
  });

  testWidgets('Sai email hoặc password', (WidgetTester tester) async {
    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) async => http.Response(jsonEncode({"success": false, "message": "Sai thông tin đăng nhập"}), 401));

    bool isLoading = false;
    void setLoading(bool value) => isLoading = value;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        loginController.loginUser(context, setLoading);
        return Container();
      },
    ))));

    final prefs = await SharedPreferences.getInstance();
    expect(await prefs.getString("token"), isNull);
  });

  testWidgets('Lỗi kết nối server', (WidgetTester tester) async {
    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenThrow(Exception("Server không phản hồi"));

    bool isLoading = false;
    void setLoading(bool value) => isLoading = value;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        loginController.loginUser(context, setLoading);
        return Container();
      },
    ))));

    final prefs = await SharedPreferences.getInstance();
    expect(await prefs.getString("token"), isNull);
  });

  testWidgets('Đăng xuất', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", "fake_token");

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        loginController.signOut(context);
        return Container();
      },
    ))));

    expect(await prefs.getString("token"), isNull);
  });
}
