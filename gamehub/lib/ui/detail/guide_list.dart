import 'package:flutter/material.dart';
import '../../api/rawg.dart';
import '../../models/guide.dart';
import 'guide_detail.dart';

class GuideList extends StatefulWidget {
  final String gameId;
  const GuideList({super.key, required this.gameId});

  @override
  State<GuideList> createState() => _GuideListState();
}

class _GuideListState extends State<GuideList> {
  final RawgApi _api = RawgApi();
  late Future<List<Guide>> _guidesFuture;

  @override
  void initState() {
    super.initState();
    _guidesFuture = _api.getGameGuides(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final primaryColor = Colors.deepPurpleAccent;
    final surfaceColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);

    return FutureBuilder<List<Guide>>(
      future: _guidesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(color: textColor.withOpacity(0.5)),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 60,
                  color: textColor.withOpacity(0.1),
                ),
                const SizedBox(height: 16),
                Text(
                  "No guides found",
                  style: TextStyle(
                    color: textColor.withOpacity(0.3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        final guides = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          physics: const BouncingScrollPhysics(),
          itemCount: guides.length,
          itemBuilder: (context, index) {
            final guide = guides[index];
            return _GuideTile(
              guide: guide,
              textColor: textColor,
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
            );
          },
        );
      },
    );
  }
}

class _GuideTile extends StatefulWidget {
  final Guide guide;
  final Color textColor;
  final Color primaryColor;
  final Color surfaceColor;

  const _GuideTile({
    required this.guide,
    required this.textColor,
    required this.primaryColor,
    required this.surfaceColor,
  });

  @override
  State<_GuideTile> createState() => _GuideTileState();
}

class _GuideTileState extends State<_GuideTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideDetailsPage(guide: widget.guide),
          ),
        );
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.textColor.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.explore_rounded,
                  color: widget.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.guide.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: widget.textColor.withOpacity(0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.guide.author,
                            style: TextStyle(
                              color: widget.textColor.withOpacity(0.4),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: widget.textColor.withOpacity(0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.guide.date.toString().split(' ')[0],
                            style: TextStyle(
                              color: widget.textColor.withOpacity(0.4),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: widget.textColor.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
