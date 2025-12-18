import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chào bạn,",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              "OVERVIEW",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                final items = [
                  {
                    'icon': Icons.monitor_weight_outlined,
                    'title': 'BMI',
                    'cat': 'Sức khỏe',
                  },
                  {
                    'icon': Icons.palette_outlined,
                    'title': 'Màu nền',
                    'cat': 'Giao diện',
                  },
                  {
                    'icon': Icons.timer_outlined,
                    'title': 'Đếm ngược',
                    'cat': 'Công cụ',
                  },
                  {
                    'icon': Icons.shopping_bag_outlined,
                    'title': 'Cửa hàng',
                    'cat': 'Mua sắm',
                  },
                  {
                    'icon': Icons.article_outlined,
                    'title': 'Tin tức',
                    'cat': 'Xã hội',
                  },
                  {
                    'icon': Icons.chat_bubble_outline,
                    'title': 'Phản hồi',
                    'cat': 'Liên hệ',
                  },
                  {
                    'icon': Icons.hotel_outlined,
                    'title': 'Đặt chỗ',
                    'cat': 'Du lịch',
                  },
                  {
                    'icon': Icons.person_outline_rounded,
                    'title': 'Tài khoản',
                    'cat': 'Cá nhân',
                  },
                ];

                int row = index ~/ 2;
                int col = index % 2;
                bool isBlackCard = (row + col) % 2 != 0;

                return _buildGridItem(
                  items[index]['icon'] as IconData,
                  items[index]['title'] as String,
                  items[index]['cat'] as String,
                  isBlackCard,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
    IconData icon,
    String title,
    String category,
    bool isBlackCard,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isBlackCard ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isBlackCard ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isBlackCard ? Colors.black : Colors.white,
                size: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: isBlackCard ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    color: isBlackCard ? Colors.white60 : Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
