import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:presencemobile/model/holiday_model.dart';

import '../utils/app_url.dart';

class HolidayController extends GetxController {
  final localBox = GetStorage();
  String? token = "";
  var isLoading = false.obs;
  List<Holiday> listHoliday = [];
  late Holiday holiday;
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

  Future<List<Holiday>> getHoliday() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(AppUrl.getHoliday);
      print(response.data['data']);
      if (response.data['message'] == "Berhasil") {
        listHoliday = HolidayModel.fromJson(response.data).holiday;
        isLoading.value = false;
      }
    } on DioException catch (e) {
      print(e.toString());
    }

    return listHoliday;
  }

  Future<List<Holiday>> getHolidayToday() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(AppUrl.getHolidayToday);
      print(response.data['data']);
      if (response.data['message'] == "Berhasil") {
        listHoliday = HolidayModel.fromJson(response.data).holiday;
        isLoading.value = false;
      }
    } on DioException catch (e) {
      print(e.toString());
    }

    return listHoliday;
  }
}
