// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:fe_expense/controllers/add_income_controller.dart';
// import 'package:fe_expense/screen/home.dart';

// import 'addincome_test.mocks.dart';

// @GenerateNiceMocks([MockSpec<http.Client>()])
// void main() {
//   late AddIncomeController addIncomeController;
//   late MockClient mockHttpClient;

//   setUp(() {
//     mockHttpClient = MockClient();
//     addIncomeController = AddIncomeController();
//   });

//   tearDown(() {
//     addIncomeController.amountController.dispose();
//     addIncomeController.dateController.dispose();
//     addIncomeController.descriptionController.dispose();
//   });

//   test('Khởi tạo giá trị mặc định', () {
//     expect(addIncomeController.dateController.text, DateFormat('dd/MM/yyyy').format(DateTime.now()));
//     expect(addIncomeController.selectedSource, "Salary");
//   });

//  testWidgets('Thông tin không đầy đủ - Hiển thị SnackBar', (WidgetTester tester) async {
//   // Gán giá trị rỗng
//   addIncomeController.amountController.text = "";
//   addIncomeController.dateController.text = "";

//   bool isLoading = false;
//   void setLoading(bool value) => isLoading = value;

//   await tester.pumpWidget(MaterialApp(
//     home: Scaffold(
//       body: Builder(
//         builder: (BuildContext context) {
//           return ElevatedButton(
//             onPressed: () => addIncomeController.saveIncome(context, setLoading),
//             child: const Text("Lưu"),
//           );
//         },
//       ),
//     ),
//   ));

//   // Nhấn nút để gọi saveIncome()
//   await tester.tap(find.text("Lưu"));
//   await tester.pump(); // Cho phép UI cập nhật

//   // Kiểm tra xem SnackBar có xuất hiện không
//   expect(find.text("Vui lòng nhập đầy đủ thông tin!"), findsOneWidget);
  
//   // Đảm bảo isLoading không thay đổi
//   expect(isLoading, false);
// });
//   testWidgets('Thêm thu nhập thành công', (WidgetTester tester) async {
//     when(mockHttpClient.post(
//       any,
//       headers: anyNamed("headers"),
//       body: anyNamed("body"),
//     )).thenAnswer((_) async => http.Response(jsonEncode({"message": "Success"}), 201));

//     addIncomeController.amountController.text = "5000";
//     addIncomeController.dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
//     addIncomeController.selectedSource = "Freelance";
//     addIncomeController.descriptionController.text = "Test income";

//     bool isLoading = false;
//     void setLoading(bool value) => isLoading = value;

//     await tester.pumpWidget(MaterialApp(
//       home: Scaffold(body: Builder(
//         builder: (BuildContext context) {
//           addIncomeController.saveIncome(context, setLoading);
//           return Container();
//         },
//       )),
//     ));

//     expect(isLoading, false);
//   });

//   testWidgets('Thêm thu nhập thất bại', (WidgetTester tester) async {
//     when(mockHttpClient.post(
//       any,
//       headers: anyNamed("headers"),
//       body: anyNamed("body"),
//     )).thenAnswer((_) async => http.Response(jsonEncode({"message": "Error"}), 400));

//     addIncomeController.amountController.text = "5000";
//     addIncomeController.dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
//     addIncomeController.selectedSource = "Freelance";
//     addIncomeController.descriptionController.text = "Test income";

//     bool isLoading = false;
//     void setLoading(bool value) => isLoading = value;

//     await tester.pumpWidget(MaterialApp(
//       home: Scaffold(body: Builder(
//         builder: (BuildContext context) {
//           addIncomeController.saveIncome(context, setLoading);
//           return Container();
//         },
//       )),
//     ));

//     expect(isLoading, false);
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fe_expense/screen/home.dart';
import 'package:fe_expense/controllers/add_income_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'addincome_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('AddIncomeController', () {
    late AddIncomeController controller;
    late MockClient mockClient;

    setUp(() {
      controller = AddIncomeController();
      mockClient = MockClient();
    });

    test('Initial values are set correctly', () {
      expect(controller.amountController.text, '');
      expect(controller.dateController.text.isNotEmpty, true);
      expect(controller.descriptionController.text, '');
      expect(controller.selectedSource, 'Salary');
      expect(controller.isLoading, false);
    });

    testWidgets('Shows snackbar when fields are empty', (WidgetTester tester) async {
      final mockContext = GlobalKey<ScaffoldMessengerState>();

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: mockContext,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    controller.saveIncome(context, (bool value) {});
                  },
                  child: Text('Test'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    test('Sends POST request successfully', () async {
      controller.amountController.text = '5000';
      controller.descriptionController.text = 'Bonus';

      when(mockClient.post(
        Uri.parse('http://10.0.2.2:3000/api/income'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode({'message': 'Success'}), 201));

      await controller.saveIncome(MockBuildContext(), (bool value) {});
      verify(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}

