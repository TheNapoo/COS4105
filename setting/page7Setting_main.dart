// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unnecessary_import, depend_on_referenced_packages, camel_case_types, unnecessary_string_interpolations, unnecessary_new, unnecessary_this, slash_for_doc_comments, prefer_const_literals_to_create_immutables, unused_import, avoid_print, library_prefixes, deprecated_member_use, unnecessary_null_comparison, file_names

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

import '../../model/buttonSignOut.dart';
import '../../model/universal.dart';
import '../../model/user_model.dart';
import '../page/page2ScanAndSave.dart';
import '../page/page3TableMe.dart';
import '../page/page4ChartMe.dart';
import '../resetPassword.dart';
import 'fingerPrintScreen.dart';
import 'setting_editProfile.dart';

class _settingMainScreenState extends State<settingMainScreen> {
  //************************************************************* */
  //*******************************showChartFirebaseCircle************************** */
  //************************************************************* */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppBar(),
      drawer: myDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            labelSetting(),
            //**************************** */
            //Account Setting
            settingHeaderMenuAccount(iconAccount(), "บัญชีผู้ใช้"),
            lineUnderMenu(),
            sizeBoxHeigh(10),
            areaEditProfile(context, "แก้ไขข้อมูลส่วนตัว", page5FingerPrint()),
            areaResetPassword(
                context, "เปลี่ยนรหัสผ่าน", resetPasswordScreen()),

            //************************************************** */
            //ตั้งค่าอินเตอร์เน็ต
            sizeBoxHeigh(50),
            settingHeaderMenuAccount(iconOrther(), "ตั้งค่าอินเตอร์เน็ต"),
            lineUnderMenu(),
            areaSettingOrther(context, "Wifi", AppSettingsType.wifi),
            areaSettingOrther(
                context, "อินเตอร์เน็ตเครือข่าย", AppSettingsType.dataRoaming),
            //**************************** */
            //ตั้งค่าอื่น ๆ
            sizeBoxHeigh(50),
            settingHeaderMenuAccount(iconOrther(), "ตั้งค่าอื่น ๆ "),
            lineUnderMenu(),

            areaSettingOrther(
              context,
              "ข้อมูลแอพพลิเคชั่น",
              AppSettingsType.settings,
            ),
            areaSettingOrther(
              context,
              "การแจ้งเตือน",
              AppSettingsType.notification,
            ),
            areaSettingOrther(
              context,
              "วันที่ เวลา",
              AppSettingsType.date,
            ),
            areaSettingOrther(
              context,
              "จอภาพแสดงผล",
              AppSettingsType.display,
            ),

            //************************************************** */
            //พื้นที่ช่วยเหลือ
            sizeBoxHeigh(50),
            settingHeaderMenuAccount(
              iconHelp(),
              "ช่วยเหลือ",
            ),
            lineUnderMenu(),
            areaSettingContact(
              context,
              "ติดต่อเรา",
            ),
            areaSettingBook(
              context,
              "คู่มือการใช้งาน",
              page5FingerPrint(),
            ),
            //************************************************** */
            sizeBoxHeigh(50),
            //พื้นที่การแจ้งเตือน
            // sizeBoxHeigh(40),
            // settingMenuAccount(iconVolumn(), "ข้อมูลคาร์บอนของฉัน"),
            // lineUnderMenu(),
            // builNotification(
            //   "อนุญาตให้ลบข้อมูลได้",
            //   value1,
            //   onChangeMethod1,
            // ),
            //************************************************** */
          ],
        ),
      ),
    );
  }

  //************************************************************* */
  //*******************************initState************************** */
  //************************************************************* */
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());

      setState(() {
        firstName = TextEditingController(text: "${loggedInUser.firstName}");
        secondName = TextEditingController(text: "${loggedInUser.secondName}");
        email = TextEditingController(text: "${loggedInUser.email}");
      });
    });
    saveValueToSharedPreferences(valueOpenCloseDelTable);
  }

  //************************************************************* */
  //*******************************titleAppBar************************** */
  //************************************************************* */s

  AppBar titleAppBar() {
    return AppBar(
      title: const Text('ตั้งค่า'),
    );
  }

  //************************************************************* */
  //*******************************onChangeMethod1************************** */
  //************************************************************* */

  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  onChangeMethod1(bool newValue1) {
    setState(() {
      value1 = newValue1;
      //Fluttertoast.showToast(msg: "value1 : $value1");

      if (value1 == true) {
        Fluttertoast.showToast(
            msg: "อนุญาตให้ลบข้อมูลการบันทึกคาร์บอนฟุตพริ้นท์");
        valueOpenCloseDelTable = true;
      } else {
        Fluttertoast.showToast(
            msg: "ไม่อนุญาตให้ลบข้อมูลการบันทึกคาร์บอนฟุตพริ้นท์");
        valueOpenCloseDelTable = false;
      }
      saveValueToSharedPreferences(valueOpenCloseDelTable);
    });
  }

  Future<void> saveValueToSharedPreferences(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('valueOpenCloseDelTable', value);
  }

  onChangeMethod2(bool newValue2) {
    setState(() {
      value2 = newValue2;
    });
  }

  onChangeMethod3(bool newValue3) {
    setState(() {
      value3 = newValue3;
    });
  }

  //************************************************************* */
  //*******************************builNotification************************** */
  //************************************************************* */

  Padding builNotification(String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showTextSetting(title),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
              value: value,
            ),
          ),

          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.delete),
          // ),
        ],
      ),
    );
  }

  //************************************************************* */
  //*******************************titleSetting************************** */
  //************************************************************* */

  Row titleSetting(String inputTitle) {
    return Row(
      children: [
        Icon(
          Icons.help_center,
          color: Colors.blue,
        ),
        sizeBoxHeigh(10),
        showTextSetting(inputTitle),
      ],
    );
  }

  //************************************************************* */
  //*******************************lineUnderMenu************************** */
  //************************************************************* */

  Divider lineUnderMenu() {
    return Divider(
      height: 20,
      thickness: 1,
    );
  }

  //************************************************************* */
  //*******************************settingMenuAccount************************** */
  //************************************************************* */

  Padding settingHeaderMenuAccount(Icon selectIcon, String titleHeaderSetting) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        children: [
          selectIcon,
          sizeBoxHeigh(20),
          showText("$titleHeaderSetting")
        ],
      ),
    );
  }

  Widget settingMenuAccount2(Icon icon, String label) {
    return Row(
      children: [
        icon,
        SizedBox(width: 10), // ใส่ระยะห่างระหว่าง Icon กับ Label ตามต้องการ
        Text(
          label,
          style: TextStyle(
            fontSize: 16, // ตั้งค่าขนาดตัวอักษรตามต้องการ
            color: Colors.black, // ตั้งค่าสีตัวอักษรตามต้องการ
          ),
        ),
      ],
    );
  }

  //************************************************************* */
  //*******************************headerAccountDraw************************** */
  //************************************************************* */

  bool? statusLoadingImageAccount;
  UserAccountsDrawerHeader headerAccountDraw() {
    return UserAccountsDrawerHeader(
      //margin: EdgeInsets.all(10),
      otherAccountsPictures: [],
      decoration: BoxDecoration(
        color:
            CustomTextStyle().setColorDrawerHeader(), // สีพื้นหลังที่คุณต้องการ
      ),
      accountName: Text(
        "${loggedInUser.firstName} ${loggedInUser.secondName}",
        style: CustomTextStyle.nameOfTextStyle,
      ),
      accountEmail: Text(
        "Email :  ${loggedInUser.email}",
        style: CustomTextStyle.nameOfTextStyle,
      ),
      currentAccountPicture: () {
        if (statusLoadingImageAccount == true) {
          return CircularProgressIndicator();
        } else {
          if (loggedInUser.pathImage == null) {
            return Image.network("$imagePhotoHeaderDrawerBegin", loadingBuilder:
                (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
              {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return CircularProgressIndicator();
                }
              }
            });
          } else {
            return Image.network("${loggedInUser.pathImage}", loadingBuilder:
                (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
              {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
            });
          }
        }
      }(),
    );
  }
  //************************************************************* */
  //*******************************myDrawer************************** */
  //************************************************************* */

  Drawer myDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          headerAccountDraw(),
          drawerGuide(
            context,
            CustomTextStyle.menuShow,
            CustomTextStyle.collorMenuShow(),
          ),
          drawerScanAndSaveCarbon(
            context,
            CustomTextStyle.menuShow,
            CustomTextStyle.collorMenuShow(),
          ),
          drawerTableCarbonMe(
            context,
            CustomTextStyle.menuShow,
            CustomTextStyle.collorMenuShow(),
          ),
          drawerChartCarbonMe(
            context,
            CustomTextStyle.menuShow,
            CustomTextStyle.collorMenuShow(),
          ),
          drawerSetting(
            context,
            CustomTextStyle.menuCurrent,
            CustomTextStyle.colorMenuCurrent(),
            statusCurrentMenu: true,
          ),
          MySignOut(),
        ],
      ),
    );
  }

  //************************************************************* */
  //*******************************myHeaderDrawer************************** */
  //************************************************************* */

  UserAccountsDrawerHeader myHeaderDrawer() {
    return UserAccountsDrawerHeader(
        accountName: Text(
          "ยินดีต้อนรับคุณ ${loggedInUser.firstName} ${loggedInUser.secondName}",
          style: CustomTextStyle.showNameAndEmail,
        ),
        accountEmail: Text(
          "${loggedInUser.email}",
          style: CustomTextStyle.showNameAndEmail,
        ),
        currentAccountPicture: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Image.network("${loggedInUser.pathImage}"),
        ));
  }

  //************************************************************* */
  //*******************************iconMenuSetting************************** */
  //************************************************************* */

  Icon iconAccount() {
    return Icon(
      Icons.person,
      color: Colors.blue,
    );
  }

  //************************************************************* */
  //*******************************iconVolumn************************** */
  //************************************************************* */

  Icon iconVolumn() {
    return Icon(
      Icons.volume_down,
      color: Colors.blue,
    );
  }

  //************************************************************* */
  //*******************************iconHelp************************** */
  //************************************************************* */
  Icon iconHelp() {
    return Icon(
      Icons.help,
      color: Colors.blue,
    );
  }

  //************************************************************* */
  //*******************************iconOrther************************** */
  //************************************************************* */
  Icon iconOrther() {
    return Icon(
      Icons.other_houses_rounded,
      color: Colors.blue,
    );
  }

  //************************************************************* */
  //*******************************buttonEditProfile************************** */
  //************************************************************* */
  Center buttonEditProfile() {
    return Center(
      child: ElevatedButton(
        child: const Text('แก้ไขโปรไฟล์'),
        onPressed: () => editProfile(),
      ),
    );
  }

  //************************************************************* */
  //*******************************welcomeSetting************************** */
  //************************************************************* */
  Text labelSetting() {
    return Text(
      'การตั้งค่า',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    );
  }

  //************************************************************* */
  //*******************************areaEditName************************** */
  //************************************************************* */

  GestureDetector areaEditName(
      BuildContext context, String title, Function inputFunc) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => inputFunc()));
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

  //************************************************************* */
  //*******************************areaEditProfile************************** */
  //************************************************************* */
  GestureDetector areaEditProfile(
      BuildContext context, String title, Widget inputFunc) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => page5FingerPrint()));
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

  //************************************************************* */
  //*******************************areaEditProfile************************** */
  //************************************************************* */
  GestureDetector areaEditProfile2(
      BuildContext context, String title, Widget inputFunc) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => page5FingerPrint()));
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

  //************************************************************* */
  //*******************************areaSettingContact************************** */
  //************************************************************* */
  GestureDetector areaSettingContact(
    BuildContext context,
    String title,
  ) {
    return GestureDetector(
      onTap: () {
        launch("tel://0633808281");
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

  //************************************************************* */
  //*******************************areaSettingContact************************** */
  //************************************************************* */
  GestureDetector areaSettingOrther(
      BuildContext context, String title, AppSettingsType inputAppSettingType) {
    return GestureDetector(
      onTap: () {
        AppSettings.openAppSettings(type: inputAppSettingType);
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

  //************************************************************* */
  //*******************************areaSettingBook************************** */
  //************************************************************* */

  GestureDetector areaSettingBook(
      BuildContext context, String title, Widget inputFunc) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => page5FingerPrint()));
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

  //************************************************************* */
  //*******************************areaResetPassword************************** */
  //************************************************************* */

  GestureDetector areaResetPassword(
      BuildContext context, String title, Widget inputFunc) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => resetPasswordScreen()));
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

  //************************************************************* */
  //*******************************DeviceInfoPlugin************************** */
  //************************************************************* */
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? androidDeviceInfo;
  Future<AndroidDeviceInfo> getInfo() async {
    return await deviceInfo.androidInfo;
  }

  //************************************************************* */
  //*******************************Firebase************************** */
  //************************************************************* */
  UserModel loggedInUser =
      UserModel(null, null, null, null, "$imageAccountBegin()");
  User? user = FirebaseAuth.instance.currentUser;
  //editting controller
  TextEditingController firstName = new TextEditingController();
  TextEditingController secondName = new TextEditingController();
  TextEditingController email = new TextEditingController();

  //fingerprint
  final LocalAuthentication auth = LocalAuthentication();
}

class settingMainScreen extends StatefulWidget {
  const settingMainScreen({Key? key}) : super(key: key);
  @override
  State<settingMainScreen> createState() => _settingMainScreenState();
}
