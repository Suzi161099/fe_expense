import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _imageFile;

  // Hàm mở camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Hàm mở thư viện ảnh
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn ảnh')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hiển thị ảnh đã chọn (nếu có)
          _imageFile != null
              ? Image.file(_imageFile!, height: 200)
              : const Icon(Icons.image, size: 100, color: Colors.grey),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nút mở camera
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _pickImageFromCamera,
                    child: Column(
                      children: [
                        const Icon(Icons.camera_alt, size: 80, color: Colors.blue),
                        const SizedBox(height: 8),
                        const Text("Camera", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 50),
              // Nút mở thư viện ảnh
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _pickImageFromGallery,
                    child: Column(
                      children: [
                        const Icon(Icons.photo_library, size: 80, color: Colors.green),
                        const SizedBox(height: 8),
                        const Text("Thư viện", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:fe_expense/controllers/cloud.dart';
// import 'dart:io';
// import 'package:fe_expense/screen/scan.dart';

// class ScanPage extends StatefulWidget {
//   final String? title;
//   const ScanPage({Key? key, this.title}) : super(key: key);

//   @override
//   _ScanPageState createState() => _ScanPageState();
// }

// class _ScanPageState extends State<ScanPage> {
//   File? _image;
//   Uint8List? _imageBytes;
//   String? _imageName;
//   String _extractedText = '';
//   final picker = ImagePicker();
//   CloudApi? api;
//   bool isUploaded = false;
//   bool loading = false;
//   String? imageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _initializeApi();
//   }

//   Future<void> _initializeApi() async {
//     try {
//       final json = await rootBundle.loadString('assets/key/credentials.json');
//       api = CloudApi(json);
//     } catch (e) {
//       debugPrint('Lỗi tải thông tin xác thực: $e');
//     }
//   }

//   Future<void> _getImage() async {
//     try {
//       final source = await showModalBottomSheet<ImageSource>(
//         context: context,
//         builder: (context) => Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildSourceOption(Icons.camera, 'Chụp ảnh', ImageSource.camera),
//             _buildSourceOption(
//                 Icons.photo_library, 'Chọn từ thư viện', ImageSource.gallery),
//           ],
//         ),
//       );

//       if (source != null) {
//         final pickedFile = await picker.pickImage(source: source);
//         if (pickedFile != null) {
//           setState(() {
//             _image = File(pickedFile.path);
//             _imageBytes = _image?.readAsBytesSync();
//             _imageName = _image?.path.split('/').last;
//             isUploaded = false;
//             _extractedText = '';
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Lỗi chọn ảnh: $e');
//     }
//   }

//   ListTile _buildSourceOption(IconData icon, String text, ImageSource source) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(text),
//       onTap: () => Navigator.pop(context, source),
//     );
//   }

//   Future<void> _saveImage() async {
//     if (_imageBytes == null || _imageName == null) {
//       _showSnackBar('Vui lòng chọn ảnh trước khi tải lên.');
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       imageUrl = await api!.saveAndGetUrl(_imageName!, _imageBytes!);
//       _showSnackBar('Tải ảnh lên thành công!');
//       setState(() => isUploaded = true);
//     } catch (e) {
//       _showSnackBar('Lỗi tải ảnh lên. Vui lòng thử lại.');
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   String removeDiacritics(String text) {
//     return text
//         .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]', multiLine: true), 'a')
//         .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]', multiLine: true), 'e')
//         .replaceAll(RegExp(r'[ìíịỉĩ]', multiLine: true), 'i')
//         .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởẽ]', multiLine: true), 'o')
//         .replaceAll(RegExp(r'[ùúụủũưừứựửữ]', multiLine: true), 'u')
//         .replaceAll(RegExp(r'[ỳýỵỷỹ]', multiLine: true), 'y')
//         .replaceAll(RegExp(r'[đ]', multiLine: true), 'd')
//         .replaceAll(RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]', multiLine: true), 'A')
//         .replaceAll(RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]', multiLine: true), 'E')
//         .replaceAll(RegExp(r'[ÌÍỊỈĨ]', multiLine: true), 'I')
//         .replaceAll(RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]', multiLine: true), 'O')
//         .replaceAll(RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]', multiLine: true), 'U')
//         .replaceAll(RegExp(r'[ỲÝỴỶỸ]', multiLine: true), 'Y')
//         .replaceAll(RegExp(r'[Đ]', multiLine: true), 'D');
//   }

//   String capitalizeFirstLetter(String text) {
//     return text.split(' ').map((word) {
//       if (word.isNotEmpty) {
//         return word[0].toUpperCase() + word.substring(1).toLowerCase();
//       }
//       return word;
//     }).join(' ');
//   }

//   String normalizeText(String text) {
//     String withoutDiacritics = removeDiacritics(text);
//     return capitalizeFirstLetter(withoutDiacritics);
//   }

//   String extractDate(String text) {
//     try {
//       String normalizedText = removeDiacritics(text.toLowerCase());
//       RegExpMatch? primaryDateMatch =
//           RegExp(r'ngày\s*(\d{1,2})\s*tháng\s*(\d{1,2})\s*năm\s*(\d{4})')
//               .firstMatch(normalizedText);
//       if (primaryDateMatch != null) {
//         String day = primaryDateMatch.group(1) ?? "01";
//         String month = primaryDateMatch.group(2) ?? "01";
//         String year = primaryDateMatch.group(3) ?? "1970";
//         return "${day.padLeft(2, '0')}/${month.padLeft(2, '0')}/$year";
//       }
//       RegExpMatch? secondaryDateMatch =
//           RegExp(r'(\d{2})-(\d{2})-(\d{4})').firstMatch(normalizedText);
//       if (secondaryDateMatch != null) {
//         String day = secondaryDateMatch.group(1) ?? "01";
//         String month = secondaryDateMatch.group(2) ?? "01";
//         String year = secondaryDateMatch.group(3) ?? "1970";
//         return "${day.padLeft(2, '0')}/${month.padLeft(2, '0')}/$year";
//       }

//       // Nếu không tìm thấy, trả về ngày hiện tại
//       DateTime currentDate = DateTime.now();
//       String currentDay = currentDate.day.toString().padLeft(2, '0');
//       String currentMonth = currentDate.month.toString().padLeft(2, '0');
//       String currentYear = currentDate.year.toString();
//       return "$currentDay/$currentMonth/$currentYear";
//     } catch (e) {
//       debugPrint('Lỗi khi tìm ngày: $e');
//       DateTime currentDate = DateTime.now();
//       String currentDay = currentDate.day.toString().padLeft(2, '0');
//       String currentMonth = currentDate.month.toString().padLeft(2, '0');
//       String currentYear = currentDate.year.toString();
//       return "$currentDay/$currentMonth/$currentYear";
//     }
//   }

//   Map<String, dynamic> parseInvoice(String text) {
//     try {
//       String normalizedText = removeDiacritics(text.toLowerCase());
//       String storeName = RegExp(r'^(.*?)\n', multiLine: true)
//               .firstMatch(normalizedText)
//               ?.group(1) ??
//           "Tên cửa hàng không xác định";

//       String date = extractDate(normalizedText);
//       String totalAmountMatch =
//           RegExp(r'(tiền mặt|total|tổng cộng|tổng giá trị|grand total|cộng \(total\))[\s]*([\d,.đd]+)',
//                       multiLine: true)
//                   .firstMatch(normalizedText)
//                   ?.group(2)
//                   ?.replaceAll(RegExp(r'[.,đd]'), '') ??
//               "0";

//       int totalAmount = int.tryParse(totalAmountMatch) ?? 0;

//       if (totalAmount == 0) {
//         String fallbackAmount = RegExp(r'\b\d{1,3}(?:\.\d{3})+\b')
//                 .firstMatch(normalizedText)
//                 ?.group(0)
//                 ?.replaceAll('.', '') ??
//             "0";
//         totalAmount = int.tryParse(fallbackAmount) ?? 0;
//       }

//       String description = RegExp(
//                   r'(phí học phần.*|cảm ơn quý khách.*|bảo hiểm thu hộ.*)',
//                   multiLine: true)
//               .firstMatch(normalizedText)
//               ?.group(0) ??
//           "";

//       RegExp itemsPattern =
//           RegExp(r'(\d+)\s+(.*?)\s+([\d,.đd]+)', multiLine: true);
//       List<Map<String, dynamic>> items = [];
//       for (RegExpMatch match in itemsPattern.allMatches(normalizedText)) {
//         int quantity = int.tryParse(match.group(1) ?? "0") ?? 0;
//         String name = match.group(2)?.trim() ?? "";
//         String priceString =
//             match.group(3)?.replaceAll(RegExp(r'[.,đd]'), '') ?? "0";
//         int price = int.tryParse(priceString) ?? 0;
//         items.add({"name": name, "quantity": quantity, "price": price});
//       }

//       String category = categorizeInvoice(items, totalAmount, storeName);

//       return {
//         "storeName": storeName,
//         "date": date,
//         "totalAmount": totalAmount,
//         "description": description,
//         "items": items,
//         "category": category,
//       };
//     } catch (e) {
//       debugPrint('Lỗi phân tích hóa đơn: $e');
//       return {
//         "storeName": "Lỗi",
//         "date": "Lỗi",
//         "totalAmount": 0,
//         "description": "Lỗi phân tích dữ liệu",
//         "items": [],
//         "category": "Lỗi",
//       };
//     }
//   }

//   String categorizeInvoice(
//       List<Map<String, dynamic>> items, int totalAmount, String storeName) {
//     List<String> foodKeywords = [
//       'cơm',
//       'mì',
//       'phở',
//       'bánh mì',
//       'chè',
//       'sữa chua'
//     ];
//     List<String> electronicsKeywords = ['laptop', 'phone', 'tv', 'máy tính'];
//     List<String> serviceKeywords = [
//       'dịch vụ',
//       'spa',
//       'thẩm mỹ',
//       'trường',
//       'đại học'
//     ];
//     List<String> clothingKeywords = ['áo', 'quần', 'váy', 'giày', 'túi'];
//     List<String> transportationKeywords = [
//       'vé',
//       'xe',
//       'tàu',
//       'máy bay',
//       'chuyến bay'
//     ];
//     List<String> foodStoreKeywords = [
//       'siêu thị',
//       'cửa hàng thực phẩm',
//       'gian hàng thực phẩm'
//     ];
//     List<String> electronicsStoreKeywords = [
//       'cửa hàng điện tử',
//       'trung tâm điện tử',
//       'máy tính'
//     ];
//     List<String> serviceStoreKeywords = [
//       'dịch vụ',
//       'spa',
//       'thẩm mỹ viện',
//       'trường',
//       'đại học',
//       'học phí'
//     ];
//     List<String> clothingStoreKeywords = [
//       'shop quần áo',
//       'thời trang',
//       'shop giày dép'
//     ];
//     List<String> transportationStoreKeywords = [
//       'vé tàu',
//       'vé máy bay',
//       'dịch vụ vận tải'
//     ];
//     String normalizedStoreName = removeDiacritics(storeName.toLowerCase());
//     if (foodStoreKeywords.any((keyword) => normalizedStoreName
//         .contains(removeDiacritics(keyword.toLowerCase())))) {
//       return 'Thực phẩm';
//     } else if (electronicsStoreKeywords.any((keyword) => normalizedStoreName
//         .contains(removeDiacritics(keyword.toLowerCase())))) {
//       return 'Điện tử';
//     } else if (serviceStoreKeywords.any((keyword) => normalizedStoreName
//         .contains(removeDiacritics(keyword.toLowerCase())))) {
//       return 'Dịch vụ';
//     } else if (clothingStoreKeywords.any((keyword) => normalizedStoreName
//         .contains(removeDiacritics(keyword.toLowerCase())))) {
//       return 'Thời trang';
//     } else if (transportationStoreKeywords.any((keyword) => normalizedStoreName
//         .contains(removeDiacritics(keyword.toLowerCase())))) {
//       return 'Vận chuyển';
//     }
//     for (var item in items) {
//       String name = removeDiacritics(item["name"]?.toLowerCase() ?? "");
//       if (foodKeywords.any((keyword) =>
//           name.contains(removeDiacritics(keyword.toLowerCase())))) {
//         return 'Thực phẩm';
//       } else if (electronicsKeywords.any((keyword) =>
//           name.contains(removeDiacritics(keyword.toLowerCase())))) {
//         return 'Điện tử';
//       } else if (serviceKeywords.any((keyword) =>
//           name.contains(removeDiacritics(keyword.toLowerCase())))) {
//         return 'Dịch vụ';
//       } else if (clothingKeywords.any((keyword) =>
//           name.contains(removeDiacritics(keyword.toLowerCase())))) {
//         return 'Thời trang';
//       } else if (transportationKeywords.any((keyword) =>
//           name.contains(removeDiacritics(keyword.toLowerCase())))) {
//         return 'Vận chuyển';
//       }
//     }

//     return 'Khác';
//   }

//   Future<void> _extractText() async {
//     if (_imageBytes == null) {
//       _showSnackBar('Chưa chọn hình ảnh để trích xuất văn bản.');
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       final resultJson = await api!.extractTextFromImage(_imageBytes!);
//       debugPrint('Kết quả JSON từ API: $resultJson');

//       final result = jsonDecode(resultJson);
//       if (result['status'] == 'success') {
//         String rawText = result['text'] ?? '';
//         debugPrint('Văn bản thô: $rawText');
//         final parsedInvoice = parseInvoice(rawText);
//         setState(() {
//           _extractedText = jsonEncode(parsedInvoice);
//         });
//       } else {
//         _showSnackBar(result['message'] ?? 'Lỗi khi trích xuất văn bản.');
//       }
//     } catch (e) {
//       debugPrint('Lỗi khi trích xuất văn bản: $e');
//       _showSnackBar('Lỗi khi trích xuất văn bản. Vui lòng thử lại.');
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? 'Tải lên Google Cloud'),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: _imageBytes == null
//                   ? Center(
//                       child: Text('Chưa chọn hình ảnh.',
//                           style: TextStyle(fontSize: 18, color: Colors.black)),
//                     )
//                   : _buildImagePreview(),
//             ),
//             const SizedBox(height: 16),
//             if (!loading && !isUploaded) _buildUploadButton(),
//             if (loading) const Center(child: CircularProgressIndicator()),
//             if (isUploaded && !loading) _buildPostUploadOptions(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getImage,
//         tooltip: 'Chọn hình ảnh',
//         child: const Icon(Icons.add_a_photo, color: Colors.white),
//         backgroundColor: Colors.black,
//       ),
//     );
//   }

//   Widget _buildImagePreview() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.black, width: 2),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Image.memory(_imageBytes!, fit: BoxFit.cover),
//       ),
//     );
//   }

//   Widget _buildUploadButton() {
//     return ElevatedButton.icon(
//       onPressed: _saveImage,
//       icon: const Icon(Icons.cloud_upload, color: Colors.white),
//       label: const Text('Tải lên Cloud', style: TextStyle(color: Colors.white)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black,
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//       ),
//     );
//   }

//   Widget _buildPostUploadOptions() {
//     Map<String, dynamic>? parsedData;

//     try {
//       if (_extractedText.isNotEmpty) {
//         parsedData = jsonDecode(_extractedText);
//       }
//     } catch (e) {
//       debugPrint('Lỗi khi phân tích JSON: $e');
//     }

//     String? storeName = parsedData?['storeName'];
//     String? date = parsedData?['date'];
//     int? totalAmount = parsedData?['totalAmount'];
//     String? category = parsedData?['category'];

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: _extractText,
//                 icon: const Icon(Icons.text_snippet, color: Colors.black),
//                 label: const Text(
//                   'Trích xuất văn bản',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     side: const BorderSide(color: Colors.black, width: 2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (storeName != null &&
//                       date != null &&
//                       totalAmount != null &&
//                       category != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ScanExpensePage(),
//                         settings: RouteSettings(
//                           arguments: {
//                             'storeName': storeName,
//                             'date': date,
//                             'totalAmount': totalAmount,
//                             'category': category,
//                             'imageUrl': imageUrl,
//                           },
//                         ),
//                       ),
//                     );
//                   } else {
//                     _showSnackBar(
//                         'Vui lòng đảm bảo tất cả dữ liệu cần thiết đã được nhập.');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     side: const BorderSide(color: Colors.black, width: 2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Tiếp tục',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (parsedData != null) ...[
//           const SizedBox(height: 16),
//           _buildInvoiceInfo(parsedData),
//         ] else if (_extractedText.isNotEmpty) ...[
//           const SizedBox(height: 16),
//           Text(
//             'Văn bản trích xuất không phải là định dạng JSON:',
//             style: const TextStyle(fontSize: 16, color: Colors.red),
//           ),
//           Text(_extractedText),
//         ],
//       ],
//     );
//   }

//   Widget _buildInvoiceInfo(Map<String, dynamic> data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Tên cửa hàng: ${data["storeName"]}',
//             style: const TextStyle(fontSize: 16)),
//         Text('Ngày: ${data["date"]}', style: const TextStyle(fontSize: 16)),
//         Text('Tổng số tiền: ${data["totalAmount"]}',
//             style: const TextStyle(fontSize: 16)),
//         Text('Danh mục: ${data["category"]}',
//             style: const TextStyle(fontSize: 16)),
//         const SizedBox(height: 16),
//         if (data["items"] != null && data["items"].isNotEmpty) ...[
//           const Text('Mặt hàng:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ...data["items"].map<Widget>((item) {
//             return Text(
//               '${item["quantity"]} x ${item["name"]} - ${item["price"]}',
//               style: const TextStyle(fontSize: 14),
//             );
//           }).toList(),
//         ],
//       ],
//     );
//   }
// }
