import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:presencemobile/controller/login_controller.dart';
import 'package:presencemobile/locator.dart';
import 'package:presencemobile/theme/colors.dart';
import 'package:presencemobile/view/home.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  await GetStorage.init();
  setupServices();
  initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
  initializeDateFormatting();
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    return Obx(() => loginController.isLogged.value
        ? const GetMaterialApp(
            title: 'Presence App',
            home: HomePage(),
          )
        : const GetMaterialApp(
            title: 'Presence App',
            home: MyHomePage(title: 'Presence App'),
          ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = Get.put(LoginController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Builder(builder: (contextscaf) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                height: 350,
                width: 340,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Silahkan masuk.",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        controller: emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            hintStyle: GoogleFonts.openSans(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            hintText: "Email",
                            fillColor: const Color.fromARGB(7, 0, 0, 0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        obscureText: _isObscure,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none),
                          filled: true,
                          hintStyle: GoogleFonts.openSans(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: "Password",
                          fillColor: const Color.fromARGB(7, 0, 0, 0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: secondary,
                        ),
                        child: TextButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final respon = await controller.login(
                              emailController.text,
                              passwordController.text,
                            );
                            if (respon == "Success") {
                            } else {
                              ScaffoldMessenger.of(contextscaf).showSnackBar(
                                SnackBar(content: Text(respon)),
                              );
                            }
                          },
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        'Catatan: Silahkan masuk menggunakan akun yang telah terdaftar sebelumnya. Hubungi admin, jika terdapat masalah pada akun.',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          );
        }),
      );
    });
  }
}
