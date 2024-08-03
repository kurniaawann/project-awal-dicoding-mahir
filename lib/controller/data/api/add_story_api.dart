import 'dart:typed_data';
import 'package:dicoding_storyapp_awal/controller/data/api/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image/image.dart' as img;

class AddStoryController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();
  final StoriesController storiesController =
      Get.find<StoriesController>(); // Mengakses StoriesController

  RxBool isUploading = false.obs;
  RxString message = "".obs;

  Future<void> uploadStory(
    String description,
    File photo,
    double? lat,
    double? lon,
    String token,
  ) async {
    try {
      isUploading.value = true;

      // Compress the image
      final compressedImage = await compressImage(photo);

      final url = Uri.parse("https://story-api.dicoding.dev/v1/stories");
      final request = http.MultipartRequest("POST", url);

      // Set headers
      request.headers["Authorization"] = "Bearer $token";

      // Add fields to the request body
      request.fields["description"] = description;
      if (lat != null) {
        request.fields["lat"] = lat.toString();
      }
      if (lon != null) {
        request.fields["lon"] = lon.toString();
      }

      // Add the compressed photo as a file
      request.files.add(
        http.MultipartFile.fromBytes(
          "photo",
          compressedImage,
          filename: photo.path.split('/').last,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        message.value = "Story uploaded successfully";

        // Update daftar cerita di StoriesController
        storiesController.fetchStories();
        GoRouter.of(Get.context!).goNamed('liststory');
        Get.snackbar("Berhasil", "Berhasil Menambahkan Cerita");
      } else {
        message.value = "Error uploading story: ${response.body}";
      }
    } catch (e) {
      message.value = "Error uploading story: $e";
    } finally {
      isUploading.value = false;
    }
  }

  Future<Uint8List> compressImage(File imageFile) async {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) {
      return imageFile.readAsBytesSync();
    }
    // Compress the image
    final compressedImage = img.encodeJpg(image,
        quality: 40); // Sesuaikan kualitas sesuai kebutuhan

    return Uint8List.fromList(compressedImage);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
