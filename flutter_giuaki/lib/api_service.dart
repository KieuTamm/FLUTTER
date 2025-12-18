import 'dart:convert';
import 'article.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as consts;

class ApiService {
  Future<List<Article>> fetchArticles() async {
    final url = consts.getNewApiUrl();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> articlesJson = jsonResponse['articles'];

      return articlesJson
          .map((json) => Article.fromJson(json))
          .where(
            (article) =>
                article.title != '[Removed]' && article.urlToImage != null,
          )
          .toList();
    } else {
      // Xử lý lỗi API
      throw Exception(
        'Failed to load news articles. Status Code: ${response.statusCode}',
      );
    }
  }
}
