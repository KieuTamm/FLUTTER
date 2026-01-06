import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../detail/detail_page.dart';

class HomeSlider extends StatelessWidget {
  final List<Game> games;
  const HomeSlider({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final sliderGames = games.take(5).toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 240.0,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.88,
        aspectRatio: 16 / 9,
        initialPage: 0,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 1200),
        autoPlayCurve: Curves.easeInOutCubic,
        pauseAutoPlayOnTouch: true,
      ),
      items: sliderGames.map((game) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(game: game)),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    game.backgroundImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    left: 20,
                    right: 20,
                    child: Text(
                      game.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
