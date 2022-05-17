import 'dart:convert';

import 'package:peliculas_app/models/models.dart';

class PopularSeries {
  PopularSeries({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });

  int page;
  List<Serie> results;
  int totalResults;
  int totalPages;

  factory PopularSeries.fromJson(String str) => PopularSeries.fromMap(json.decode(str));

  factory PopularSeries.fromMap(Map<String, dynamic> json) => PopularSeries(
        page: json["page"],
        results: List<Serie>.from(json["results"].map((x) => Serie.fromMap(x))),
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
      );
}
