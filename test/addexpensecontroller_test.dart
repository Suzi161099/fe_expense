import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:fe_expense/controllers/manual_input_controller.dart';
import 'addexpensecontroller_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
   late ManualInputController manualInputController;
  late MockClient mockHttpClient;

  setUp(() {

    mockHttpClient = MockClient();

  
    manualInputController = ManualInputController();
  });
  tearDown(() {
    manualInputController.dateController.dispose();
    manualInputController.merchantController.dispose();
    manualInputController.amountController.dispose();
    manualInputController.descriptionController.dispose();
  });

  testWidgets("Thông tin không hợp lệ - Hiển thị SnackBar", (WidgetTester tester) async {
    manualInputController.merchantController.text = "";
    manualInputController.amountController.text = "0";

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => manualInputController.saveExpense(context),
              child: const Text("Lưu"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Lưu"));
    await tester.pump();

    expect(find.text("Vui lòng điền đầy đủ thông tin"), findsOneWidget);
  });

  testWidgets("Lưu chi tiêu thành công", (WidgetTester tester) async {
    manualInputController.merchantController.text = "Coffee Shop";
    manualInputController.amountController.text = "50.5";
    manualInputController.descriptionController.text = "Cà phê sáng";

    final mockDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    manualInputController.dateController.text = mockDate;

    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) async => http.Response(jsonEncode({"message": "Success"}), 201));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => manualInputController.saveExpense(context),
              child: const Text("Lưu"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Lưu"));
    await tester.pump();

    expect(find.text("Chi tiêu đã được lưu thành công"), findsOneWidget);
  });

  testWidgets("Lưu chi tiêu thất bại - Lỗi từ server", (WidgetTester tester) async {
    manualInputController.merchantController.text = "Shopping";
    manualInputController.amountController.text = "200";

    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) async => http.Response("Lỗi", 400));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => manualInputController.saveExpense(context),
              child: const Text("Lưu"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Lưu"));
    await tester.pump();

    expect(find.textContaining("Lỗi khi lưu chi tiêu"), findsOneWidget);
  });

  testWidgets("Lỗi kết nối đến server", (WidgetTester tester) async {
    manualInputController.merchantController.text = "Grocery";
    manualInputController.amountController.text = "100";

    when(mockHttpClient.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenThrow(Exception("Không thể kết nối đến server"));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => manualInputController.saveExpense(context),
              child: const Text("Lưu"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Lưu"));
    await tester.pump();

    expect(find.text("Không thể kết nối đến server"), findsOneWidget);
  });
}
