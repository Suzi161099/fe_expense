import 'package:flutter/material.dart';
import 'home.dart';
import 'manualinput.dart';
import 'uploadfile.dart';
import 'voice.dart';
import 'scan.dart';
import 'scanexpensepage.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String selectedInputMethod = "";

  void _navigateToNextScreen() {
    if (selectedInputMethod == "Manual input") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ManualInputScreen()),
      );
    } else if (selectedInputMethod == "Voice input") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VoiceInputPage()),
      );
    } else if (selectedInputMethod == "Upload PDF") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UploadFileScreen()),
      );
    } else if (selectedInputMethod == "Scan receipt") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScanPage()), // Chuyển đến trang ScanScreen
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn phương thức nhập chi tiêu:",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),

            _buildRadioOption("Manual input"),
            _buildRadioOption("Voice input"),
            _buildRadioOption("Scan receipt"),
            _buildRadioOption("Upload PDF"),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: selectedInputMethod.isNotEmpty ? _navigateToNextScreen : null,
                child: const Text("Tiếp tục"),
              ),
            ),
          ],
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
}
