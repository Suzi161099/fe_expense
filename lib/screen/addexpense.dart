// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AddExpenseScreen extends StatefulWidget {
//   const AddExpenseScreen({super.key});

//   @override
//   _AddExpenseScreenState createState() => _AddExpenseScreenState();
// }

// class _AddExpenseScreenState extends State<AddExpenseScreen> {
//   String selectedInputMethod = "Manual input";
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController merchantController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   String selectedCategory = "Food";
//   String selectedCurrency = "VND";

//   @override
//   void initState() {
//     super.initState();
//     dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
//   }

//   void _saveExpense() {
//     if (merchantController.text.isEmpty || amountController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
//       );
//       return;
//     }
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Lưu chi tiêu thành công!")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Thêm chi tiêu"),
//         centerTitle: true,
//         backgroundColor: Colors.pink.shade900,
//         foregroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("How do you want to input your expense?",
//                   style: TextStyle(fontSize: 16, color: Colors.white)),
//               _buildRadioOption("Manual input"),
//               if (selectedInputMethod == "Manual input") _buildManualInputFields(),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveExpense,
//                 child: const Text("Save Expense"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRadioOption(String method) {
//     return ListTile(
//       title: Text(method, style: const TextStyle(color: Colors.white)),
//       leading: Radio(
//         value: method,
//         groupValue: selectedInputMethod,
//         onChanged: (value) {
//           setState(() {
//             selectedInputMethod = value.toString();
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildManualInputFields() {
//     return Column(
//       children: [
//         _buildTextField(merchantController, "Merchant Name"),
//         _buildTextField(amountController, "Amount", prefixText: "$selectedCurrency "),
//         _buildDropdownCategory(),
//         _buildDatePickerField(),
//         _buildTextField(descriptionController, "Description"),
//       ],
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, {String prefixText = ""}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.white),
//           prefixText: prefixText,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           filled: true,
//           fillColor: Colors.grey.shade900,
//         ),
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildDatePickerField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: dateController,
//         readOnly: true,
//         decoration: InputDecoration(
//           labelText: "Date",
//           labelStyle: const TextStyle(color: Colors.white),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           filled: true,
//           fillColor: Colors.grey.shade900,
//         ),
//         style: const TextStyle(color: Colors.white),
//         onTap: () async {
//           DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2101),
//           );
//           if (pickedDate != null) {
//             setState(() {
//               dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//             });
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildDropdownCategory() {
//     return DropdownButtonFormField<String>(
//       value: selectedCategory,
//       dropdownColor: Colors.black,
//       items: ["Food", "Transport", "Entertainment", "Other"]
//           .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: Colors.white))))
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           selectedCategory = value!;
//         });
//       },
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String selectedInputMethod = "Manual input";
  final TextEditingController dateController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "Food";

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Future<void> _saveExpense() async {
    if (merchantController.text.isEmpty || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    final expenseData = {
      "merchant": merchantController.text,
      "amount": double.parse(amountController.text),
      "category": selectedCategory,
      "date": DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dateController.text)),
      "description": descriptionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/expenses"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(expenseData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lưu chi tiêu thành công!")),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()), // Thay HomeScreen bằng màn hình home của bạn
            (route) => false, // Xóa tất cả các route trước đó
          );
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm chi tiêu"),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("How do you want to input your expense?",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              _buildRadioOption("Manual input"),
              if (selectedInputMethod == "Manual input") _buildManualInputFields(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String method) {
    return ListTile(
      title: Text(method, style: const TextStyle(color: Colors.white)),
      leading: Radio(
        value: method,
        groupValue: selectedInputMethod,
        onChanged: (value) {
          setState(() {
            selectedInputMethod = value.toString();
          });
        },
      ),
    );
  }

  Widget _buildManualInputFields() {
    return Column(
      children: [
        _buildTextField(merchantController, "Merchant Name"),
        _buildTextField(amountController, "Amount"),
        _buildDropdownCategory(),
        _buildDatePickerField(),
        _buildTextField(descriptionController, "Description"),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: label == "Amount" ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: dateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date",
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
        style: const TextStyle(color: Colors.white),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  Widget _buildDropdownCategory() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      dropdownColor: Colors.black,
      items: ["Food", "Transport", "Entertainment", "Other"]
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: Colors.white))))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
      },
    );
  }
}
