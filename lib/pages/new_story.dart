import 'dart:io';
import 'package:dicoding_storyapp_awal/controller/data/api/add_story_api.dart';
import 'package:dicoding_storyapp_awal/controller/data/api/login_api.dart';
import 'package:dicoding_storyapp_awal/controller/internet_controller.dart';
import 'package:dicoding_storyapp_awal/controller/newstory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddNewStory extends StatelessWidget {
  final ControllerOnGallery valueImageC = Get.put(ControllerOnGallery());
  final AddStoryController uploadApiC = Get.put(AddStoryController());
  final loginController = Get.find<LoginControllerApi>();
  final ConnectivityInternet checkInternet = Get.find();
  AddNewStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Story"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () {
                if (valueImageC.imagePath.value.isEmpty) {
                  return const Icon(
                    Icons.image,
                    size: 400.0,
                    color: Colors.grey,
                  );
                } else {
                  return _showImage();
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _onGalleryView();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text("Gallery"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _onCameraView();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text("Camera"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: uploadApiC.descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final description = uploadApiC.descriptionController.text;
                      final XFile? xFile = valueImageC.imageFile;
                      const lat = null;
                      const lon = null;
                      final String? token = await loginController.getToken();

                      if (token != null) {
                        if (xFile != null) {
                          final File photo = File(xFile.path);
                          uploadApiC.uploadStory(
                              description, photo, lat, lon, token);
                        } else {
                          Get.snackbar("Terjadi Kesalahan",
                              "Silahkan Pilih Gambar Terlebih Dahulu");
                        }
                      } else {
                        Get.snackbar(
                            "Terjadi Kesalahan", "Token Anda Sudah Kadarluasa");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(900, 50),
                    ),
                    child: Obx(
                      () {
                        if (checkInternet.isSnackbarShown.value) {
                          return const Text("upload");
                        } else if (uploadApiC.isUploading.value) {
                          return const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          );
                        } else {
                          return const Text("upload");
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_onGalleryView() async {
  final ControllerOnGallery valueImageC = Get.find<ControllerOnGallery>();
  final ImagePicker picker = ImagePicker();

  final XFile? pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (pickedFile != null) {
    valueImageC.setImageFile(pickedFile);
    valueImageC.setImagePath(pickedFile.path);
  }
}

_onCameraView() async {
  final ControllerOnGallery valueImageC = Get.find<ControllerOnGallery>();

  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(
    source: ImageSource.camera,
  );

  if (pickedFile != null) {
    valueImageC.setImageFile(pickedFile);
    valueImageC.setImagePath(pickedFile.path);
  }
}

Widget _showImage() {
  final ControllerOnGallery valueImageC = Get.find<ControllerOnGallery>();
  if (valueImageC.imageFile != null) {
    return Image.file(File(valueImageC.imageFile!.path));
  } else {
    return Image.network(
      valueImageC.imagePath.value,
      fit: BoxFit.contain,
    );
  }
}
