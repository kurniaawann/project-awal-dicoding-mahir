import 'package:get/get.dart';

class LoginController extends GetxController {
  var showPassword = false.obs;
  void toogleShowPassword() {
    showPassword.value = !showPassword.value;
  }
}
