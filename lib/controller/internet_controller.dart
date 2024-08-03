import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityInternet extends GetxController {
  var isSnackbarShown = false.obs;
  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        "Periksa Koneksi Internet Anda",
        "Harap Nyalakan Koneksi Internet Anda",
      );
      isSnackbarShown(true);
    }
  }
}
