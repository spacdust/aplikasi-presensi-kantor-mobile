import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presencemobile/controller/permission_controller.dart';
import 'package:presencemobile/theme/colors.dart';
import 'package:sizer/sizer.dart';

class FormPermissionPage extends StatelessWidget {
  const FormPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PermissionController());
    final textTitle = TextEditingController();
    final textDescription = TextEditingController();
    final FocusNode _titleFocusNode = FocusNode();
    final FocusNode _descriptionFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Form Pengajuan Izin"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                focusNode: _titleFocusNode,
                controller: textTitle,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(19),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 232, 232, 232),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  hintText: 'alasan izin',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 181, 181, 181),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                focusNode: _descriptionFocusNode,
                controller: textDescription,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(19),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 232, 232, 232),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  hintText: 'keterangan izin',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 181, 181, 181),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: primary, // Set your background color
                borderRadius:
                    BorderRadius.circular(25.0), // Set your border radius
              ),
              child: GestureDetector(
                onTap: () {
                  _titleFocusNode.unfocus(); // Close the title field keyboard
                  _descriptionFocusNode
                      .unfocus(); // Close the description field keyboard

                  if (textDescription.text.isEmpty || textTitle.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Alasan / Keterangan harus diisi',
                        ),
                      ),
                    );
                  } else {
                    controller.storePermission(
                      textTitle.text,
                      textDescription.text,
                    );
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.all(15.0), // Adjust padding as needed
                  child: Text(
                    'Buat Pengajuan',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center, // Set your text color
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
