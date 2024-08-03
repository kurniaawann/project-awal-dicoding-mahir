import 'package:dicoding_storyapp_awal/controller/data/api/list_api.dart';
import 'package:dicoding_storyapp_awal/controller/data/api/login_api.dart';
import 'package:dicoding_storyapp_awal/controller/internet_controller.dart';

import 'package:dicoding_storyapp_awal/model/model_list_story.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ListPage extends StatelessWidget {
  final StoriesController lisStoryApi = Get.put(StoriesController());
  final ConnectivityInternet checkInternet = Get.find();

  ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Story"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined),
            onPressed: () {
              GoRouter.of(context).goNamed('addnewstory');
            },
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            onPressed: () {
              LoginControllerApi().logout();
              GoRouter.of(context).goNamed('login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await lisStoryApi.refresh();
        },
        child: Obx(
          () {
            checkInternet.checkInternetConnection();
            if (lisStoryApi.stories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: lisStoryApi.stories.length,
                itemBuilder: (context, index) {
                  final story = lisStoryApi.stories[index];
                  return buildStoryCard(story);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Widget buildStoryCard(ListStories story) {
  return InkWell(
    onTap: () {
      final storyId = story.id;
      GoRouter.of(Get.context!)
          .goNamed('detailstory', pathParameters: {'storyId': storyId});
    },
    child: Card(
      shadowColor: Colors.blue,
      borderOnForeground: false,
      elevation: 5,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            width: 500,
            child: Image.network(
              story.photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error_outline_outlined);
              },
            ),
          ),
          ListTile(
            title: Text(
              story.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    story.description,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      story.createdAt.toString(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
