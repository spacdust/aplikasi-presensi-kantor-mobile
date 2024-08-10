import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:presencemobile/controller/holiday_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

import '../theme/colors.dart';

class HolidayPage extends StatefulWidget {
  const HolidayPage({super.key});

  @override
  State<HolidayPage> createState() => _HolidayPageState();
}

class _HolidayPageState extends State<HolidayPage> {
  final localBox = GetStorage();
  final controller = Get.put(HolidayController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.getHoliday();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: primary,
              title: Text(
                "Daftar Hari Libur",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              )),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.listHoliday.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: controller.listHoliday.length,
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
                                                    BorderRadius.circular(20),
                                                //set border radius more than 50% of height and width to make circle
                                              ),
                                              child: Container(
                                                  width: double.infinity,
                                                  height: 16.h,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              controller
                                                                  .listHoliday[
                                                                      index]
                                                                  .title
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              controller
                                                                  .listHoliday[
                                                                      index]
                                                                  .description
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    126,
                                                                    126,
                                                                    126),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              color: primary,
                                                              size: 15.sp,
                                                            ),
                                                            SizedBox(
                                                              width: 1.h,
                                                            ),
                                                            Text(
                                                              controller
                                                                  .listHoliday[
                                                                      index]
                                                                  .holidayDate
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    126,
                                                                    126,
                                                                    126),
                                                              ),
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
                                        "Tidak ada data libur ditemukan.",
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
