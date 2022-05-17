import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';

import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/popular_series_response.dart';
import 'package:peliculas_app/models/search_response.dart';

class SeriesProvider extends ChangeNotifier {
  final String _apiKey = 'aca38cc01552d65d15e23f4c8f590240';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Serie> onDisplaySeries = [];
  List<Serie> popularSeries = [];

  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Serie>> _streamController = StreamController.broadcast();

  Stream<List<Serie>> get suggestionStream => _streamController.stream;

  SeriesProvider() {
    getOnDisplaySeries();
    getPopularSeries();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplaySeries() async {
    final jsonData = await _getJsonData('3/tv/on_the_air');
    final onAirResponse = OnAirResponse.fromJson(jsonData);
    onDisplaySeries = onAirResponse.results;
    notifyListeners();
  }

  getPopularSeries() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/tv/popular', _popularPage);
    final popularResponse = PopularSeries.fromJson(jsonData);
    popularSeries = [...popularSeries, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getSerieCast(int serieId) async {
    if (movieCast.containsKey(serieId)) return movieCast[serieId]!;

    final jsonData = await _getJsonData('3/tv/$serieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    movieCast[serieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  // Future<List<Serie>> searchMovies(String query) async {
  //   final url = Uri.https(_baseUrl, '3/search/tv', {
  //     'api_key': _apiKey,
  //     'language': _language,
  //     'query': query,
  //   });
  //   final response = await http.get(url);
  //   final searchResponse = SearchResponse.fromJson(response.body);

  //   return searchResponse.results;
  // }

  // void getSuggestionByQuery(String searchTerm) {
  //   debouncer.value = '';
  //   debouncer.onValue = (value) async {
  //     final results = await searchMovies(value);
  //     _streamController.add(results);
  //   };

  //   final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
  //     debouncer.value = searchTerm;
  //   });

  //   Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  // }
}
