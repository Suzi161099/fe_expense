import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fe_expense/screen/home.dart';

class AddIncomeController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedSource = "Salary";
  bool isLoading = false;

  AddIncomeController() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Future<void> saveIncome(BuildContext context, Function setLoading) async {
    final String apiUrl = "http://10.0.2.2:3000/api/income";

    if (amountController.text.isEmpty || dateController.text.isEmpty || selectedSource.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
      );
      return;
    }

    setLoading(true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": double.parse(amountController.text),
          "source": selectedSource,
          "date": DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dateController.text)),
          "description": descriptionController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thêm thu nhập thành công!")),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"] ?? "Lỗi không xác định!")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi kết nối đến máy chủ!")),
      );
    } finally {
      setLoading(false);
    }
  }
}
