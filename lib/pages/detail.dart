import 'package:dicoding_storyapp_awal/controller/data/api/detail_api.dart';
import 'package:dicoding_storyapp_awal/controller/data/api/login_api.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends StatelessWidget {
  final String storyId;

  final StoryDetailController storyApiC = Get.find();
  final LoginControllerApi loginController = Get.find();

  DetailPage({
    Key? key,
    required this.storyId,
  }) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }
  Future<void> _init() async {
    final String? token = await loginController.getToken();

    storyApiC.fetchStoryDetail(storyId, token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: Obx(() {
        if (storyApiC.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final detailStory = storyApiC.detailStory.value;
          final story = detailStory.story;

          return ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  story.photoUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error_outline_outlined);
                  }, // Atu
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nama : ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Expanded(
                      child: Text(
                        story.name,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "deskripsi : ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Expanded(
                      child: Text(
                        story.description,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Di buat Tanggal : ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      story.createdAt.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ]);
        }
      }),
    );
  }
}
