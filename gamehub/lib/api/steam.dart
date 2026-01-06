import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/config.dart';

class SteamApi {
  Future<String?> getGamePrice(String gameName) async {
    try {
      final uri = Uri.https(Config.steamHost, Config.steamSearchPath, {
        'term': gameName,
        'cc': 'us',
        'l': 'en',
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>;

        if (items.isNotEmpty) {
          final firstMatch = items.first;
          if (firstMatch.containsKey('price')) {
            final priceInfo = firstMatch['price'];
            final finalPrice = priceInfo['final'];

            if (finalPrice == 0) return "Free";

            final double priceInUsd = finalPrice / 100.0;
            return "\$${priceInUsd.toStringAsFixed(2)}";
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
