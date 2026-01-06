import 'package:flutter/material.dart';
import 'dart:ui';
import '../../api/rawg.dart';
import '../../models/game.dart';
import '../detail/detail_page.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final RawgApi _api = RawgApi();
  List<Game> games = [];
  bool isLoading = true;
  final List<String> _selectedGenreIds = [];
  String? _currentSearchQuery;

  final List<Map<String, String>> genres = [
    {'id': '4', 'name': 'Action'},
    {'id': '51', 'name': 'Indie'},
    {'id': '3', 'name': 'Adventure'},
    {'id': '5', 'name': 'RPG'},
    {'id': '10', 'name': 'Strategy'},
    {'id': '2', 'name': 'Shooter'},
    {'id': '40', 'name': 'Casual'},
    {'id': '14', 'name': 'Simulation'},
    {'id': '7', 'name': 'Puzzle'},
    {'id': '11', 'name': 'Arcade'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final String? apiGenres =
          (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty)
          ? null
          : (_selectedGenreIds.isEmpty ? null : _selectedGenreIds.join(','));

      final fetchedGames = await _api.getGames(
        search: _currentSearchQuery,
        genres: apiGenres,
      );

      if (mounted) {
        setState(() {
          if (_selectedGenreIds.isNotEmpty) {
            games = fetchedGames.where((game) {
              final gameGenreIds = game.genres
                  .map((g) => g.id.toString())
                  .toList();
              return _selectedGenreIds.every((id) => gameGenreIds.contains(id));
            }).toList();
          } else {
            games = fetchedGames;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _onGenreTap(String id) {
    setState(() {
      if (_selectedGenreIds.contains(id)) {
        _selectedGenreIds.remove(id);
      } else {
        _selectedGenreIds.add(id);
      }
    });
    _fetchGames();
  }

  void _onSearch(String query) {
    _currentSearchQuery = query.trim().isEmpty ? null : query.trim();
    _fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0D12)
          : const Color(0xFFF8F9FF),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(isDark ? 0.15 : 0.1),
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
                color: Colors.purpleAccent.withOpacity(isDark ? 0.15 : 0.1),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(textColor, isDark),
                _buildFilterBar(isDark),
                const SizedBox(height: 15),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        )
                      : games.isEmpty
                      ? Center(
                          child: Text(
                            "No games found",
                            style: TextStyle(color: textColor.withOpacity(0.5)),
                          ),
                        )
                      : _buildGameGrid(isDark, textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color textColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            child: TextField(
              onChanged: _onSearch,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search_rounded,
                  color: textColor.withOpacity(0.5),
                ),
                hintText: 'Search games...',
                hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = _selectedGenreIds.contains(genre['id']);
          return GestureDetector(
            onTap: () => _onGenreTap(genre['id']!),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent
                    : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.blueAccent
                      : (isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05)),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                genre['name']!,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameGrid(bool isDark, Color textColor) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(game: game)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      game.backgroundImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                game.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    game.rating.toString(),
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
