import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:presencemobile/view/home.dart';

import '../model/user_model.dart';
import '../utils/app_url.dart';

class HomeController extends GetxController {
  UserModel user = UserModel();
  final localBox = GetStorage();
  final numberPageIndex = 0.obs;
  String? token = "";
  RxBool isLogged = false.obs;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 50000),
      receiveTimeout: const Duration(seconds: 30000),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      validateStatus: (_) => true,
    ),
  );
  @override
  void onInit() {
    checkLoginStatus();
    super.onInit();
  }

  Future<String> login(String email, String password) async {
    String retval = "";
    if (email.isNotEmpty || password.isNotEmpty) {
      try {
        final response = await _dio.post(AppUrl.login,
            queryParameters: {"email": email, "password": password});

        if (response.statusCode == 200) {
          user = UserModel.fromJson(response.data);
          localBox.write("LOCALBOX_TOKEN", user.data?.token);
          localBox.write("LOCALBOX_NAME", user.data?.user?.name);
          localBox.write("LOCALBOX_EMAIL", user.data?.user?.email);
          localBox.write("LOCALBOX_PHONE", user.data?.user?.phone);
          localBox.write("LOCALBOX_ROLEID", user.data?.user?.roleId);
          localBox.write("LOCALBOX_ROLENAME", user.data?.rolename);
          localBox.write("LOCALBOX_JABNAME", user.data?.jabname);
          localBox.write("LOCALBOX_PARTNAME", user.data?.partname);
          retval = "Success";
          isLogged.value = true;
          Get.to(() => const HomePage());
        } else {
          retval = response.data['message'];
        }
      } on DioException catch (e) {
        retval = e.toString();
      }
    } else {
      retval = "User / Password tidak boleh kosong";
    }
    return retval;
  }

  void checkLoginStatus() {
    token = localBox.read("LOCALBOX_TOKEN");
    printInfo(
        info: 'Token Checked : ${localBox.read("LOCALBOX_TOKEN").toString()}');

    if (token != null) {
      isLogged.value = true;
    }
  }
}
