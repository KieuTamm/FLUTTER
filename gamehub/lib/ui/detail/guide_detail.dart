import 'package:flutter/material.dart';
import '../../models/guide.dart';

class GuideDetailsPage extends StatelessWidget {
  final Guide guide;

  const GuideDetailsPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(guide.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              guide.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "By ${guide.author} • ${guide.date.toString().split(' ')[0]}",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            Text(
              guide.content, // Sau này có thể dùng Widget render HTML nếu cần
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            // Giả lập nội dung dài
            const SizedBox(height: 16),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
