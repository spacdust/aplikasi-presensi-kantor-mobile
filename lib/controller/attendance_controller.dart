import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:presencemobile/model/attendance_model.dart';

import '../utils/app_url.dart';

class AttendanceController extends GetxController {
  final localBox = GetStorage();
  String? token = "";
  var isLoading = false.obs;
  List<Att> listAttendance = [];
  late Att attendance;
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
    super.onInit();
  }

  Future<List<Att>> getAttendanceByPosition() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(AppUrl.getAttendance,
          queryParameters: {"position_id": localBox.read("LOCALBOX_POSID")});
      print(response);
      if (response.data['message'] == "Berhasil") {
        //listLocation = json.decode(response.data['data']).map((data) => LocationModel.fromJson(data)).toList();
        listAttendance = AttendanceModel.fromJson(response.data).att;
        isLoading.value = false;
      }
    } on DioException catch (e) {
      print(e.toString());
    }

    return listAttendance;
  }
}
