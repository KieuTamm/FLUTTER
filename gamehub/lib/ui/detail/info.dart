import 'package:flutter/material.dart';
import '../../../models/game.dart';

class InfoTab extends StatelessWidget {
  final Game game;

  const InfoTab({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "About",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Detailed information about ${game.name}...",
          style: const TextStyle(height: 1.5),
        ),
        const SizedBox(height: 20),
        _buildRow(Icons.calendar_today, "Released", game.released ?? "TBA"),
        _buildRow(Icons.star, "Rating", "${game.rating}/5"),
      ],
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
