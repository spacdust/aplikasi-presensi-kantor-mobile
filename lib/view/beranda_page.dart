import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:presencemobile/controller/login_controller.dart';
import 'package:presencemobile/locator.dart';
import 'package:presencemobile/services/camera.service.dart';
import 'package:presencemobile/services/face_detector_service.dart';
import 'package:presencemobile/services/ml_service.dart';
import 'package:presencemobile/view/face_regis_page.dart';
import 'package:presencemobile/view/form_permission_page.dart';
import 'package:presencemobile/view/form_update_password.dart';
import 'package:presencemobile/view/history_page.dart';
import 'package:presencemobile/view/holiday_page.dart';
import 'package:presencemobile/view/location_page.dart';
import 'package:presencemobile/view/precense_page.dart';
import 'package:presencemobile/view/profile_page.dart';
import 'package:presencemobile/view/detail_precense_page.dart';
import 'package:presencemobile/controller/attendance_controller.dart';
import 'package:sizer/sizer.dart';

import '../controller/home_controller.dart';
import '../theme/colors.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late String _timeString = "";
  late String _dateString = "";
  int pageIndex = 0;
  final HomeController controller = Get.put(HomeController());
  final LoginController logincontroller = Get.put(LoginController());
  final attendancecontroller = Get.put(AttendanceController());
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  bool loading = false;
  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    _dateString = _formatDateTime2(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    super.initState();
    attendancecontroller.getAttendanceByPosition();
    _initializeServices();
  }

  _initializeServices() async {
    setState(() => loading = true);
    //await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final localBox = GetStorage();
    var resultFace = localBox.read("LOCALBOX_FACEDATA");

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          home: Scaffold(
              body: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6.h,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Image(
                      image: const AssetImage(
                        'assets/images/inspiringbeltim.png',
                      ),
                      width: 18.w,
                    ),
                  ],
                ),
                SizedBox(
                  width: 2.h,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'APLIKASI PRESENSI',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Dinas Kebudayaan dan Pariwisata \nKabupaten Belitung Timur',
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 8.sp,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // ignore: prefer_interpolation_to_compose_strings
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat datang, \n" +
                                  localBox.read("LOCALBOX_NAME"),
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _showLogoutConfirmationDialog(context);
                              },
                              child: Icon(
                                Icons.logout_rounded,
                                size: 15.sp,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.mail,
                                      size: 14.sp,
                                      color: const Color.fromARGB(163, 0, 0, 0),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "   " + localBox.read("LOCALBOX_EMAIL"),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.group,
                                      size: 14.sp,
                                      color: const Color.fromARGB(163, 0, 0, 0),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "   " +
                                        localBox.read("LOCALBOX_JABNAME"),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.assignment_ind,
                                      size: 14.sp,
                                      color: const Color.fromARGB(163, 0, 0, 0),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "   " +
                                        localBox.read("LOCALBOX_PARTNAME"),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.call,
                                      size: 14.sp,
                                      color: const Color.fromARGB(163, 0, 0, 0),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "   " + localBox.read("LOCALBOX_PHONE"),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 0.2.h,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                //set border radius more than 50% of height and width to make circle
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _dateString,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                        // Text(
                        //   _timeString,
                        //   style: GoogleFonts.poppins(
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 15.sp,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                //set border radius more than 50% of height and width to make circle
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 15.h,
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Jangan lupa untuk\nmencatat kehadiranmu!",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (attendancecontroller.listAttendance.isNotEmpty) {
                            Get.to(() => const DetailPresencePage(),
                                arguments: {
                                  "id":
                                      attendancecontroller.listAttendance[0].id,
                                  "title": attendancecontroller
                                      .listAttendance[0].title,
                                  "description": attendancecontroller
                                      .listAttendance[0].description,
                                  "starttime": attendancecontroller
                                      .listAttendance[0].startTime,
                                  "batasstarttime": attendancecontroller
                                      .listAttendance[0].batasStartTime,
                                  "endtime": attendancecontroller
                                      .listAttendance[0].endTime,
                                  "batasendtime": attendancecontroller
                                      .listAttendance[0].batasEndTime
                                });
                          } else {
                            print("List is empty");
                          }
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
                              'Isi Presensi',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                color: Colors
                                    .white, // Ganti dengan warna teks yang diinginkan
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const LocationPage());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    child: SizedBox(
                      height: 10.h,
                      width: 18.w,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: primary,
                              size: 15.0.sp,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text("Kantor & Lokasi",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const HolidayPage());
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: SizedBox(
                        height: 10.h,
                        width: 18.w,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event,
                                color: primary,
                                size: 15.0.sp,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text("Hari Libur",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    if (attendancecontroller.listAttendance.isNotEmpty) {
                      Get.to(() => const DetailPresencePage(), arguments: {
                        "id": attendancecontroller.listAttendance[0].id,
                        "title": attendancecontroller.listAttendance[0].title,
                        "description":
                            attendancecontroller.listAttendance[0].description,
                        "starttime":
                            attendancecontroller.listAttendance[0].startTime,
                        "batasstarttime": attendancecontroller
                            .listAttendance[0].batasStartTime,
                        "endtime":
                            attendancecontroller.listAttendance[0].endTime,
                        "batasendtime":
                            attendancecontroller.listAttendance[0].batasEndTime
                      });
                    } else {
                      print("List is empty");
                    }
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: SizedBox(
                        height: 10.h,
                        width: 18.w,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: primary,
                                size: 15.0.sp,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text("Presensi",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const FormPermissionPage());
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: SizedBox(
                        height: 10.h,
                        width: 18.w,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_add,
                                color: primary,
                                size: 15.0.sp,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text("Ajukan Izin",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const HistoryPage());
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: SizedBox(
                        height: 10.h,
                        width: 18.w,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                color: primary,
                                size: 15.0.sp,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text("Riwayat Presensi",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const FormUpdatePassword());
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: SizedBox(
                        height: 10.h,
                        width: 18.w,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_person,
                                color: primary,
                                size: 15.0.sp,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text("Ubah Password",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 7.5.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      )),
                ),
                // localBox.read("LOCALBOX_ROLENAME") == 'admin'
                resultFace == null
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => const SignUp());
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              //set border radius more than 50% of height and width to make circle
                            ),
                            child: SizedBox(
                              height: 10.h,
                              width: 18.w,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.face_unlock_rounded,
                                      color: primary,
                                      size: 15.0.sp,
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text("Rekam Wajah",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ],
                                ),
                              ),
                            )),
                      )
                    : const SizedBox(width: 1),
              ],
            ),
          ],
        ),
      )));
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'Apakah anda yakin ingin logout?',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                logincontroller.logout();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    final String formattedDateTime2 = _formatDateTime2(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
        _dateString = formattedDateTime2;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm', "id_ID").format(dateTime);
  }

  String _formatDateTime2(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM y', "id_ID").format(dateTime);
  }
}
