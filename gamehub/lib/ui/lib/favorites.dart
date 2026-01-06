import 'package:flutter/material.dart';
import 'package:gamehub/models/game.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();

  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal();

  final ValueNotifier<List<Game>> wishlistNotifier = ValueNotifier([]);
  final ValueNotifier<List<Game>> playedNotifier = ValueNotifier([]);

  void toggleWishlist(Game game) {
    final currentList = wishlistNotifier.value;
    final isExist = currentList.any((element) => element.id == game.id);

    if (isExist) {
      wishlistNotifier.value = currentList
          .where((element) => element.id != game.id)
          .toList();
    } else {
      wishlistNotifier.value = [...currentList, game];
    }
  }

  bool isWishlisted(Game game) {
    return wishlistNotifier.value.any((element) => element.id == game.id);
  }

  void togglePlayed(Game game) {
    final currentList = playedNotifier.value;
    final isExist = currentList.any((element) => element.id == game.id);

    if (isExist) {
      playedNotifier.value = currentList
          .where((element) => element.id != game.id)
          .toList();
    } else {
      playedNotifier.value = [...currentList, game];
    }
  }

  bool isPlayed(Game game) {
    return playedNotifier.value.any((element) => element.id == game.id);
  }
}
