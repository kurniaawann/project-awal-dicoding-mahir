import 'package:dicoding_storyapp_awal/controller/data/api/login_api.dart';
import 'package:dicoding_storyapp_awal/controller/internet_controller.dart';
import 'package:dicoding_storyapp_awal/controller/login_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginC = Get.put(LoginController());
  final LoginControllerApi loginApiC = Get.put(LoginControllerApi());
  final ConnectivityInternet checkInternet = Get.find();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loginApiC.loadEmailAndPassword();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        automaticallyImplyLeading: false,
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
                  onChanged: (value) => loginApiC.email.value = value,
                  //hanya untuk latihan menyimpan email
                  controller:
                      TextEditingController(text: loginApiC.email.value),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Obx(
                  () => TextField(
                    onChanged: (value) => loginApiC.password.value = value,
                    //hanya untuk latihan menyimpan password
                    controller:
                        TextEditingController(text: loginApiC.password.value),
                    obscureText: !loginC.showPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          loginC.showPassword.value =
                              !loginC.showPassword.value;
                        },
                        child: Icon(
                          loginC.showPassword.value
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

                    loginApiC.login();
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(500, 50),
                    ), // Atur ukuran tombol
                  ),
                  child: Obx(
                    () {
                      if (checkInternet.isSnackbarShown.value) {
                        return const Text("Masuk");
                      } else if (loginApiC.isLoggingIn.value) {
                        return const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else {
                        return const Text("Masuk");
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).goNamed('register'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(500, 50)), // Atur ukuran tombol
                  ),
                  child: const Text("Daftar"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
