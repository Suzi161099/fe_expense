// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'home.dart';

// class AddIncomeScreen extends StatefulWidget {
//   const AddIncomeScreen({super.key});

//   @override
//   _AddIncomeScreenState createState() => _AddIncomeScreenState();
// }

// class _AddIncomeScreenState extends State<AddIncomeScreen> {
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   String selectedSource = "Salary";
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
//   }

//   Future<void> _saveIncome() async {
//     final String apiUrl = "http://10.0.2.2:3000/api/income"; 

//     if (amountController.text.isEmpty || dateController.text.isEmpty || selectedSource.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "amount": double.parse(amountController.text),
//           "source": selectedSource,
//           "date": DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dateController.text)),
//           "description": descriptionController.text,
//         }),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Thêm thu nhập thành công!")),
//         );
//        Future.delayed(const Duration(seconds: 1), () {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//             (route) => false,
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(responseData["message"] ?? "Lỗi không xác định!")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Lỗi kết nối đến máy chủ!")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Thêm thu nhập"),
//         centerTitle: true,
//         backgroundColor: Colors.pink.shade900,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//               (route) => false,
//             );
//           },
//         ),
//       ),
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(amountController, "Số tiền", prefixText: "VND "),
//             const SizedBox(height: 10),
//             _buildDropdownSource(),
//             const SizedBox(height: 10),
//             _buildDatePickerField(),
//             const SizedBox(height: 10),
//             _buildTextField(descriptionController, "Mô tả (nếu có)"),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: isLoading ? null : _saveIncome,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink.shade700,
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Lưu thu nhập", style: TextStyle(color: Colors.white)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, {String prefixText = ""}) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixText: prefixText,
//         labelStyle: const TextStyle(color: Colors.white),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         filled: true,
//         fillColor: Colors.grey.shade900,
//       ),
//       style: const TextStyle(color: Colors.white),
//       keyboardType: prefixText.isNotEmpty ? TextInputType.number : TextInputType.text,
//     );
//   }

//   Widget _buildDatePickerField() {
//     return TextField(
//       controller: dateController,
//       decoration: InputDecoration(
//         labelText: "Chọn ngày",
//         labelStyle: const TextStyle(color: Colors.white),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         filled: true,
//         fillColor: Colors.grey.shade900,
//         suffixIcon: Icon(Icons.calendar_today, color: Colors.pink.shade700),
//       ),
//       style: const TextStyle(color: Colors.white),
//       readOnly: true,
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: DateTime(2100),
//         );
//         if (pickedDate != null) {
//           setState(() {
//             dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//           });
//         }
//       },
//     );
//   }

//   Widget _buildDropdownSource() {
//     return DropdownButtonFormField<String>(
//       value: selectedSource,
//       dropdownColor: Colors.grey.shade900,
//       items: ["Salary", "Bonus", "Investment", "Other"]
//           .map((source) => DropdownMenuItem(value: source, child: Text(source, style: TextStyle(color: Colors.white))))
//           .toList(),
//       onChanged: (value) => setState(() => selectedSource = value!),
//       decoration: InputDecoration(labelText: "Nguồn thu nhập"),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../controllers/add_income_controller.dart';
import 'package:intl/intl.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  late AddIncomeController _controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AddIncomeController();
  }

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm thu nhập"),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_controller.amountController, "Số tiền", prefixText: "VND "),
            const SizedBox(height: 10),
            _buildDropdownSource(),
            const SizedBox(height: 10),
            _buildDatePickerField(),
            const SizedBox(height: 10),
            _buildTextField(_controller.descriptionController, "Mô tả (nếu có)"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _controller.saveIncome(context, _setLoading),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Lưu thu nhập", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {String prefixText = ""}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade900,
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: prefixText.isNotEmpty ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _buildDatePickerField() {
    return TextField(
      controller: _controller.dateController,
      decoration: InputDecoration(
        labelText: "Chọn ngày",
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade900,
        suffixIcon: Icon(Icons.calendar_today, color: Colors.pink.shade700),
      ),
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            _controller.dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          });
        }
      },
    );
  }

  Widget _buildDropdownSource() {
    return DropdownButtonFormField<String>(
      value: _controller.selectedSource,
      dropdownColor: Colors.grey.shade900,
      items: ["Salary", "Bonus", "Investment", "Other"]
          .map((source) => DropdownMenuItem(value: source, child: Text(source, style: TextStyle(color: Colors.white))))
          .toList(),
      onChanged: (value) => setState(() => _controller.selectedSource = value!),
      decoration: InputDecoration(labelText: "Nguồn thu nhập"),
    );
  }
}
