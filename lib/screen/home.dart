import 'package:flutter/material.dart';
import 'addexpense.dart';
import 'addincome.dart';
import 'category.dart';
import 'profile.dart';
import 'login.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.pink.shade900,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản Lý Chi Tiêu", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BalanceCard(),
            const SizedBox(height: 20),
            const Expanded(child: _TransactionHistory()),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Đóng menu
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.pink.shade900, Colors.redAccent]),
            ),
            accountName: const Text("Huỳnh Hùng", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("geminihunghuynh@gmail.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.black),
            ),
          ),
          _buildDrawerItem(context, Icons.home, "Trang chủ", const MainScreen()),
          _buildDrawerItem(context, Icons.person, "Tài khoản", const ProfileScreen()),
          _buildDrawerItem(context, Icons.add_circle, "Thêm chi tiêu", const AddExpenseScreen()),
          _buildDrawerItem(context, Icons.attach_money, "Thêm thu nhập", const AddIncomeScreen()),
          _buildDrawerItem(context, Icons.category, "Danh mục", const CategoryScreen()),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Đăng xuất"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title),
      onTap: () => _navigateTo(context, page),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink.shade900, Colors.redAccent]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tổng số dư", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            "2.548.000 VND",
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Thu nhập", "1.840.000 VND", Colors.green),
              _buildStatItem("Chi tiêu", "-284.000 VND", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _TransactionHistory extends StatelessWidget {
  const _TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Lịch sử giao dịch", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: const [
              _TransactionItem(title: "Mua sắm", date: "Hôm nay", amount: "284.000 VND", color: Colors.green),
              _TransactionItem(title: "Sửa chữa", date: "Hôm nay", amount: "-284.000 VND", color: Colors.red),
              _TransactionItem(title: "Paypal", date: "Hôm nay", amount: "284.000 VND", color: Colors.green),
              _TransactionItem(title: "Youtube", date: "Hôm nay", amount: "-284.000 VND", color: Colors.red),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final Color color;

  const _TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.attach_money, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date, style: const TextStyle(color: Colors.grey)),
        trailing: Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
