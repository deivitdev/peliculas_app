// To parse this JSON data, do
//
//     final serie = serieFromMap(jsonString);

import 'dart:convert';

class Serie {
  Serie({
    required this.posterPath,
    required this.popularity,
    required this.id,
    this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.firstAirDate,
    this.originCountry,
    required this.genreIds,
    this.originalLanguage,
    required this.voteCount,
    required this.name,
    required this.originalName,
  });

  String posterPath;
  double popularity;
  int id;
  String? backdropPath;
  double voteAverage;
  String overview;
  DateTime firstAirDate;
  List<OriginCountry>? originCountry;
  List<int> genreIds;
  OriginalLanguage? originalLanguage;
  int voteCount;
  String name;
  String originalName;

  String? heroId;

  get fullPosterImg {
    if (posterPath != null) return 'https://image.tmdb.org/t/p/w500/$posterPath';
    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  get fullBackdropPath {
    if (backdropPath != null) return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  factory Serie.fromJson(String str) => Serie.fromMap(json.decode(str));

  factory Serie.fromMap(Map<String, dynamic> json) => Serie(
        posterPath: json["poster_path"],
        popularity: json["popularity"].toDouble(),
        id: json["id"],
        backdropPath: json["backdrop_path"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        firstAirDate: DateTime.parse(json["first_air_date"]),
        originCountry: [],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        originalLanguage: null,
        voteCount: json["vote_count"],
        name: json["name"],
        originalName: json["original_name"],
      );
}

enum OriginCountry { US, GB, JP }

late final originCountryValues = EnumValues({"GB": OriginCountry.GB, "JP": OriginCountry.JP, "US": OriginCountry.US});

enum OriginalLanguage { EN, JA }

late final originalLanguageValues = EnumValues({"en": OriginalLanguage.EN, "ja": OriginalLanguage.JA});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap!;
  }
}
