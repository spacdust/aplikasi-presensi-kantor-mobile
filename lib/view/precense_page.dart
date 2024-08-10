import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:presencemobile/controller/attendance_controller.dart';
import 'package:presencemobile/controller/holiday_controller.dart';
import 'package:presencemobile/view/detail_precense_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

import '../theme/colors.dart';

class PresencePage extends StatefulWidget {
  const PresencePage({super.key});

  @override
  State<PresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  final localBox = GetStorage();
  final controller = Get.put(AttendanceController());
  final controllerHoliday = Get.put(HolidayController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.getAttendanceByPosition();
    controllerHoliday.getHolidayToday();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
            title: Text(
              "Daftar Jadwal Presensi",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => controllerHoliday.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : controllerHoliday.listHoliday.length == 0
                            ? controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : controller.listAttendance.length > 0
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        controller: _scrollController,
                                        itemCount:
                                            controller.listAttendance.length,
                                        itemBuilder: (context, index) {
                                          return SingleChildScrollView(
                                            physics: const ScrollPhysics(),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        //set border radius more than 50% of height and width to make circle
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          DateTime now =
                                                              DateTime.now();
                                                          DateFormat
                                                              dateFormat =
                                                              new DateFormat
                                                                  .Hm();
                                                          DateTime startTime =
                                                              dateFormat.parse(
                                                                  controller
                                                                      .listAttendance[
                                                                          index]
                                                                      .startTime
                                                                      .toString());
                                                          DateTime
                                                              batasStartTime =
                                                              dateFormat.parse(controller
                                                                  .listAttendance[
                                                                      index]
                                                                  .batasStartTime
                                                                  .toString());
                                                          DateTime endTime = dateFormat
                                                              .parse(controller
                                                                  .listAttendance[
                                                                      index]
                                                                  .endTime
                                                                  .toString());
                                                          DateTime
                                                              batasEndTime =
                                                              dateFormat.parse(controller
                                                                  .listAttendance[
                                                                      index]
                                                                  .batasEndTime
                                                                  .toString());

                                                          startTime =
                                                              new DateTime(
                                                                  now.year,
                                                                  now.month,
                                                                  now.day,
                                                                  startTime
                                                                      .hour,
                                                                  startTime
                                                                      .minute);
                                                          batasStartTime =
                                                              new DateTime(
                                                                  now.year,
                                                                  now.month,
                                                                  now.day,
                                                                  batasStartTime
                                                                      .hour,
                                                                  batasStartTime
                                                                      .minute);
                                                          endTime =
                                                              new DateTime(
                                                                  now.year,
                                                                  now.month,
                                                                  now.day,
                                                                  endTime.hour,
                                                                  endTime
                                                                      .minute);
                                                          batasEndTime =
                                                              new DateTime(
                                                                  now.year,
                                                                  now.month,
                                                                  now.day,
                                                                  batasEndTime
                                                                      .hour,
                                                                  batasEndTime
                                                                      .minute);
                                                          now = new DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              now.hour,
                                                              now.minute);

                                                          // print(now.isAfter(startTime));
                                                          // print(now.isBefore(batasStartTime));
                                                          // print(now.isAfter(endTime));
                                                          // print(now.isBefore(batasEndTime));
                                                          // print(now);

                                                          if ((now.isAfter(
                                                                      startTime) &&
                                                                  now.isBefore(
                                                                      batasStartTime)) ||
                                                              (now.isAfter(
                                                                      endTime) &&
                                                                  now.isBefore(
                                                                      batasEndTime))) {
                                                            Get.to(
                                                                () =>
                                                                    const DetailPresencePage(),
                                                                arguments: {
                                                                  "id": controller
                                                                      .listAttendance[
                                                                          0]
                                                                      .id,
                                                                  "title":
                                                                      controller
                                                                          .listAttendance[
                                                                              0]
                                                                          .title
                                                                });
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('Belum memasuki waktu presensi')));
                                                          }
                                                        },
                                                        child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 20.h,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      18.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    controller
                                                                        .listAttendance[
                                                                            index]
                                                                        .title
                                                                        .toString(),
                                                                    style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14.sp),
                                                                  ),
                                                                  Text(
                                                                    controller
                                                                        .listAttendance[
                                                                            index]
                                                                        .description
                                                                        .toString(),
                                                                    style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  Text(
                                                                    "Masuk : " +
                                                                        controller
                                                                            .listAttendance[
                                                                                index]
                                                                            .startTime
                                                                            .toString() +
                                                                        " - " +
                                                                        controller
                                                                            .listAttendance[index]
                                                                            .batasStartTime
                                                                            .toString(),
                                                                    style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        fontSize:
                                                                            10.sp),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "Pulang : " +
                                                                            controller.listAttendance[index].endTime.toString() +
                                                                            " - " +
                                                                            controller.listAttendance[index].batasEndTime.toString(),
                                                                        style: GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontSize: 10.sp),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .fingerprint,
                                                                        color:
                                                                            primary,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                      )),
                                                ]),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Image(
                                                image: const AssetImage(
                                                  'assets/images/no-data.png',
                                                ),
                                                width: 70.w,
                                              ),
                                              Text(
                                                "Tidak ada data jadwal ditemukan.",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13.sp,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 15.0.h,
                                      ),
                                      Image(
                                        image: const AssetImage(
                                            'assets/images/holiday.png'),
                                        width: 70.w,
                                      ),
                                      SizedBox(
                                        height: 2.0.h,
                                      ),
                                      Text(
                                        "Hari ini adalah hari libur.",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),

                                      // Text(
                                      //     controllerHoliday.listHoliday[0].title
                                      //         .toString(),
                                      //     style: GoogleFonts.poppins(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w500,
                                      //     )),
                                      // Text(
                                      //     controllerHoliday
                                      //         .listHoliday[0].description
                                      //         .toString(),
                                      //     style: GoogleFonts.poppins(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w400,
                                      //     )),
                                    ],
                                  ),
                                ),
                              ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
