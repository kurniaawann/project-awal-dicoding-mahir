import 'package:dicoding_storyapp_awal/controller/data/api/login_api.dart';

import 'package:dicoding_storyapp_awal/model/model_detail_story.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryDetailController extends GetxController {
  final loginController = Get.find<LoginControllerApi>();
  var isLoading = true.obs;

  var detailStory = DetailStory(
    error: false,
    message: 'Story fetched successfully',
    story: Story(
      id: "",
      name: "",
      description: "",
      photoUrl: "",
      createdAt: DateTime.now(),
      lat: 0.0,
      lon: 0.0,
    ),
  ).obs;

  void fetchStoryDetail(String storyId, String token) async {
    try {
      final String? authToken = await loginController.getToken();
      isLoading(true);
      final response = await getStoryDetail(storyId, authToken!);

      if (!response.error) {
        detailStory(response);
      }
    } catch (error) {
      Get.snackbar(
          "Terjadi Kesalahan", "Tidak dapat Menampilkan detail cerita");
    } finally {
      isLoading(false);
    }
  }

  Future<DetailStory> getStoryDetail(String storyId, String token) async {
    final url = 'https://story-api.dicoding.dev/v1/stories/$storyId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return DetailStory.fromJson(responseData);
    } else {
      throw Exception('Gagal mengambil detail cerita');
    }
  }
}
