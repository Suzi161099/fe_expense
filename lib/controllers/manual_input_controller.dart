import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManualInputController {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "Food";

  ManualInputController() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Future<void> saveExpense(BuildContext context) async {
    final String merchant = merchantController.text;
    final double amount = double.tryParse(amountController.text) ?? 0;
    final String description = descriptionController.text;
    final String category = selectedCategory;

    if (merchant.isEmpty || amount <= 0 || dateController.text.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
    String isoDate = parsedDate.toIso8601String();

    final Map<String, dynamic> expenseData = {
      'merchant': merchant,
      'amount': amount,
      'category': category,
      'date': isoDate,
      'description': description,
    };

    final String url = 'http://10.21.3.144:3000/api/expense/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(expenseData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chi tiêu đã được lưu thành công")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi lưu chi tiêu: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể kết nối đến server")),
      );
    }
  }
}
