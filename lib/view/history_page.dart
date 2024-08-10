import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presencemobile/controller/presence_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final localBox = GetStorage();
  final controller = Get.put(PresenceController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.getPrecenseTodayByUser(localBox.read("LOCALBOX_IDUSER"));
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
            title: Text(
              "Riwayat Presensi Terakhir",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.listPrecense.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: controller.listPrecense.length > 30
                                    ? 30
                                    : controller.listPrecense.length,
                                itemBuilder: (context, index) {
                                  return SingleChildScrollView(
                                    physics: const ScrollPhysics(),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                //set border radius more than 50% of height and width to make circle
                                              ),
                                              child: SizedBox(
                                                  width: double.infinity,
                                                  height: 15.h,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              color: primary,
                                                              size: 15.sp,
                                                            ),
                                                            SizedBox(
                                                              width: 1.w,
                                                            ),
                                                            Text(
                                                              controller
                                                                  .listPrecense[
                                                                      index]
                                                                  .presenceDate
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12.sp,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: controller
                                                                            .listPrecense[
                                                                                index]
                                                                            .status
                                                                            .toString() ==
                                                                        'Terlambat'
                                                                    ? Colors.red
                                                                    : controller.listPrecense[index].status.toString() ==
                                                                            'Tepat Waktu'
                                                                        ? Colors
                                                                            .green
                                                                        : controller.listPrecense[index].status.toString() ==
                                                                                'Overtime'
                                                                            ? Colors.blue
                                                                            : Colors.yellow,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 3,
                                                                  left: 5.sp,
                                                                  right: 5.sp,
                                                                  bottom: 3,
                                                                ),
                                                                child: Text(
                                                                  controller
                                                                      .listPrecense[
                                                                          index]
                                                                      .status
                                                                      .toString(),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        8.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Row(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  width: 16.h,
                                                                  height: 5.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        240,
                                                                        240,
                                                                        240),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        //Text("asd : " + controller.listPrecense.length.toString()),
                                                                        Text(
                                                                          "Check in",
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                8.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                124,
                                                                                124,
                                                                                124),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          controller
                                                                              .listPrecense[index]
                                                                              .presenceEnterTime
                                                                              .toString()
                                                                              .substring(0, 5),
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                10.sp,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                61,
                                                                                61,
                                                                                61),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  width: 16.h,
                                                                  height: 5.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        240,
                                                                        240,
                                                                        240),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        //Text("asd : " + controller.listPrecense.length.toString()),
                                                                        Text(
                                                                          "Check out",
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                8.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                124,
                                                                                124,
                                                                                124),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          controller.listPrecense[index].presenceOutTime != null
                                                                              ? controller.listPrecense[index].presenceOutTime.toString().substring(0, 5)
                                                                              : '-',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                10.sp,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                61,
                                                                                61,
                                                                                61),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ))),
                                        ]),
                                  );
                                },
                              )
                            : Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        "Tidak ada data riwayat ditemukan.",
                                        style: GoogleFonts.poppins(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w300),
                                      ),
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
