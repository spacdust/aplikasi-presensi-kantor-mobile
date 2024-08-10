import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import '../theme/colors.dart';
import 'detail_precense_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final localBox = GetStorage();

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(backgroundColor: primary, title: const Text("Daftar Riwayat Presensi")),
        body: Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [
              Container(
                width: 70.0,
                height: 70.0,
                decoration: const BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang, " + localBox.read("LOCALBOX_NAME"),
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(localBox.read("LOCALBOX_ROLENAME"), style: TextStyle(fontSize: 10.sp)),
                ],
              )
            ],
          ),
        ),
      ));
    });
  }
}
