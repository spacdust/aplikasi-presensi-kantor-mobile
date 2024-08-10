import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:presencemobile/model/attendance_model.dart';
import 'package:presencemobile/model/precense_model.dart';

import '../model/user_model.dart';
import '../utils/app_url.dart';

class PresenceController extends GetxController {
  UserModel user = UserModel();
  final localBox = GetStorage();
  final numberPageIndex = 0.obs;
  String? token = "";
  RxBool isLogged = false.obs;
  var isLoading = false.obs;
  var belumPresensi = false.obs;
  var isPresensiMasuk = false.obs;
  var isPresensiKeluar = false.obs;
  var isPresensiForbidden = false
      .obs; //jika sudah melewati batas presensi awal, sudah tidak boleh presensi lagi

  List<Pre> listPrecense = <Pre>[].obs;
  List<Att> listAttendance = <Att>[].obs;
  RxString jarak = "-".obs;
  RxBool presencePermit = false.obs;
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

  Future<String> checkLocation(
      double latTo, double longTo, String locId) async {
    String retval = "";

    try {
      final response = await _dio.get(AppUrl.checkLocation, queryParameters: {
        "latitudeTo": latTo,
        "longitudeTo": longTo,
        "location_id": locId
      });
      var formatter = NumberFormat('#,###,000');
      print('respon location : ' + response.toString());
      jarak.value =
          formatter.format(response.data['jarak'].ceil()).toString() + "m";
      if (response.data['hasil'] == "Sukses") {
        retval = "OK";
        presencePermit.value = true;
      } else {
        retval = response.data['hasil'];
        presencePermit.value = false;
      }
    } on DioException catch (e) {
      retval = e.toString();
    }

    return retval;
  }

  Future<List<Pre>> getPrecenseTodayByAttendance(String att) async {
    DateTime now = DateTime.now();
    String formattedNowDate = DateFormat('yyyy-MM-dd').format(now);
    DateTime batasStartTime;
    isPresensiMasuk.value = false;
    isPresensiKeluar.value = false;
    isPresensiForbidden.value = false;
    try {
      //print("att : " + att);
      localBox.write("LOCALBOX_ATTID", att);
      isLoading.value = true;
      final response = await _dio.get(AppUrl.getPrecenseByAttendance,
          queryParameters: {"attendance_id": att});
      //print(response);

      if (response.data['message'] == "Berhasil") {
        listPrecense.addAll(PrecenseModel.fromJson(response.data).pre);

        if (listPrecense.isNotEmpty) {
          //logic untuk, kalau sudah presensi masuk dan keluar tombol nya hilang
          if (listPrecense[0].presenceEnterTime.toString() != "null") {
            isPresensiMasuk.value = true;
          }

          if (listPrecense[0].presenceOutTime.toString() != "null") {
            isPresensiKeluar.value = true;
          }
          print("masuk : " +
              isPresensiMasuk.value.toString() +
              ", keluar : " +
              isPresensiKeluar.value.toString());
        } else {
          final response2 = await _dio.get(AppUrl.getAttendanceById,
              queryParameters: {"attendance_id": att});
          listAttendance.addAll(AttendanceModel.fromJson(response2.data).att);
          batasStartTime = DateTime.parse(formattedNowDate +
              " " +
              listAttendance[0].batasStartTime.toString());
          // if (now.isAfter(batasStartTime)) {
          //   isPresensiForbidden.value = true;
          // }
        }
      }
      isLoading.value = false;
    } on DioException catch (e) {
      print(e.toString());
    }

    return listPrecense;
  }

  Future<List<Pre>> getPrecenseTodayByUser(String user) async {
    try {
      isLoading.value = true;
      final response = await _dio
          .get(AppUrl.getPrecenseByUser, queryParameters: {"user_id": user});
      if (response.data['message'] == "Berhasil") {
        listPrecense.addAll(PrecenseModel.fromJson(response.data).pre);
      }
      isLoading.value = false;
    } on DioException catch (e) {
      print(e.toString());
    }

    return listPrecense;
  }
}
