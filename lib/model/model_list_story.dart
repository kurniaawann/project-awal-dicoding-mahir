// To parse this JSON data, do
//
//     final Stories = StoriesFromJson(jsonString);

import 'dart:convert';

Stories storiesFromJson(String str) => Stories.fromJson(json.decode(str));

String storiesToJson(Stories data) => json.encode(data.toJson());

class Stories {
  bool error;
  String message;
  List<ListStories> listStories;

  Stories({
    required this.error,
    required this.message,
    required this.listStories,
  });

  factory Stories.fromJson(Map<String, dynamic> json) => Stories(
        error: json["error"],
        message: json["message"],
        listStories: List<ListStories>.from(
            json["listStories"].map((x) => ListStories.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStories": List<dynamic>.from(listStories.map((x) => x.toJson())),
      };
}

class ListStories {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double lat;
  double lon;

  ListStories({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory ListStories.fromJson(Map<String, dynamic> json) => ListStories(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble() ?? 0.0,
        lon: json["lon"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
