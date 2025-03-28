import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:fe_expense/controllers/signup_controller.dart';
import 'package:fe_expense/screen/home.dart';

import 'signup_controller.mocks.dart';

// Tạo mock tự động
@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late SignUpController signUpController;
  late MockClient mockHttpClient;

  setUp(() async {

    mockHttpClient = MockClient();

 
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    signUpController = SignUpController();
  });

  tearDown(() {
    signUpController.nameController.dispose();
    signUpController.emailController.dispose();
    signUpController.passwordController.dispose();
    signUpController.confirmPasswordController.dispose();
  });

  test('Nhập thông tin hợp lệ', () {
    signUpController.nameController.text = "Test User";
    signUpController.emailController.text = "test@example.com";
    signUpController.passwordController.text = "password123";
    signUpController.confirmPasswordController.text = "password123";

    expect(signUpController.nameController.text, "Test User");
    expect(signUpController.emailController.text, "test@example.com");
    expect(signUpController.passwordController.text, "password123");
    expect(signUpController.confirmPasswordController.text, "password123");
  });

 testWidgets('Mật khẩu không khớp', (WidgetTester tester) async {
  signUpController.nameController.text = "Test User";
  signUpController.emailController.text = "test@example.com";
  signUpController.passwordController.text = "password123";
  signUpController.confirmPasswordController.text = "password456"; // Không khớp

  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () => signUpController.registerUser(context, (value) {}),
          child: const Text("Đăng ký"),
        );
      },
    )),
  ));

  // Nhấn nút "Đăng ký"
  await tester.tap(find.text("Đăng ký"));
  await tester.pump(); 

  // Kiểm tra SnackBar hiển thị thông báo "Mật khẩu không khớp"
  expect(find.text("Mật khẩu không khớp"), findsOneWidget);
});

 testWidgets('Đăng ký thành công', (WidgetTester tester) async {

  when(mockHttpClient.post(
    any,
    headers: anyNamed("headers"),
    body: anyNamed("body"),
  )).thenAnswer((_) async => http.Response(jsonEncode({"success": true, "token": "fake_token"}), 201));

  // Điền thông tin đăng ký
  signUpController.nameController.text = "Test User";
  signUpController.emailController.text = "test@example.com";
  signUpController.passwordController.text = "password123";
  signUpController.confirmPasswordController.text = "password123";

  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () => signUpController.registerUser(context, (value) {}),
          child: const Text("Đăng ký"),
        );
      },
    )),
  ));


  await tester.tap(find.text("Đăng ký"));
  await tester.pump();


  expect(find.text("Đăng ký thành công"), findsOneWidget);

  
  final prefs = await SharedPreferences.getInstance();
  expect(prefs.getString("token"), "fake_token");
});

  testWidgets('Đăng ký thất bại (email đã tồn tại)', (WidgetTester tester) async {
    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) async => http.Response(jsonEncode({"success": false, "message": "Email đã được sử dụng"}), 400));

    signUpController.nameController.text = "Test User";
    signUpController.emailController.text = "existing@example.com";
    signUpController.passwordController.text = "password123";
    signUpController.confirmPasswordController.text = "password123";

    bool isLoading = false;
    void setLoading(bool value) => isLoading = value;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        signUpController.registerUser(context, setLoading);
        return Container();
      },
    ))));

    final prefs = await SharedPreferences.getInstance();
    expect(await prefs.getString("token"), isNull); // Không lưu token khi thất bại
  });

  testWidgets('Lỗi kết nối server', (WidgetTester tester) async {
    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenThrow(Exception("Không thể kết nối đến server"));

    signUpController.nameController.text = "Test User";
    signUpController.emailController.text = "test@example.com";
    signUpController.passwordController.text = "password123";
    signUpController.confirmPasswordController.text = "password123";

    bool isLoading = false;
    void setLoading(bool value) => isLoading = value;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        signUpController.registerUser(context, setLoading);
        return Container();
      },
    ))));

    final prefs = await SharedPreferences.getInstance();
    expect(await prefs.getString("token"), isNull); // Không lưu token khi có lỗi server
  });
}
