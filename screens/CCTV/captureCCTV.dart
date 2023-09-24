// ignore_for_file: file_names, depend_on_referenced_packages, use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, use_build_context_synchronously, avoid_print, unnecessary_string_interpolations, unused_import

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import 'viewCCTV.dart';

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

class _captureCCTVState extends State<captureCCTV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showTextAppBar("Camera"),
      body: cameraHide(),
      floatingActionButton: buttonTakePhoto(context),
    );
  }
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */

  FloatingActionButton buttonTakePhoto(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.camera_alt_outlined),
      onPressed: () async {
        EasyLoading.show(status: 'กำลังส่งข้อมูล...');
        try {
          await _intializeCameraCtrlFuture;
          final path = join(
              (await getTemporaryDirectory()).path, "${DateTime.now()}.png");

          XFile picture = await _cameraCtrl!.takePicture();
          picture.saveTo(path);
          EasyLoading.dismiss();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => viewImageScreen(
                      imagePath: path,
                    )),
          );
        } catch (e) {
          print(e);
        }
      },
    );
  }
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */

  FutureBuilder<void> cameraHide() {
    return FutureBuilder<void>(
      future: _intializeCameraCtrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Visibility(
            visible: false,
            child: CameraPreview(_cameraCtrl!),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */

  AppBar showTextAppBar(String inputTextToShowTitle) {
    return AppBar(
      title: Text("$inputTextToShowTitle"),
    );
  }
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */

  CameraController? _cameraCtrl;
  Future<void>? _intializeCameraCtrlFuture;
  List<CameraDescription>? cameraMe;

  @override
  void initState() {
    super.initState();
    _cameraCtrl = CameraController(cameraMe![1], ResolutionPreset.medium);
    _intializeCameraCtrlFuture = _cameraCtrl!.initialize();
  }

  @override
  void dispose() {
    _cameraCtrl!.dispose();
    super.dispose();
  }
}

class captureCCTV extends StatefulWidget {
  @override
  State<captureCCTV> createState() => _captureCCTVState();
}
