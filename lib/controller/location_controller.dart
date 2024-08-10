import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:presencemobile/model/location_model.dart';

import '../utils/app_url.dart';

class LocationController extends GetxController {
  final localBox = GetStorage();
  String? token = "";
  var isLoading = false.obs;
  List<Loc> listLocation = [];

  late Loc location;
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

  Future<List<Loc>> getLocation() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(AppUrl.getLocation);
      print(response.data['data']);
      if (response.data['message'] == "Berhasil") {
        //listLocation = json.decode(response.data['data']).map((data) => LocationModel.fromJson(data)).toList();
        listLocation = LocationModel.fromJson(response.data).loc;
        isLoading.value = false;
      }
    } on DioException catch (e) {
      print(e.toString());
    }

    return listLocation;
  }

  Future<List<Loc>> getLocationDropdown() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(AppUrl.getLocation);

      if (response.data['message'] == "Berhasil") {
        //listLocation = json.decode(response.data['data']).map((data) => LocationModel.fromJson(data)).toList();
        listLocation = LocationModel.fromJson(response.data).loc;
        isLoading.value = false;
      }
    } on DioException catch (e) {
      print(e.toString());
    }

    return listLocation;
  }
}
