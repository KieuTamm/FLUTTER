import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/rawg.dart';
import '../../models/game.dart';
import '../detail/detail_page.dart';
import '../notification/notification_page.dart';
import '../home/slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RawgApi _api = RawgApi();
  List<Game> legends = [];
  List<Game> trending = [];
  List<Game> topRated = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final now = DateTime.now();
    final dateRange =
        "${DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 180)))},${DateFormat('yyyy-MM-dd').format(now)}";

    try {
      final res = await Future.wait([
        _api.getGames(ordering: '-added'),
        _api.getGames(dates: dateRange, ordering: '-relevance'),
        _api.getGames(ordering: '-metacritic'),
      ]);

      if (mounted) {
        setState(() {
          legends = List<Game>.from(
            res[0],
          ).where((g) => g.backgroundImage.length > 10).toList();

          trending = List<Game>.from(
            res[1],
          ).where((g) => g.backgroundImage.length > 10).toList();

          topRated = List<Game>.from(res[2])
              .where((g) => g.backgroundImage.length > 10 && g.rating > 1.0)
              .toList();

          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF0B0D12) : const Color(0xFFF8F9FF);

    return Scaffold(
      backgroundColor: bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
            )
          : _buildLayout(isDark, textColor),
    );
  }

  Widget _buildLayout(bool isDark, Color textColor) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(isDark ? 0.12 : 0.08),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purpleAccent.withOpacity(isDark ? 0.12 : 0.08),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),
        SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadAllData,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(textColor),
                if (legends.isNotEmpty)
                  SliverToBoxAdapter(child: HomeSlider(games: legends)),
                _buildSectionTitle('Trending Now', textColor),
                _buildHorizontalSection(trending),
                _buildSectionTitle('Highest Rated', textColor),
                _buildVerticalSection(topRated, textColor, isDark),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Color textColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'GameHub',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: textColor,
                size: 28,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalSection(List<Game> games) {
    final list = games.take(10).toList();
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildCard(list[index], 160),
        ),
      ),
    );
  }

  Widget _buildVerticalSection(List<Game> games, Color textColor, bool isDark) {
    final list = games.take(5).toList();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildRow(list[index], textColor, isDark),
          childCount: list.length,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Game game, double width) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(game: game)),
      ),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 15, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                game.backgroundImage,
                fit: BoxFit.cover,
                cacheWidth: 400,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  game.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(Game game, Color textColor, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(game: game)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: textColor.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'game-${game.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  game.backgroundImage,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  cacheWidth: 150,
                  errorBuilder: (_, __, ___) =>
                      Container(width: 65, height: 65, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          game.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: textColor.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
