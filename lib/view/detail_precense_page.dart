import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:presencemobile/controller/location_controller.dart';
import 'package:presencemobile/controller/permission_controller.dart';
import 'package:presencemobile/controller/presence_controller.dart';
import 'package:presencemobile/model/location_model.dart';
import 'package:presencemobile/view/face_precense_page.dart';
import 'package:presencemobile/view/form_permission_page.dart';
import 'package:sizer/sizer.dart';
import 'package:presencemobile/controller/holiday_controller.dart';

import '../theme/colors.dart';
import 'package:geocoding/geocoding.dart';

class DetailPresencePage extends StatefulWidget {
  const DetailPresencePage({super.key});

  @override
  State<DetailPresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<DetailPresencePage> {
  String location = 'Belum Mendapatkan Lat dan long, Silahkan tekan button';
  RxString address = 'menunggu ...'.obs;
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  String currentUserId = '';
  String idAtt = Get.arguments['id'].toString();
  String title = Get.arguments['title'].toString();
  String description = Get.arguments['description'].toString();
  String startTime = Get.arguments['starttime'].toString();
  String batasStartTime = Get.arguments['batasstarttime'].toString();
  String endTime = Get.arguments['endtime'].toString();
  String batasEndTime = Get.arguments['batasendtime'].toString();

  TimeOfDay parseTimeOfDay(String timeString) {
    try {
      // Assuming your time string is in 'HH:mm' format
      List<String> parts = timeString.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      return TimeOfDay(hour: hours, minute: minutes);
    } catch (e) {
      print("Error parsing TimeOfDay: $e");
      return TimeOfDay.now(); // or handle the error in another way
    }
  }

  String removeLeadingZeros(String value) {
    // Use regular expressions to remove leading zeros
    return value.replaceAll(RegExp('^0+'), '');
  }

  var selectLoc = false.obs;
  final controller = Get.put(PresenceController());
  final controllerLocation = Get.put(LocationController());
  final controllerPermission = Get.put(PermissionController());
  final controllerHoliday = Get.put(HolidayController());
  final locationValue = Rxn<String>();

  DateTime currentStartTime = DateTime.now();
  DateTime currentbatasStartTime = DateTime.now();
  DateTime currentendTime = DateTime.now();
  DateTime currentbatasEndTime = DateTime.now();
  DateTime now = DateTime.now();

  // final localBox = GetStorage();

  @override
  void initState() {
    super.initState();
    // currentUserId = localBox.read("LOCALBOX_IDUSER");
    controller.getPrecenseTodayByAttendance(idAtt);
    controllerPermission.getPermissionByUser();
    controllerLocation.getLocation();
    controllerHoliday.getHolidayToday();

    TimeOfDay dstartTime = parseTimeOfDay(Get.arguments['batasstarttime']);
    TimeOfDay dbatasStartTime = parseTimeOfDay(Get.arguments['batasstarttime']);
    TimeOfDay dendTime = parseTimeOfDay(Get.arguments['endtime']);
    TimeOfDay dbatasEndTime = parseTimeOfDay(Get.arguments['endtime']);

    currentStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      dstartTime.hour,
      dstartTime.minute,
    );
    currentbatasStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      dbatasStartTime.hour,
      dbatasStartTime.minute,
    );
    currentendTime = DateTime(
      now.year,
      now.month,
      now.day,
      dendTime.hour,
      dendTime.minute,
    );
    currentbatasEndTime = DateTime(
      now.year,
      now.month,
      now.day,
      dbatasEndTime.hour,
      dbatasEndTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localBox = GetStorage();
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Builder(builder: (contextscaf) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: primary,
                title: Text(
                  "Halaman Presensi",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            body: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Container(
                child:
                    //kondisi libur
                    Obx(
                  () => controllerHoliday.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controllerHoliday.listHoliday.length == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 17.h,
                                                  height: 5.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        255, 240, 240, 240),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        //Text("asd : " + controller.listPrecense.length.toString()),
                                                        Text(
                                                          "Masuk",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                124,
                                                                124,
                                                                124),
                                                          ),
                                                        ),
                                                        Text(
                                                          ":",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                124,
                                                                124,
                                                                124),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${startTime.substring(0, 5)} - ${batasStartTime.substring(0, 5)}",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: const Color
                                                                    .fromARGB(
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
                                                Container(
                                                  width: 17.h,
                                                  height: 5.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        255, 240, 240, 240),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        //Text("asd : " + controller.listPrecense.length.toString()),
                                                        Text(
                                                          "Keluar",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                124,
                                                                124,
                                                                124),
                                                          ),
                                                        ),
                                                        Text(
                                                          ":",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                124,
                                                                124,
                                                                124),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${endTime.substring(0, 5)} - ${batasEndTime.substring(0, 5)}",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: const Color
                                                                    .fromARGB(
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
                                            SizedBox(
                                              height: 10.sp,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    description,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              131,
                                                              131,
                                                              131),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    //disini kita buat column, obx yang menangani kondisi libur
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: FutureBuilder<List<Loc>>(
                                        future:
                                            controllerLocation.getLocation(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<Loc>? dataLocation =
                                                snapshot.data;
                                            return Obx(
                                              () => DropdownButton(
                                                hint: Text(
                                                  "Pilih lokasi",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                value: locationValue.value,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down_rounded,
                                                ),
                                                elevation: 16,
                                                isExpanded: true,
                                                underline: Container(
                                                  height: 2,
                                                ),
                                                onChanged: (String? value) {
                                                  //print(value);
                                                  locationValue.value = value;
                                                  controller.presencePermit
                                                      .value = false;
                                                  controller.jarak.value = '-';
                                                  selectLoc.value = true;
                                                },
                                                items: dataLocation!.map<
                                                    DropdownMenuItem<
                                                        String>>((item) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: "${item.id}",
                                                    child: Text(
                                                      item.title.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 11.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(width: 5),
                                        const Icon(
                                          Icons.location_on,
                                          color: primary,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                          width: 5.sp,
                                        ),
                                        Obx(() => Flexible(
                                                child: Text(
                                              "Lokasimu: ${address.value}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 10.sp,
                                              ),
                                            ))),
                                        SizedBox(
                                          width: 5.sp,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Jarak dari titik koordinat : ",
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                  255, 129, 129, 129),
                                            ),
                                          ),
                                          Obx(
                                            () => Text(
                                              removeLeadingZeros(
                                                  controller.jarak.toString()),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 106, 106, 106),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Obx(
                                      () => !controllerPermission.isIzin.value
                                          // ? (controller.isPresensiMasuk.value &&
                                          //         now.isAfter(currentendTime) &&
                                          //         !controller
                                          //             .isPresensiKeluar.value)
                                          ? (controller
                                                      .isPresensiKeluar.value &&
                                                  controller
                                                      .isPresensiMasuk.value)
                                              ? Text(
                                                  "Anda Sudah Melakukan Presensi \nTerimakasih",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              : selectLoc.value
                                                  ? ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  117,
                                                                  191,
                                                                  255),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          padding: const EdgeInsets
                                                                  .all(
                                                              12) //content padding inside button
                                                          ),
                                                      // onPressed: () async {
                                                      //   Position position =
                                                      //       await _getGeoLocationPosition();
                                                      //   setState(() {
                                                      //     location =
                                                      //         '${position.latitude}, ${position.longitude}';
                                                      //     //print(location);
                                                      //     getAddressFromLongLat(
                                                      //         position);
                                                      //     controller.checkLocation(
                                                      //         position.latitude,
                                                      //         position.longitude,
                                                      //         locationValue.value!);
                                                      //     //print(address);
                                                      //   });
                                                      // },
                                                      onPressed: () async {
                                                        try {
                                                          Position position =
                                                              await _getGeoLocationPosition();
                                                          setState(() {
                                                            location =
                                                                '${position.latitude}, ${position.longitude}';
                                                            getAddressFromLongLat(
                                                                position);
                                                            controller
                                                                .checkLocation(
                                                              position.latitude,
                                                              position
                                                                  .longitude,
                                                              locationValue
                                                                  .value!,
                                                            );
                                                          });
                                                        } catch (e) {
                                                          // Handle exceptions here
                                                          print(
                                                              'Exception: $e');
                                                          // Optionally, show a message to the user indicating that there was an issue obtaining the location
                                                          // You can use a snackbar, showDialog, or any other UI element to display the message
                                                        }
                                                      },
                                                      child: Text(
                                                        'Temukan koordinat',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    )
                                                  : Text(
                                                      "Harap menentukan lokasi anda terlebih dahulu sebelum melakukan presensi.",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 9.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  158,
                                                                  158,
                                                                  158)),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                          // : const Text(
                                          //     "Belum saatnya presensi pulang!",
                                          //     textAlign: TextAlign.center,
                                          //     style: TextStyle(
                                          //         color: Colors.red),
                                          //   )
                                          : Text(
                                              "Anda sudah  mengajukan izin. \nTerimakasih!",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    // Obx(() => !controllerPermission.isIzin.value
                                    //     ? !controller.isPresensiForbidden.value
                                    //         ? (controller.isPresensiKeluar
                                    //                     .value &&
                                    //                 controller
                                    //                     .isPresensiMasuk.value)
                                    //             ? const SizedBox()
                                    //             : ElevatedButton(
                                    //                 style: ElevatedButton
                                    //                     .styleFrom(
                                    //                   backgroundColor:
                                    //                       secondary,
                                    //                   elevation: 0,
                                    //                   shape:
                                    //                       RoundedRectangleBorder(
                                    //                     borderRadius:
                                    //                         BorderRadius
                                    //                             .circular(25),
                                    //                   ),
                                    //                 ),
                                    //                 onPressed: () {
                                    //                   Get.to(() =>
                                    //                       const FormPermissionPage());
                                    //                 },
                                    //                 child: SizedBox(
                                    //                   height: 50,
                                    //                   width: double.infinity,
                                    //                   child: Center(
                                    //                     child: Text(
                                    //                       'Pengajuan izin',
                                    //                       style: GoogleFonts
                                    //                           .poppins(
                                    //                               color: Colors
                                    //                                   .white,
                                    //                               fontSize:
                                    //                                   12.sp,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600),
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               )
                                    //         : const SizedBox()
                                    //     : const SizedBox()),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Obx(() => !controllerPermission.isIzin.value
                                        ? !controller.isPresensiForbidden.value
                                            ? (controller.isPresensiKeluar
                                                        .value &&
                                                    controller
                                                        .isPresensiMasuk.value)
                                                ? const SizedBox()
                                                : ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: controller
                                                              .presencePermit
                                                              .value
                                                          ? secondary
                                                          : Colors.grey,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      controller.presencePermit
                                                              .value
                                                          ? {
                                                              Get.to(() =>
                                                                  const SignIn())
                                                            }
                                                          : ScaffoldMessenger.of(
                                                                  contextscaf)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                              content: Text(
                                                                  "Anda berada diluar radius presensi"),
                                                            ));
                                                    },
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: double.infinity,
                                                      child: Center(
                                                        child: Text(
                                                          'Isi Presensi',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                            : const SizedBox()
                                        : const SizedBox()),
                                  ],
                                ),
                              ],
                            )
                          : Center(
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
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  //getLongLAT
  // Future<Position> _getGeoLocationPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   //location service not enabled, don't continue
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location service Not Enabled');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permission denied');
  //     }
  //   }

  //   //permission denied forever
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //       'Location permission denied forever, we cannot access',
  //     );
  //   }
  //   //continue accessing the position of device
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // Location service not enabled, prompt the user to enable it
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location service not enabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    // Permission denied forever
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever, cannot access');
    }

    // Continue accessing the position of the device
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      // Handle any other errors that might occur when obtaining the location
      print('Error getting location: $e');
      throw Exception('Error getting location');
    }
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address.value =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
}
