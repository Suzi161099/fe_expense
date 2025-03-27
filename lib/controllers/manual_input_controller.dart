import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManualInputController {
  final http.Client client;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "Food";

  ManualInputController({required this.client}) {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  void dispose() {
    dateController.dispose();
    merchantController.dispose();
    amountController.dispose();
    descriptionController.dispose();
  }

  Future<void> saveExpense(BuildContext context) async {
    final String merchant = merchantController.text.trim();
    final double? amount = double.tryParse(amountController.text.trim());
    final String description = descriptionController.text.trim();
    final String category = selectedCategory;
    final String dateText = dateController.text.trim();

    if (merchant.isEmpty || amount == null || amount <= 0 || dateText.isEmpty || category.isEmpty) {
      _showSnackbar(context, "Vui lòng điền đầy đủ thông tin");
      return;
    }

    DateTime parsedDate;
    try {
      parsedDate = DateFormat('dd/MM/yyyy').parse(dateText);
    } catch (e) {
      _showSnackbar(context, "Ngày không hợp lệ");
      return;
    }

    final Map<String, dynamic> expenseData = {
      'merchant': merchant,
      'amount': amount,
      'category': category,
      'date': parsedDate.toIso8601String(),
      'description': description,
    };

    final String url = 'http://10.21.7.210:3000/api/expense/';
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(expenseData),
      );

      if (response.statusCode == 201) {
        _showSnackbar(context, "Chi tiêu đã được lưu thành công");
        Navigator.pop(context);
      } else {
        _showSnackbar(context, "Lỗi khi lưu chi tiêu: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackbar(context, "Không thể kết nối đến server");
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
