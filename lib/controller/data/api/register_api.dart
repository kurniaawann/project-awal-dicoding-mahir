import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterControllerApi extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var message = ''.obs;
  var isLoggingIn = false.obs;
  Future<void> register() async {
    try {
      isLoggingIn.value = true;

      if (password.value.length < 8) {
        Get.snackbar(
          "Kesalahan",
          "Password harus memiliki setidaknya 8 karakter",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      final response = await http.post(
        Uri.parse('https://story-api.dicoding.dev/v1/register'),
        body: {
          'name': name.value,
          'email': email.value,
          'password': password.value,
        },
      );
      isLoggingIn.value = false;

      if (response.statusCode == 201) {
        Get.snackbar(
          "Berhasil ",
          "Berhasil Mendaftar Silahkan Login",
        );
        GoRouter.of(Get.context!).goNamed('login');
      } else if (response.statusCode == 400) {
        final responseJson = jsonDecode(response.body);
        final errorMessage = responseJson['message'];
        if (errorMessage == 'Email is already taken') {
          Get.snackbar(
            "Email Sudah Terdaftar",
            "Silahkan Gunakan Email Lain",
          );
        } else {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Harap Masukkan Email Dan Password Yang Sesuai",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan",
          "Silahkan Ikuti Petunnjuk Atau Hubungi Custommer Services");
    }
  }
}
