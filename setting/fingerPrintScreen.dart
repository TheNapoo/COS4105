// ignore_for_file: file_names, camel_case_types, avoid_print, prefer_const_constructors, use_build_context_synchronously, unused_import, unused_local_variable, sort_child_properties_last

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../../model/universal.dart';
import 'setting_editProfile.dart';
import 'page7Setting_main.dart';

class _page5FingerPrintState extends State<page5FingerPrint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ยืนยันตัวตน"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => settingMainScreen()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward_sharp),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => page5FingerPrint()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Visibility(
            visible: false,
            child: FutureBuilder<void>(
              future: authinticate(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // แสดง Widget ที่คุณต้องการเมื่อ Future เสร็จสิ้น
                  print("ok");
                  return Text(""); // ส่งค่า null กลับไป
                }
              },
            ),
          ),
          Visibility(
            child: areaGotoSettingLockPassword(context, "ตั้งรหัสล็อคหน้าจอ"),
            visible: true,
          )
        ]),
      ),
    );
  }

  GestureDetector areaGotoSettingLockPassword(
      BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        AppSettings.openAppSettings(type: AppSettingsType.lockAndPassword);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          showTextSetting(title),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ]),
      ),
    );
  }

  final LocalAuthentication auth = LocalAuthentication();
  Future<void> authinticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'สแกนลายนิ้วมือ เพื่อเข้าถึงการแก้ไขข้อมูลส่วนตัว',
        options: const AuthenticationOptions(
            useErrorDialogs: false, stickyAuth: true),
      );
      if (didAuthenticate == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => editProfile()));
      } else {
        Scaffold(
          appBar: AppBar(title: Text("ok")),
        );
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        Text("กรุณาตั้งค่าลายนิ้วมือ");
        print("159159");
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        print("159159");
      } else {
        print("159159");
      }
    }
  }
}

class page5FingerPrint extends StatefulWidget {
  const page5FingerPrint({super.key});

  @override
  State<page5FingerPrint> createState() => _page5FingerPrintState();
}
