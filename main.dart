// ignore_for_file: camel_case_types, duplicate_import, depend_on_referenced_packages, unnecessary_import, unused_import, prefer_const_constructors, avoid_print, prefer_void_to_null, unused_local_variable, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/CCTV/captureCCTV.dart';
import 'screens/CCTV/viewCCTV.dart';
import 'screens/login.dart';
import 'screens/page/page2ScanAndSave.dart';
import 'screens/page/page3TableMe.dart';
import 'screens/register.dart';
import 'screens/resetPassword.dart';
import 'screens/setting/page7Setting_main.dart';

List<CameraDescription>? cameraMe;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();
  //สำหรับ Run ผ่าน Website
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: "AIzaSyCvqrkdEeIW3m_rxFkJ4PcFusZi3iiz3ak",
  //     //authDomain: "cos4105napoo.firebaseapp.com",
  //     projectId: "cos4105napoo",
  //     //storageBucket: "cos4105napoo.appspot.com",
  //     messagingSenderId: "48423611768",
  //     appId: "1:48423611768:web:18cbef59e7ece15345ec8d",
  //     //measurementId: "G-HLWJ04BFJ7"
  //   ),
  //);
  cameraMe = await availableCameras();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: EasyLoading.init(),
    theme: ThemeData(primaryColor: Colors.teal),
    home: loginScreen(),
  ));
}
