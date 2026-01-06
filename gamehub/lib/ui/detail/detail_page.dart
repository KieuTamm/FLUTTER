import 'package:flutter/material.dart';
import 'dart:ui';
import '../../api/steam.dart';
import '../../api/rawg.dart';
import '../../models/game.dart';
import 'package:gamehub/ui/lib/favorites.dart';
import 'guide_list.dart';

class DetailPage extends StatefulWidget {
  final Game game;
  const DetailPage({super.key, required this.game});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final SteamApi _steamApi = SteamApi();
  final RawgApi _rawgApi = RawgApi();
  final FavoritesManager _favoritesManager = FavoritesManager();

  String _price = "Checking...";
  String _description = "";
  List<String> _genres = [];
  List<String> _platforms = [];
  String _releaseDate = "";
  String _developer = "";
  bool _isLoadingDetails = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchPrice(), _fetchGameDetails()]);
  }

  Future<void> _fetchPrice() async {
    final price = await _steamApi.getGamePrice(widget.game.name);
    if (mounted) setState(() => _price = price ?? "N/A");
  }

  Future<void> _fetchGameDetails() async {
    final data = await _rawgApi.getGameDetails(widget.game.id);
    if (mounted) {
      setState(() {
        _isLoadingDetails = false;
        if (data != null) {
          _description = data['description_raw'] ?? "No description found.";
          _releaseDate = data['released'] ?? "Unknown";
          if (data['genres'] != null) {
            _genres = (data['genres'] as List)
                .map((e) => e['name'] as String)
                .toList();
          }
          if (data['parent_platforms'] != null) {
            _platforms = (data['parent_platforms'] as List)
                .map((e) => e['platform']['name'] as String)
                .toList();
          }
          if (data['developers'] != null &&
              (data['developers'] as List).isNotEmpty) {
            _developer = data['developers'][0]['name'];
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF0B0D12) : const Color(0xFFF8F9FF);
    final surfaceColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);
    final primaryColor = Colors.deepPurpleAccent;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(isDark ? 0.15 : 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(isDark ? 0.12 : 0.08),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 360,
                  pinned: true,
                  backgroundColor: bgColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.black,
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 0.8, 1.0],
                        ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height),
                        );
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.network(
                        widget.game.backgroundImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.game.name,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _infoBadge(
                              Icons.star_rounded,
                              widget.game.rating.toString(),
                              Colors.amber,
                            ),
                            const SizedBox(width: 10),
                            _infoBadge(
                              Icons.payments_outlined,
                              _price,
                              primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Theme(
                          data: ThemeData(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          child: TabBar(
                            isScrollable: false,
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 4,
                                color: primaryColor,
                              ),
                              insets: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            labelColor: textColor,
                            unselectedLabelColor: textColor.withOpacity(0.3),
                            labelStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                            tabs: const [
                              Tab(text: "Overview"),
                              Tab(text: "Guides"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  _buildOverview(isDark, textColor, surfaceColor, primaryColor),
                  GuideList(gameId: widget.game.id.toString()),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(
          isDark,
          textColor,
          bgColor,
          surfaceColor,
          primaryColor,
        ),
      ),
    );
  }

  Widget _buildOverview(
    bool isDark,
    Color textColor,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _labeledInfo("RELEASE", _releaseDate, textColor),
                _labeledInfo("DEVELOPER", _developer, textColor),
              ],
            ),
          ),
          const SizedBox(height: 35),
          _sectionTitle("PLATFORMS", textColor),
          const SizedBox(height: 12),
          _buildChips(
            _platforms,
            isDark,
            textColor,
            surfaceColor,
            primaryColor,
          ),
          const SizedBox(height: 35),
          _sectionTitle("GENRES", textColor),
          const SizedBox(height: 12),
          _buildChips(
            _genres,
            isDark,
            textColor,
            surfaceColor,
            primaryColor,
            isGenre: true,
          ),
          const SizedBox(height: 35),
          _sectionTitle("ABOUT THIS GAME", textColor),
          const SizedBox(height: 15),
          _isLoadingDetails
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryColor,
                  ),
                )
              : Text(
                  _description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w900,
        color: textColor.withOpacity(0.3),
      ),
    );
  }

  Widget _labeledInfo(String label, String value, Color textColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(label, textColor),
          const SizedBox(height: 8),
          Text(
            value.isNotEmpty ? value : "...",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(
    List<String> items,
    bool isDark,
    Color textColor,
    Color surfaceColor,
    Color primaryColor, {
    bool isGenre = false,
  }) {
    if (items.isEmpty) return const SizedBox();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isGenre ? primaryColor.withOpacity(0.1) : surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isGenre
                      ? primaryColor.withOpacity(0.2)
                      : Colors.transparent,
                ),
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isGenre ? primaryColor : textColor.withOpacity(0.8),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBottomBar(
    bool isDark,
    Color textColor,
    Color bgColor,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: textColor.withOpacity(0.05))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            ValueListenableBuilder<List<Game>>(
              valueListenable: _favoritesManager.wishlistNotifier,
              builder: (context, _, __) {
                final isWish = _favoritesManager.isWishlisted(widget.game);
                return _AnimatedActionBtn(
                  onPressed: () =>
                      _favoritesManager.toggleWishlist(widget.game),
                  label: isWish ? "Wishlisted" : "Wishlist",
                  icon: isWish
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isWish ? Colors.redAccent : textColor,
                  isOutlined: true,
                  surfaceColor: surfaceColor,
                );
              },
            ),
            const SizedBox(width: 15),
            ValueListenableBuilder<List<Game>>(
              valueListenable: _favoritesManager.playedNotifier,
              builder: (context, _, __) {
                final isPlayed = _favoritesManager.isPlayed(widget.game);
                return _AnimatedActionBtn(
                  onPressed: () => _favoritesManager.togglePlayed(widget.game),
                  label: isPlayed ? "Played" : "Mark Played",
                  icon: isPlayed
                      ? Icons.check_circle_rounded
                      : Icons.sports_esports_rounded,
                  color: isPlayed ? Colors.greenAccent[700]! : primaryColor,
                  isOutlined: false,
                  surfaceColor: surfaceColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedActionBtn extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color color;
  final bool isOutlined;
  final Color surfaceColor;

  const _AnimatedActionBtn({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.color,
    required this.isOutlined,
    required this.surfaceColor,
  });

  @override
  State<_AnimatedActionBtn> createState() => _AnimatedActionBtnState();
}

class _AnimatedActionBtnState extends State<_AnimatedActionBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: widget.isOutlined ? widget.surfaceColor : widget.color,
              border: widget.isOutlined
                  ? Border.all(color: widget.color.withOpacity(0.2))
                  : null,
              boxShadow: widget.isOutlined
                  ? []
                  : [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: widget.isOutlined ? widget.color : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.isOutlined ? widget.color : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
