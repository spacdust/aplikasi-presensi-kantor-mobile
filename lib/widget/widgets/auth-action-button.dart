import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presencemobile/locator.dart';
import 'package:presencemobile/db/databse_helper.dart';
import 'package:presencemobile/main.dart';
import 'package:presencemobile/model/user.model.dart';
import 'package:presencemobile/utils/app_url.dart';
import 'package:presencemobile/view/home.dart';
import 'package:presencemobile/view/profile.dart';
import 'package:presencemobile/widget/widgets/app_button.dart';
import 'package:presencemobile/services/camera.service.dart';
import 'package:presencemobile/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:dio/dio.dart';

import 'app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();
  final localBox = GetStorage();
  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 50000),
      receiveTimeout: const Duration(seconds: 30000),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      validateStatus: (_) => true,
    ),
  );
  User? predictedUser;

  Future _signUp(context) async {
    DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    List predictedData = _mlService.predictedData;
    // String user = _userTextEditingController.text;
    String user = localBox.read("LOCALBOX_IDUSER");
    //String password = _passwordTextEditingController.text;

    print("idt_user : " +
        localBox.read("LOCALBOX_IDUSER") +
        " || " +
        predictedData.toString());

    // User userToSave = User(
    //   user: user,
    //   password: password,
    //   modelData: predictedData,
    // );
    // await _databaseHelper.insert(userToSave);
    final response = await _dio.post(AppUrl.regisface,
        queryParameters: {"user": user, "faceData": predictedData.toString()});

    print(response);

    this._mlService.setPredictedData([]);
    Navigator.of(context).pop();
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Data Berhasil Disimpan')));
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;
    if (this.predictedUser!.password == password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    this.predictedUser!.user,
                    imagePath: _cameraService.imagePath!,
                  )));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Wrong password!'),
          );
        },
      );
    }
  }

  Future<User?> _predictUser() async {
    User? userAndPass = await _mlService.predict();
    return userAndPass;
  }

  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {
        if (widget.isLogin) {
          var user = await _predictUser();
          if (user != null) {
            this.predictedUser = user;
          }
        }
        PersistentBottomSheetController bottomSheetController =
            Scaffold.of(context)
                .showBottomSheet((context) => signSheet(context));
        bottomSheetController.closed.whenComplete(() => widget.reload());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Container(
                  child: Text(
                    'Welcome back, ' + predictedUser!.user + '.',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : widget.isLogin
                  ? Container(
                      child: Text(
                      'User not found 😞',
                      style: TextStyle(fontSize: 20),
                    ))
                  : Container(),
          Container(
            child: Column(
              children: [
                !widget.isLogin
                    ? Text(
                        'Foto Wajah Diambil!',
                        style: GoogleFonts.poppins(),
                      )
                    // AppTextField(
                    //     controller: _userTextEditingController,
                    //     labelText: "Input ID User",
                    //   )
                    : Container(),
                SizedBox(height: 10),
                // widget.isLogin && predictedUser == null
                //     ? Container()
                //     : AppTextField(
                //         controller: _passwordTextEditingController,
                //         labelText: "Password",
                //         isPassword: true,
                //       ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? AppButton(
                        text: 'LOGIN',
                        onPressed: () async {
                          _signIn(context);
                        },
                        icon: Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      )
                    : !widget.isLogin
                        ? AppButton(
                            text: 'Simpan Data Wajah',
                            onPressed: () async {
                              await _signUp(context);
                            },
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
