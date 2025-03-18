// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ManualInputScreen extends StatefulWidget {
//   const ManualInputScreen({super.key});

//   @override
//   _ManualInputScreenState createState() => _ManualInputScreenState();
// }

// class _ManualInputScreenState extends State<ManualInputScreen> {
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController merchantController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   String selectedCategory = "Food";

//   @override
//   void initState() {
//     super.initState();
//     dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
//               _buildTextField(merchantController, "Merchant Name"),
//               _buildTextField(amountController, "Amount"),
//               _buildDropdownCategory(),
//               _buildDatePickerField(),
//               _buildTextField(descriptionController, "Description"),
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

//   Widget _buildTextField(TextEditingController controller, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         keyboardType: label == "Amount" ? TextInputType.number : TextInputType.text,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.white),
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
//           .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: Colors.white)))).toList(),
//       onChanged: (value) {
//         setState(() {
//           selectedCategory = value!;
//         });
//       },
//     );
//   }

//   Future<void> _saveExpense() async {
//     final String merchant = merchantController.text;
//     final double amount = double.tryParse(amountController.text) ?? 0;
//     final String description = descriptionController.text;
//     final String category = selectedCategory;

//     if (merchant.isEmpty || amount <= 0 || dateController.text.isEmpty || category.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
//       );
//       return;
//     }

//     // Chuyển đổi ngày sang định dạng ISO 8601
//     DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
//     String isoDate = parsedDate.toIso8601String();

//     final Map<String, dynamic> expenseData = {
//       'merchant': merchant,
//       'amount': amount,
//       'category': category,
//       'date': isoDate, // Gửi ngày theo chuẩn ISO 8601
//       'description': description, 
//     };
//     print(expenseData);
//     final String url = 'http://172.0.0.223:3000/api/expense/'; // URL API của bạn
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(expenseData),
//       );
      
//       if (response.statusCode == 201) {
//         // Thành công
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Chi tiêu đã được lưu thành công")),
//         );
//         Navigator.pop(context);  
//       } else {
//         // Lỗi từ API
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi khi lưu chi tiêu: ${response.statusCode}")),
//         );
//        print("Data sending to API: ${json.encode(expenseData)}");

//       }
//     } catch (e) {
//       // Lỗi mạng hoặc khác
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Không thể kết nối đến server")),
//       );
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/manual_input_controller.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  _ManualInputScreenState createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final ManualInputController _controller = ManualInputController();

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
              _buildTextField(_controller.merchantController, "Merchant Name"),
              _buildTextField(_controller.amountController, "Amount"),
              _buildDropdownCategory(),
              _buildDatePickerField(),
              _buildTextField(_controller.descriptionController, "Description"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _controller.saveExpense(context),
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ),
      ),
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
        controller: _controller.dateController,
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
              _controller.dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  Widget _buildDropdownCategory() {
    return DropdownButtonFormField<String>(
      value: _controller.selectedCategory,
      dropdownColor: Colors.black,
      items: ["Food", "Transport", "Entertainment", "Other"]
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: Colors.white))))
          .toList(),
      onChanged: (value) {
        setState(() {
          _controller.selectedCategory = value!;
        });
      },
    );
  }
}
