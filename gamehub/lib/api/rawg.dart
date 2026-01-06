import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/guide.dart';
import '../util/config.dart';

class RawgApi {
  static final RawgApi _instance = RawgApi._internal();
  factory RawgApi() => _instance;
  RawgApi._internal() {
    _dio.options = BaseOptions(
      baseUrl: Config.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    );
  }

  final Dio _dio = Dio();
  final String _apiKey = Config.apiKey;

  Future<List<Game>> getGames({
    String? search,
    String? genres,
    String? dates,
    String? ordering,
  }) async {
    try {
      final params = <String, dynamic>{'key': _apiKey, 'page_size': 20};

      if (search != null && search.trim().isNotEmpty) {
        params['search'] = search.trim();
        params['search_precise'] = true;
      } else if (ordering == null) {
        params['ordering'] = '-added';
      }

      if (dates != null) params['dates'] = dates;
      if (ordering != null) params['ordering'] = ordering;
      if (genres != null && genres != 'all') params['genres'] = genres;

      final response = await _dio.get('/games', queryParameters: params);

      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((e) => Game.fromJson(e)).toList();
      }
      return <Game>[];
    } on DioException catch (e) {
      debugPrint('DIO ERROR [${e.type}]: ${e.message}');
      return <Game>[];
    } catch (e) {
      debugPrint('RAWG ERROR: $e');
      return <Game>[];
    }
  }

  Future<Map<String, dynamic>?> getGameDetails(int id) async {
    try {
      final response = await _dio.get(
        '/games/$id',
        queryParameters: {'key': _apiKey},
      );
      return response.statusCode == 200 ? response.data : null;
    } catch (e) {
      debugPrint('Detail Error: $e');
      return null;
    }
  }

  Future<List<Guide>> getGameGuides(String gameId) async {
    try {
      final response = await _dio.get(
        '/games/$gameId/reddit',
        queryParameters: {'key': _apiKey},
      );

      if (response.data == null) return <Guide>[];

      final List list = response.data['results'] ?? [];
      return list
          .map(
            (item) => Guide(
              id: item['id'].toString(),
              title: item['name'] ?? 'No Title',
              subtitle: 'Reddit Discussion',
              content: item['text'] ?? item['url'] ?? 'No content',
              author: item['username'] ?? 'Unknown',
              date:
                  DateTime.tryParse(item['created']?.toString() ?? '') ??
                  DateTime.now(),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Guide Error: $e');
      return <Guide>[];
    }
  }
}
