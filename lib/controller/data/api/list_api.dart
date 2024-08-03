import 'package:dicoding_storyapp_awal/controller/data/api/login_api.dart';
import 'package:dicoding_storyapp_awal/model/model_list_story.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoriesController extends GetxController {
  final LoginControllerApi loginController = Get.find<LoginControllerApi>();
  RxList<ListStories> stories = <ListStories>[].obs;

  @override
  void onInit() {
    fetchStories();
    super.onInit();
  }

  @override
  Future<void> refresh() async {
    await fetchStories();
  }

  Future<void> fetchStories({int? page, int? size, int location = 0}) async {
    try {
      final String? token = await loginController.getToken();

      if (token != null) {
        final url = Uri.parse('https://story-api.dicoding.dev/v1/stories');
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonList = json.decode(response.body)['listStory'] as List;
          stories.assignAll(jsonList.map((e) {
            return ListStories.fromJson(e);
          }).toList());
        }
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan",
          "Silahkan Intruksi Yang Di Berikan Atau Hubungi Customer Services");
    }
  }
}
