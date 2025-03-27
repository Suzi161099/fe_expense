// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:fe_expense/controllers/manual_input_controller.dart';
// import 'addexpensecontroller_test.mocks.dart';

// @GenerateMocks([http.Client])
// void main() {
//    late ManualInputController manualInputController;
//   late MockClient mockHttpClient;

//   setUp(() {

//     mockHttpClient = MockClient();

  
//     manualInputController = ManualInputController();
//   });
//   tearDown(() {
//     manualInputController.dateController.dispose();
//     manualInputController.merchantController.dispose();
//     manualInputController.amountController.dispose();
//     manualInputController.descriptionController.dispose();
//   });

//   testWidgets("Thông tin không hợp lệ - Hiển thị SnackBar", (WidgetTester tester) async {
//     manualInputController.merchantController.text = "";
//     manualInputController.amountController.text = "0";

//     await tester.pumpWidget(MaterialApp(
//       home: Scaffold(
//         body: Builder(
//           builder: (context) {
//             return ElevatedButton(
//               onPressed: () => manualInputController.saveExpense(context),
//               child: const Text("Lưu"),
//             );
//           },
//         ),
//       ),
//     ));

//     await tester.tap(find.text("Lưu"));
//     await tester.pump();

//     expect(find.text("Vui lòng điền đầy đủ thông tin"), findsOneWidget);
//   });

//   testWidgets("Lưu chi tiêu thành công", (WidgetTester tester) async {
//     manualInputController.merchantController.text = "Coffee Shop";
//     manualInputController.amountController.text = "50.5";
//     manualInputController.descriptionController.text = "Cà phê sáng";

//     final mockDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
//     manualInputController.dateController.text = mockDate;

//     when(mockHttpClient.post(
//       any,
//       headers: anyNamed("headers"),
//       body: anyNamed("body"),
//     )).thenAnswer((_) async => http.Response(jsonEncode({"message": "Success"}), 201));

//     await tester.pumpWidget(MaterialApp(
//       home: Scaffold(
//         body: Builder(
//           builder: (context) {
//             return ElevatedButton(
//               onPressed: () => manualInputController.saveExpense(context),
//               child: const Text("Lưu"),
//             );
//           },
//         ),
//       ),
//     ));

//     await tester.tap(find.text("Lưu"));
//     await tester.pump();

//     expect(find.text("Chi tiêu đã được lưu thành công"), findsOneWidget);
//   });

//   testWidgets("Lưu chi tiêu thất bại - Lỗi từ server", (WidgetTester tester) async {
//     manualInputController.merchantController.text = "Shopping";
//     manualInputController.amountController.text = "200";

//     when(mockHttpClient.post(
//       any,
//       headers: anyNamed("headers"),
//       body: anyNamed("body"),
//     )).thenAnswer((_) async => http.Response("Lỗi", 400));

//     await tester.pumpWidget(MaterialApp(
//       home: Scaffold(
//         body: Builder(
//           builder: (context) {
//             return ElevatedButton(
//               onPressed: () => manualInputController.saveExpense(context),
//               child: const Text("Lưu"),
//             );
//           },
//         ),
//       ),
//     ));

//     await tester.tap(find.text("Lưu"));
//     await tester.pump();

//     expect(find.textContaining("Lỗi khi lưu chi tiêu"), findsOneWidget);
//   });

//   testWidgets("Lỗi kết nối đến server", (WidgetTester tester) async {
//   // Khởi tạo controller
//   final manualInputController = ManualInputController();

//   // Nhập giá trị
//   manualInputController.merchantController.text = "Grocery";
//   manualInputController.amountController.text = "100";

//   // Giả lập lỗi kết nối server
//   when(mockHttpClient.post(
//     any,
//     headers: anyNamed("headers"),
//     body: anyNamed("body"),
//   )).thenThrow(Exception("Không thể kết nối đến server"));

//   // Render giao diện
//   await tester.pumpWidget(MaterialApp(
//     home: Scaffold(
//       body: Builder(
//         builder: (context) {
//           return ElevatedButton(
//             onPressed: () => manualInputController.saveExpense(context),
//             child: const Text("Lưu"),
//           );
//         },
//       ),
//     ),
//   ));

//   // Nhấn nút "Lưu"
//   await tester.tap(find.text("Lưu"));
//   await tester.pumpAndSettle(); // Đợi UI cập nhật đầy đủ

//   // Kiểm tra nếu thông báo lỗi hiển thị
//   expect(find.text("Không thể kết nối đến server"), findsOneWidget);
// });



// }

// import 'dart:convert';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:http/http.dart' as http;
// import 'package:fe_expense/controllers/manual_input_controller.dart';
// import 'addexpensecontroller_test.mocks.dart';

// @GenerateMocks([http.Client])
// void main() {
//   late ManualInputController manualInputController;
//   late MockClient mockHttpClient;

//   setUp(() {
//     mockHttpClient = MockClient();
//     manualInputController = ManualInputController();
//   });

//   tearDown(() {
//     manualInputController.dateController.dispose();
//     manualInputController.merchantController.dispose();
//     manualInputController.amountController.dispose();
//     manualInputController.descriptionController.dispose();
//   });

//   /// **Test 1: Trả về lỗi khi nhập thiếu thông tin**
//   test("Lỗi khi merchant hoặc amount trống", () async {
//     manualInputController.merchantController.text = "";
//     manualInputController.amountController.text = "0";

//     var result = await manualInputController.saveExpense();

//     expect(result, "Vui lòng điền đầy đủ thông tin");
//   });

//   /// **Test 2: Lưu chi tiêu thành công**
//   test("Lưu chi tiêu thành công", () async {
//     manualInputController.merchantController.text = "Coffee Shop";
//     manualInputController.amountController.text = "50.5";
//     manualInputController.descriptionController.text = "Cà phê sáng";
    
//     when(mockHttpClient.post(
//       any,
//       headers: anyNamed("headers"),
//       body: anyNamed("body"),
//     )).thenAnswer((_) async => http.Response(jsonEncode({"message": "Success"}), 201));

//     var result = await manualInputController.saveExpense();

//     expect(result, "Chi tiêu đã được lưu thành công");
//   });

//   /// **Test 3: Lỗi từ server khi lưu chi tiêu**
//   test("Lỗi khi lưu chi tiêu do server", () async {
//     manualInputController.merchantController.text = "Shopping";
//     manualInputController.amountController.text = "200";

//     when(mockHttpClient.post(
//       any,
//       headers: anyNamed("headers"),
//       body: anyNamed("body"),
//     )).thenAnswer((_) async => http.Response("Lỗi", 400));

//     var result = await manualInputController.saveExpense();

//     expect(result, "Lỗi khi lưu chi tiêu");
//   });

//   /// **Test 4: Lỗi kết nối đến server**
//   test("Lỗi kết nối đến server", () async {
//     manualInputController.merchantController.text = "Grocery";
//     manualInputController.amountController.text = "100";

//     when(mockHttpClient.post(
//       any,
//       headers: anyNamed("headers"),
//       body: anyNamed("body"),
//     )).thenThrow(Exception("Không thể kết nối đến server"));

//     var result = await manualInputController.saveExpense();

//     expect(result, "Không thể kết nối đến server");
//   });
// }




import 'package:flutter_test/flutter_test.dart'; 
import 'package:mockito/annotations.dart'; 
import 'package:mockito/mockito.dart'; 
import 'package:fe_expense/controllers/manual_input_controller.dart'; 
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

import 'addexpensecontroller_test.mocks.dart'; 

@GenerateMocks([http.Client]) 
void main() {
  late ManualInputController controller; 
  late MockClient mockClient; 

  setUp(() {
    mockClient = MockClient(); 
    controller = ManualInputController(client: mockClient);
  });

  tearDown(() {
    controller.dispose(); 
  });

  // 🛠️ Test 1: Kiểm tra khi không nhập đủ thông tin
  testWidgets('Không nhập đủ thông tin hiển thị cảnh báo', (WidgetTester tester) async {
    controller.merchantController.text = ''; 
    controller.amountController.text = '0'; 

    await tester.pumpWidget(_buildTestApp(controller)); 
    await tester.tap(find.text("Save Expense")); 
    await tester.pumpAndSettle(); 

    expect(find.text("Vui lòng điền đầy đủ thông tin"), findsOneWidget); 
  });

  // 🛠️ Test 2: Kiểm tra khi gửi dữ liệu thành công (HTTP 201)
  testWidgets('Gửi dữ liệu thành công (201) hiển thị thông báo thành công', (WidgetTester tester) async {
    controller.merchantController.text = 'Shop ABC'; 
    controller.amountController.text = '150.5'; 

    
    when(mockClient.post(
      Uri.parse('http://10.21.7.210:3000/api/expense/'), 
      headers: {'Content-Type': 'application/json'}, 
      body: anyNamed('body'), 
    )).thenAnswer((_) async => http.Response('', 201)); 

    await tester.pumpWidget(_buildTestApp(controller)); 
    await tester.tap(find.text("Save Expense")); 
    await tester.pumpAndSettle(); 

    expect(find.text("Chi tiêu đã được lưu thành công"), findsOneWidget); 
  });

  // 🛠️ Test 3: Kiểm tra khi server trả về lỗi (HTTP 400)
  testWidgets('Lỗi server trả về mã khác 201 hiển thị lỗi', (WidgetTester tester) async {
    controller.merchantController.text = 'Shop ABC'; 
    controller.amountController.text = '150.5';

    // Mock HTTP request trả về status 400 (Bad Request)
    when(mockClient.post(
      Uri.parse('http://10.21.7.210:3000/api/expense/'),
      headers: {'Content-Type': 'application/json'},
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('', 400)); 

    await tester.pumpWidget(_buildTestApp(controller)) ;
    await tester.tap(find.text("Save Expense"));
    await tester.pumpAndSettle(); 

    expect(find.text("Lỗi khi lưu chi tiêu: 400"), findsOneWidget); 
  });

  // 🛠️ Test 4: Kiểm tra lỗi mạng khi gửi request
  testWidgets('Lỗi mạng khi gửi request hiển thị thông báo lỗi', (WidgetTester tester) async {
    controller.merchantController.text = 'Shop ABC'; 
    controller.amountController.text = '150.5'; 

    // Mock HTTP request bị lỗi mạng (throw Exception)
    when(mockClient.post(
      Uri.parse('http://10.21.7.210:3000/api/expense/'),
      headers: {'Content-Type': 'application/json'},
      body: anyNamed('body'),
    )).thenThrow(Exception('No Internet')); 

    await tester.pumpWidget(_buildTestApp(controller)); 
    await tester.tap(find.text("Save Expense"));
    await tester.pumpAndSettle(); 

    expect(find.text("Không thể kết nối đến server"), findsOneWidget); 
  });
}

// 🏗️ Hàm tạo UI test để có `BuildContext`
Widget _buildTestApp(ManualInputController controller) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: ElevatedButton(
              onPressed: () => controller.saveExpense(context), 
              child: const Text("Save Expense"), 
            ),
          );
        },
      ),
    ),
  );
}


