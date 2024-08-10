import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:presencemobile/model/permission_model.dart';
import 'package:presencemobile/view/permission_succes.dart';

import '../utils/app_url.dart';

class PermissionController extends GetxController {
  final localBox = GetStorage();
  var isLoading = false.obs;
  var isIzin = false.obs;
  List<Perm> listPerm = [];
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

  void storePermission(String title, String desc) async {
    try {
      isLoading.value = true;
      final response =
          await _dio.post(AppUrl.storePermission, queryParameters: {
        "user_id": localBox.read("LOCALBOX_IDUSER"),
        "attendance_id": localBox.read("LOCALBOX_ATTID"),
        "title": title,
        "description": desc
      });
      print(response);
      isLoading.value = false;
      Get.to(PermissionSucces());
    } on DioException catch (e) {
      print(e.toString());
    }
  }

  Future<List<Perm>> getPermissionByUser() async {
    try {
      isLoading.value = true;
      isIzin.value = false;
      final response =
          await _dio.get(AppUrl.getPermissionByUser, queryParameters: {
        "user_id": localBox.read("LOCALBOX_IDUSER"),
        "attendance_id": localBox.read("LOCALBOX_ATTID")
      });
      print(response.data['data']);
      if (response.data['message'] == "Berhasil") {
        listPerm = PermissionModel.fromJson(response.data).perm;
        isLoading.value = false;
        if (listPerm.isNotEmpty) {
          isIzin.value = true;
        }
      }
    } on DioException catch (e) {
      print(e.toString());
    }

    return listPerm;
  }
}
