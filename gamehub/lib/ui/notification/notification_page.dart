import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0B0D12) : const Color(0xFFF8F9FD);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final accentColor = Colors.deepPurpleAccent;

    final List<Map<String, String>> notifications = [
      {
        "title": "Welcome Gift",
        "body":
            "Thanks for joining GameHub! Here is a coupon for your first purchase.",
        "time": "2 mins ago",
        "isRead": "false",
      },
      {
        "title": "Flash Sale Alert",
        "body": "Grand Theft Auto V is 50% off for the next 24 hours.",
        "time": "1 hour ago",
        "isRead": "true",
      },
      {
        "title": "System Update 2.0",
        "body": "New version is live with performance improvements.",
        "time": "5 hours ago",
        "isRead": "true",
      },
      {
        "title": "Price Drop: The Witcher 3",
        "body": "An item in your wishlist is now on sale.",
        "time": "1 day ago",
        "isRead": "true",
      },
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.done_all_rounded, color: accentColor, size: 24),
            tooltip: "Mark all as read",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          final isUnread = item['isRead'] == "false";

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1F26) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isUnread
                    ? accentColor.withOpacity(0.4)
                    : (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.03)),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isUnread ? accentColor : Colors.grey).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isUnread
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: isUnread ? accentColor : Colors.grey,
                  size: 22,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item["title"]!,
                      style: TextStyle(
                        fontWeight: isUnread
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                  ),
                  Text(
                    item["time"]!,
                    style: TextStyle(
                      fontSize: 11,
                      color: textColor.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  item["body"]!,
                  style: TextStyle(
                    color: textColor.withOpacity(0.65),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
