import 'package:camera/camera.dart';
import 'package:get/get.dart';

class ControllerOnGallery extends GetxController {
  RxString imagePath = ''.obs;

  XFile? imageFile;
  void setImagePath(String? value) {
    update();
    imagePath.value =
        value ?? ''; // Menggunakan .value untuk mengakses nilai RxString
  }

  void setImageFile(XFile? value) {
    update();
    imageFile = value;
  }
}
