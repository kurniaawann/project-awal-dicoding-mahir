import 'package:dicoding_storyapp_awal/controller/data/api/register_api.dart';
import 'package:dicoding_storyapp_awal/controller/internet_controller.dart';

import 'package:dicoding_storyapp_awal/controller/register_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController registerC = Get.put(RegisterController());
  final RegisterControllerApi registerApiC = Get.find();
  final ConnectivityInternet checkInternet = Get.find();
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50.0),
            child: const Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 100.0,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => registerApiC.name.value = value,
                  controller: registerC.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  onChanged: (value) => registerApiC.email.value = value,
                  controller: registerC.email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Obx(
                  () => TextField(
                    onChanged: (value) => registerApiC.password.value = value,
                    controller: registerC.password,
                    obscureText: !registerC.showPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          registerC.showPassword.value = !registerC.showPassword
                              .value; // Tombol mata untuk mengganti tampilan teks
                        },
                        child: Icon(
                          registerC.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    await checkInternet.checkInternetConnection();

                    registerApiC.register();
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(500, 50),
                    ), // Atur ukuran tombol
                  ),
                  child: Obx(
                    () {
                      if (checkInternet.isSnackbarShown.value) {
                        return const Text("Daftar");
                      } else if (registerApiC.isLoggingIn.value) {
                        return const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else {
                        return const Text("Daftar");
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
