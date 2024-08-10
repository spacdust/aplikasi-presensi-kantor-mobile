import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:presencemobile/controller/location_controller.dart';
import 'package:presencemobile/model/location_model.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/colors.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final localBox = GetStorage();
  final controller = Get.put(LocationController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
            title: Text(
              "Daftar Kantor & Lokasi",
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
                    height: 15,
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.listLocation.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: controller.listLocation.length,
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
                                              height: 15.h,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 20.0,
                                                  right: 20.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          controller
                                                              .listLocation[
                                                                  index]
                                                              .title
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      12.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          controller
                                                              .listLocation[
                                                                  index]
                                                              .description
                                                              .toString(),
                                                          style: GoogleFonts.openSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 10.sp,
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  108,
                                                                  108,
                                                                  108)),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  232,
                                                                  232,
                                                                  232)),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.sp),
                                                            child: Text(
                                                              "Lat : ${controller.listLocation[index].latitude}   Long : ${controller.listLocation[index].longitude}",
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      8.sp,
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      148,
                                                                      148,
                                                                      148)),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          "Radius ",
                                                          style: GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 8.sp,
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  180,
                                                                  180,
                                                                  180)),
                                                        ),
                                                        Text(
                                                          "${controller.listLocation[index].distance} m",
                                                          style: GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 9.sp,
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  180,
                                                                  180,
                                                                  180)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
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
                                        "Tidak ada data lokasi ditemukan.",
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
