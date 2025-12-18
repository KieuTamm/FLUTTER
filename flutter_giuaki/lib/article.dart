class Article {
  final String? title;
  final String? description;
  final String? content;
  final String? url;
  final String? urlToImage;

  Article({
    this.title,
    this.description,
    this.content,
    this.url,
    this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
    );
  }
}
