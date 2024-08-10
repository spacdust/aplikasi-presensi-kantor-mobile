import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:presencemobile/db/databse_helper.dart';
import 'package:presencemobile/locator.dart';
import 'package:presencemobile/model/user.model.dart';
import 'package:presencemobile/services/camera.service.dart';
import 'package:presencemobile/services/image_converter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:presencemobile/theme/colors.dart';
import 'package:presencemobile/utils/app_url.dart';
import 'package:presencemobile/view/home.dart';
import 'package:presencemobile/view/beranda_page.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import 'package:presencemobile/view/presence_succes.dart';
import 'dart:async';

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.5;
  final localBox = GetStorage();
  late List _facedata;
  List _predictedData = [];
  List get predictedData => _predictedData;
  double minDist = 999;
  double currDist = 0.0;
  CameraService _cameraService = locator<CameraService>();
  CameraController? _cameraController;

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

  Future initialize() async {
    try {
      var interpreterOptions = InterpreterOptions()
        ..addDelegate(GpuDelegateV2());

      this._interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  bool _isProcessing = false;

  Future<void> setCurrentPrediction(CameraImage cameraImage, Face? face) async {
    print('Processing prediction');
    if (_isProcessing) {
      print('Skipped: Already processing');
      return; // Skip if already processing
    }
    _isProcessing = true;
    try {
      print('Processing prediction');
      await _processPrediction(cameraImage, face);
    } catch (e) {
      print('Error in prediction: $e');
    } finally {
      print('Processing completed');
      _isProcessing = false;
    }
  }

  Future<void> _processPrediction(CameraImage cameraImage, Face? face) async {
    if (_interpreter == null || face == null) {
      print('Interpreter or face is null');
      return;
    }

    try {
      List input = _preProcess(cameraImage, face);
      input = input.reshape([1, 112, 112, 3]);
      List output = List.generate(1, (index) => List.filled(192, 0));

      this._interpreter?.run(input, output);
      output = output.reshape([192]);

      // _facedata = json.decode(localBox.read("LOCALBOX_FACEDATA")).toList();
      _facedata = json
          .decode(
              "[-0.0011967658065259457, 0.01158137246966362, -0.01079096831381321, 0.0008316725725308061, -0.007718748413026333, -0.0397539958357811, -0.12158369272947311, -0.004294226877391338, -0.0328802764415741, 0.1530136913061142, -0.009829200804233551, -0.005667543970048428, 0.007855266332626343, -0.006915172096341848, -0.00393437035381794, -0.19422800838947296, -0.03108232095837593, -0.007809878792613745, 0.007794723846018314, -0.007699583191424608, 0.14399872720241547, -0.032576676458120346, -0.17317067086696625, 0.006214183755218983, -0.04611215740442276, -0.008749070577323437, -0.013910414651036263, 0.013133352622389793, 0.07458119839429855, 0.03529088944196701, 0.005998567678034306, 0.21893709897994995, 0.1770130842924118, -0.0011088799219578505, -0.18487073481082916, 0.1378822773694992, -0.19723844528198242, 0.022946616634726524, -0.009551268070936203, 0.1649545133113861, 0.0002429460291750729, -0.002293587662279606, -0.0068172006867825985, 0.006941651925444603, 0.00455464655533433, -0.007690338883548975, -0.05184188112616539, 0.0815146192908287, -0.004036117345094681, 0.008537912741303444, -0.01978321000933647, -0.0002472907362971455, -0.3200360834598541, 0.0009052456589415669, 0.040110621601343155, 0.007043486461043358, -0.07613372802734375, 0.00399528443813324, 0.012984829023480415, -0.004453761037439108, -0.029544001445174217, 0.06806588172912598, -0.0963151603937149, 0.2848721146583557, -0.002225187374278903, 0.1695283204317093, -0.004745387472212315, -0.019627610221505165, 0.010217576287686825, -0.0011498518288135529, -0.007659477181732655, -0.31874802708625793, 0.1329239457845688, -0.000720138952601701, 0.012715773656964302, -0.0007302231970243156, -0.0030624978244304657, -0.0009961924515664577, 0.07145127654075623, 0.04045850783586502, 0.005689446814358234, 0.09376618266105652, -0.006963037420064211, 0.013566609472036362, -0.0028061755001544952, 0.001341581461019814, -0.0057907323352992535, -0.016868997365236282, -0.0364329032599926, 0.021864891052246094, -0.0867222473025322, 0.0035007395781576633, 0.002957453951239586, -0.0038264403119683266, -0.08608882129192352, 0.06874386221170425, -0.015014316886663437, -0.0020313996355980635, -0.004166607744991779, 0.027820134535431862, 0.001610747305676341, -0.0038929509464651346, -0.0016761267324909568, -0.0016615529311820865, 0.008298370987176895, 0.00373582704924047, 0.06071563810110092, 0.0015549736563116312, 0.007296492345631123, 0.008141567930579185, -0.10821696370840073, 0.0021089406218379736, 0.011242657899856567, 0.11742214858531952, -0.0005263385828584433, -0.08111286908388138, 0.01538042165338993, -0.014033238403499126, 0.2528596520423889, -0.12050490826368332, 0.04412265866994858, -0.004859270993620157, 0.1092035174369812, -0.00004783540134667419, -0.0011013047769665718, 0.005509484559297562, 0.008178094401955605, -0.0025576725602149963, -0.002023197477683425, -0.07909468561410904, 0.006348499096930027, 0.01061493530869484, -0.00256605283357203, -0.05277077853679657, -0.01211086381226778, -0.0028793090023100376, -0.006857312750071287, 0.016480784863233566, 0.010619970969855785, -0.010428134351968765, 0.00635362695902586, -0.0029174506198614836, 0.003919071517884731, -0.08766273409128189, -0.11980003118515015, 0.03942989930510521, -0.027979303151369095, 0.01455521397292614, 0.004339765757322311, 0.014831221662461758, -0.020287901163101196, -0.06897619366645813, -0.004146963823586702, -0.013853495940566063, 0.00019805275951512158, 0.0024061943404376507, 0.018025808036327362, -0.009646818041801453, 0.16494882106781006, -0.002589820185676217, 0.011476456187665462, 0.004046554211527109, 0.00603765994310379, -0.005081286188215017, 0.004330683499574661, 0.0005536918761208653, 0.0117896543815732, -0.12056491523981094, -0.005058988928794861, -0.0021547337528318167, -0.15748919546604156, -0.025843864306807518, -0.0009349723113700747, -0.10861936211585999, 0.014452002942562103, -0.003468912560492754, 0.01643946021795273, 0.022035516798496246, -0.0036358688957989216, -0.0017746123485267162, -0.01648206263780594, 0.037565965205430984, 0.008666442707180977, -0.0034029914531856775, -0.026117105036973953, 0.016185129061341286, -0.022126752883195877, -0.0022452068515121937, 0.038336075842380524, 0.028818948194384575, -0.01564331352710724, -0.008519120514392853]")
          .toList();
      currDist = _euclideanDistance(_facedata, List.from(output));

      if (currDist <= threshold && currDist < minDist) {
        await _handleSuccessfulPresence();
      }

      this._predictedData = List.from(output);
    } catch (e) {
      print('Error in processing prediction: $e');
    }
  }

  bool _isDataStored = false; // Move this declaration to the class level

  Future<void> _handleSuccessfulPresence() async {
    try {
      // Check if data is already stored
      if (_isDataStored) {
        print('Skipped: Data already stored');
        return;
      }

      Position position;
      try {
        position = await _getGeoLocationPosition();
      } catch (e) {
        print('Error getting location: $e');
        // Handle the error getting the location as needed
        return;
      }

      // Mark that data has been stored to avoid duplicate storage
      _isDataStored = true;

      // Separate function for data storage
      await _storeData(position);
    } catch (e) {
      print('Error in processing: $e');
      // Handle the error as needed
    } finally {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);

      try {
        await _cameraController?.stopImageStream();
      } catch (e) {
        print('Error stopping image stream: $e');
        // Handle the error stopping the image stream as needed
      }

      // Commenting out the Get.off for now
      Get.off(() => PresenceSucces());

      // Show Snackbar without navigating
      Get.snackbar(
        localBox.read("LOCALBOX_NAME") + " Berhasil Presensi !!!",
        formattedDate,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(
          top: 20,
          right: 10,
          left: 20,
        ),
      );

      // Reset the flag after a short delay
      await Future.delayed(
          Duration(seconds: 2)); // Adjust the duration as needed
      _isDataStored = false;
    }
  }

  Future<void> _storeData(Position position) async {
    try {
      await _dio.post(AppUrl.storePresence, queryParameters: {
        "attendance_id": localBox.read("LOCALBOX_ATTID"),
        "id_user": localBox.read("LOCALBOX_IDUSER"),
        "location": position.toString(),
      });
    } catch (e) {
      print('Error storing data: $e');
      // Handle the error as needed
      throw e; // Re-throw the exception to indicate failure
    }
  }

  Future<User?> predict() async {
    return _searchResult(this._predictedData);
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  Future<User?> _searchResult(List predictedData) async {
    print("masuk search result");
    //DatabaseHelper _dbHelper = DatabaseHelper.instance;

    //List<User> users = await _dbHelper.queryAllUsers();
    //double minDist = 999;
    //double currDist = 0.0;
    User? predictedResult;

    print("masuk search result 1");
    //print('users.length=> ${users.length}');

    _facedata = json.decode(localBox.read("LOCALBOX_FACEDATA")).toList();
    currDist = _euclideanDistance(_facedata, predictedData);

    print("masuk search result 2");
    print("currDist : " + currDist.toString());
    print("threshold : " + threshold.toString());

    if (currDist <= threshold && currDist < minDist) {
      minDist = currDist;
      predictedResult?.modelData = _facedata;
      predictedResult?.user = localBox.read("LOCALBOX_NAME");
    }
    // for (User u in users) {
    //   currDist = _euclideanDistance(u.modelData, predictedData);
    //   if (currDist <= threshold && currDist < minDist) {
    //     minDist = currDist;
    //     predictedResult = u;
    //   }
    // }
    return predictedResult;
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  dispose() {}
}
