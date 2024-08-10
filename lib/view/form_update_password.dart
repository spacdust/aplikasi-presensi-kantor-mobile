import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presencemobile/controller/login_controller.dart';
import 'package:presencemobile/theme/colors.dart';
import 'package:sizer/sizer.dart';

class FormUpdatePassword extends StatefulWidget {
  const FormUpdatePassword({Key? key}) : super(key: key);

  @override
  State<FormUpdatePassword> createState() => _FormUpdatePasswordState();
}

class _FormUpdatePasswordState extends State<FormUpdatePassword> {
  // bool _isObscurePassword1 = true;
  // bool _isObscurePassword2 = true;
  // bool _isObscurePassword3 = true;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final oldpassword = TextEditingController();
    final newpassword1 = TextEditingController();
    final newpassword2 = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Form Update Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                obscureText: true,
                controller: oldpassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  hintStyle: GoogleFonts.openSans(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: "Password Lama",
                  fillColor: const Color.fromARGB(7, 0, 0, 0),
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _isObscurePassword1
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isObscurePassword1 = !_isObscurePassword1;
                  //     });
                  //   },
                  // ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                obscureText: true,
                controller: newpassword1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  hintStyle: GoogleFonts.openSans(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: "Password Baru",
                  fillColor: const Color.fromARGB(7, 0, 0, 0),
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _isObscurePassword2
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isObscurePassword2 = !_isObscurePassword2;
                  //     });
                  //   },
                  // ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                obscureText: true,
                controller: newpassword2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  hintStyle: GoogleFonts.openSans(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: "Konfirmasi Password Baru",
                  fillColor: const Color.fromARGB(7, 0, 0, 0),
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _isObscurePassword3
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isObscurePassword3 = !_isObscurePassword3;
                  //     });
                  //   },
                  // ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
                    final respon = await controller.updatePassword(
                        oldpassword.text, newpassword1.text, newpassword2.text);
                    if (respon == "Success") {
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(respon),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Update Password',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
