import 'package:flutter/material.dart';
import 'package:presencemobile/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:presencemobile/theme/colors.dart';
import 'package:get/get.dart';

class PermissionSucces extends StatelessWidget {
  const PermissionSucces({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15.0.h,
                    ),
                    Image(
                      image:
                          const AssetImage('assets/images/check_prev_ui.png'),
                      width: 70.w,
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Text(
                      "Berhasil Melakukan Pengajuan Izin.",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.back();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        secondary, // Ganti dengan warna latar belakang yang diinginkan
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Kembali Ke Beranda',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: Colors
                          .white, // Ganti dengan warna teks yang diinginkan
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.sp,
            )
          ],
        ),
      ),
    );
  }
}
