// To parse this JSON data, do
//
//     final DetailStory = DetailStoryFromJson(jsonString);

import 'dart:convert';

DetailStory detailStoryFromJson(String str) =>
    DetailStory.fromJson(json.decode(str));

String detailStoryToJson(DetailStory data) => json.encode(data.toJson());

class DetailStory {
  bool error;
  String message;
  Story story;

  DetailStory({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStory.fromJson(Map<String, dynamic> json) => DetailStory(
        error: json["error"],
        message: json["message"],
        story: Story.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}

class Story {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double lat;
  double lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: (json["lat"] as double?) ?? 0.0,
        lon: (json["lon"] as double?) ?? 0.0,
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