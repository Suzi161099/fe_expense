import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInputPage extends StatefulWidget {
  const VoiceInputPage({super.key});

  @override
  _VoiceInputPageState createState() => _VoiceInputPageState();
}

class _VoiceInputPageState extends State<VoiceInputPage> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _currentField = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _startListening(String field) async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _currentField = field;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          switch (field) {
            case "store":
              _storeNameController.text = result.recognizedWords;
              break;
            case "amount":
              _amountController.text = result.recognizedWords;
              break;
            case "description":
              _descriptionController.text = result.recognizedWords;
              break;
            case "date":
              _dateController.text = result.recognizedWords;
              break;
          }
        });
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  Widget _buildVoiceInputField(String label, TextEditingController controller, String field) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade900,
        title: const Text("Thêm Chi Tiêu", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.mic,
                  size: 50,
                  color: _isListening ? Colors.red : Colors.white,
                ),
                onPressed: () => _isListening ? _stopListening() : _startListening("store"),
              ),
            ),
            const SizedBox(height: 20),
            _buildVoiceInputField("Tên cửa hàng", _storeNameController, "store"),
            const SizedBox(height: 10),
            _buildVoiceInputField("Số tiền", _amountController, "amount"),
            const SizedBox(height: 10),
            _buildVoiceInputField("Mô tả", _descriptionController, "description"),
            const SizedBox(height: 10),
            _buildVoiceInputField("Ngày", _dateController, "date"),
          ],
        ),
      ),
    );
  }
}