import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'movie.dart';

class HttpHelper {
  final String urlKey = 'api_key=a5d01b4d751380e044e2246e605df108';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=a5d01b4d751380e044e2246e605df108&query=';

  Future<List?> getUpcoming() async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    http.Response result = await http.get(Uri.parse(upcoming));
    if (result.statusCode == HttpStatus.ok) {
      // HttpStatus.ok is 200, HttpStatus.notFound is 404
      final Map<String, dynamic> jsonResponse = json.decode(result.body);
      final List listOfMovieMaps = jsonResponse['results'];
      final listOfMovies =
          listOfMovieMaps.map((e) => Movie.fromJson(e)).toList();
      return listOfMovies;
    } else {
      return null;
    }
  }

  Future<List?> findMovies(String title) async {
    final String query = urlSearchBase + title;
    http.Response result = await http.get(Uri.parse(query));
    if (result.statusCode == HttpStatus.ok) {
      // HttpStatus.ok is 200, HttpStatus.notFound is 404
      final Map<String, dynamic> jsonResponse = json.decode(result.body);
      final List listOfMovieMaps = jsonResponse['results'];
      final listOfMovies =
          listOfMovieMaps.map((e) => Movie.fromJson(e)).toList();
      return listOfMovies;
    } else {
      return null;
    }
  }
}
