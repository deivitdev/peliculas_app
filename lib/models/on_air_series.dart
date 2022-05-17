// To parse this JSON data, do
//
//     final onAirResponse = onAirResponseFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas_app/models/models.dart';

class OnAirResponse {
  OnAirResponse({
    this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int? page;
  List<Serie> results;
  int totalPages;
  int totalResults;

  factory OnAirResponse.fromJson(String str) => OnAirResponse.fromMap(json.decode(str));

  factory OnAirResponse.fromMap(Map<String, dynamic> json) => OnAirResponse(
        page: json["page"],
        results: List<Serie>.from(json["results"].map((x) => Serie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
