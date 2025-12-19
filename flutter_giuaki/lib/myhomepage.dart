import 'package:flutter/material.dart';
import 'overview.dart';
import 'bmi.dart';
import 'change_colors.dart';
import 'countdown.dart';
import 'my_product.dart';
import 'feedback.dart';
import 'news_screen.dart';
import 'auth_screen.dart';
import 'booking.dart';
import 'profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  String _userName = "";

  final List<String> _titles = [
    "TỔNG QUAN",
    "BMI",
    "THỐNG KÊ",
    "BỘ ĐẾM GIÂY",
    "CỬA HÀNG",
    "TIN TỨC",
    "PHẢN HỒI",
    "ĐẶT CHỖ",
    "TÀI KHOẢN",
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onLoginSuccess(String name) {
    setState(() {
      _isLoggedIn = true;
      _userName = name.toUpperCase();
      _selectedIndex = 0;
    });
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _userName = "";
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        // SỬA TẠI ĐÂY: Nếu là trang Profile (index 8) thì ẩn tiêu đề chữ
        title: Text(
          _selectedIndex == 8 ? "" : _titles[_selectedIndex],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 14,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (!_isLoggedIn && _selectedIndex != 0) {
      return AuthScreen(onLoginSuccess: _onLoginSuccess);
    }

    switch (_selectedIndex) {
      case 0:
        return const OverviewScreen();
      case 1:
        return const BMIPage();
      case 2:
        return const ChangeColors();
      case 3:
        return const CountdownTimer();
      case 4:
        return const MyProduct();
      case 5:
        return const NewsGridScreen();
      case 6:
        return const FeedbackScreen();
      case 7:
        return const BookingScreen();
      case 8:
        return UserProfilePage(
          onLogout: _handleLogout,
          userName: _isLoggedIn ? _userName : "KHÁCH",
        );
      default:
        return const OverviewScreen();
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _onItemTapped(8);
              Navigator.pop(context);
            },
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 35,
                    child: Icon(
                      _isLoggedIn
                          ? Icons.face_rounded
                          : Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isLoggedIn ? _userName : "XIN CHÀO!",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDrawerItem("Tổng quan", Icons.grid_view_rounded, 0),
                _buildDrawerItem("Tính BMI", Icons.monitor_weight_outlined, 1),
                _buildDrawerItem("Đổi màu nền", Icons.palette_outlined, 2),
                _buildDrawerItem("Đếm ngược", Icons.timer_outlined, 3),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xFFEEEEEE)),
                ),
                _buildDrawerItem("Cửa hàng", Icons.shopping_bag_outlined, 4),
                _buildDrawerItem("Tin tức", Icons.article_outlined, 5),
                _buildDrawerItem("Phản hồi", Icons.chat_bubble_outline, 6),
                _buildDrawerItem("Đặt chỗ", Icons.hotel_outlined, 7),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: _isLoggedIn
                  ? OutlinedButton.icon(
                      onPressed: () {
                        _handleLogout();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        size: 18,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "ĐĂNG XUẤT",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        _onItemTapped(8);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.login_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "ĐĂNG NHẬP",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String label, IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
