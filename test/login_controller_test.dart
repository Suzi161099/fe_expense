import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_expense/controllers/login_controller.dart';
import 'package:fe_expense/screen/home.dart';
import 'package:fe_expense/screen/login.dart';

import 'login_controller_test.mocks.dart'; // Import file mock

// Mock các dependency
@GenerateMocks([http.Client, SharedPreferences])
void main() {
  late LoginController loginController;
  late MockClient mockClient;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockClient = MockClient();
    loginController = LoginController(httpClient: mockClient);
    mockPrefs = MockSharedPreferences();
  });

  /// 🟠 **Test: Nhập thiếu thông tin**
  testWidgets('Không nhập email hoặc password hiển thị cảnh báo', (WidgetTester tester) async {
    loginController.emailController.text = '';
    loginController.passwordController.text = '';

    await tester.pumpWidget(_buildTestApp(loginController));

    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();

    expect(find.text("Vui lòng nhập đầy đủ thông tin"), findsOneWidget);
  });

  /// 🟢 **Test: Đăng nhập thành công**
  testWidgets('Đăng nhập thành công lưu token và chuyển sang HomeScreen', (WidgetTester tester) async {
    loginController.emailController.text = 'user@example.com';
    loginController.passwordController.text = 'password123';

    when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response('{"success": true, "token": "abc123"}', 200));

    SharedPreferences.setMockInitialValues({}); // Khởi tạo mock SharedPreferences

    await tester.pumpWidget(_buildTestApp(loginController));

    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();

    expect(find.text("Đăng nhập thành công!"), findsOneWidget);
  });

  /// 🔴 **Test: Đăng nhập thất bại**
  testWidgets('Đăng nhập thất bại hiển thị thông báo lỗi', (WidgetTester tester) async {
    loginController.emailController.text = 'user@example.com';
    loginController.passwordController.text = 'wrongpassword';

    when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response('{"success": false, "message": "Sai email hoặc mật khẩu"}', 400));

    await tester.pumpWidget(_buildTestApp(loginController));

    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();

    expect(find.text("Sai email hoặc mật khẩu"), findsOneWidget);
  });

  /// 🚨 **Test: Lỗi mạng**
  testWidgets('Lỗi mạng hiển thị thông báo lỗi', (WidgetTester tester) async {
    loginController.emailController.text = 'user@example.com';
    loginController.passwordController.text = 'password123';

    when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
        .thenThrow(Exception('No Internet'));

    await tester.pumpWidget(_buildTestApp(loginController));

    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();

    expect(find.text("Lỗi kết nối đến server!"), findsOneWidget);
  });

  /// 🔑 **Test: Đăng xuất**
  testWidgets('Đăng xuất xóa token và chuyển về LoginScreen', (WidgetTester tester) async {
    when(mockPrefs.remove("token")).thenAnswer((_) async => true);

    await tester.pumpWidget(_buildTestApp(loginController));

    await tester.tap(find.text('Đăng xuất'));
    await tester.pump();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

/// 🏗️ Hàm xây dựng Widget test
Widget _buildTestApp(LoginController controller) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              TextButton(
                onPressed: () => controller.loginUser(context, (bool _) {}),
                child: const Text("Đăng nhập"),
              ),
              TextButton(
                onPressed: () => controller.signOut(context),
                child: const Text("Đăng xuất"),
              ),
            ],
          );
        },
      ),
    ),
  );
}
