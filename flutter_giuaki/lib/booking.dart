import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildSearchHeader(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterItem(Icons.swap_vert, "Sắp xếp", hasDot: true),
                _buildFilterItem(Icons.tune, "Lọc"),
                _buildFilterItem(Icons.map_outlined, "Bản đồ"),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "757 chỗ nghỉ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildHotelCard(
                  "https://images.unsplash.com/photo-1566073771259-6a8506099945",
                  "Home Stay No.1",
                  "9.5",
                  "Xuất sắc",
                  "99",
                ),
                _buildHotelCard(
                  "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b",
                  "An Nam Hue Boutique",
                  "9.2",
                  "Tuyệt hảo",
                  "50",
                ),
                _buildHotelCard(
                  "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb",
                  "Huế Jade Hill Villa",
                  "8.0",
                  "Rất tốt",
                  "200",
                ),
                _buildHotelCard(
                  "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4",
                  "Silk Path Grand Hue",
                  "9.6",
                  "Xuất sắc",
                  "100",
                ),
                _buildHotelCard(
                  "https://images.unsplash.com/photo-1571896349842-33c89424de2d",
                  "Villa 5s",
                  "9.0",
                  "Tuyệt vời",
                  "150",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(IconData icon, String label, {bool hasDot = false}) {
    return Row(
      children: [
        Stack(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            if (hasDot)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.black54),
            SizedBox(width: 12),
            Text(
              "Huế • 23 thg 10 - 24 thg 10",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(
    String url,
    String name,
    String score,
    String rank,
    String price,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              url,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(Icons.favorite_border, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        score,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rank,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "US\$$price",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Đã bao gồm thuế và phí",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
