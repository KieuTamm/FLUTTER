const String API_KEY = 'bbda265d7c604d5b8802b48bc9d1da9b';
const String BASE_URL = 'https://newsapi.org/v2/top-headlines';
String getNewApiUrl() {
  return '$BASE_URL?country=us&apiKey=$API_KEY';
}
