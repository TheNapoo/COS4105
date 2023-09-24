// ignore_for_file: slash_for_doc_comments, prefer_const_constructors, unnecessary_this, unnecessary_string_interpolations, unnecessary_null_comparison, avoid_print, prefer_single_quotes, prefer_void_to_null, use_function_type_syntax_for_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:NapooCarboon/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login.dart';
import '../screens/page/page1Guide.dart';
import '../screens/page/page2ScanAndSave.dart';
import '../screens/page/page4ChartMe.dart';
import '../screens/page/page3TableMe.dart';
import '../screens/setting/page7Setting_main.dart';

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */
Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: ListTile(
              //leading: Icon(Icons.warning_amber),
              leading: phtoWarning(),
              title: Text(title),
              subtitle: Text(message),
            ),
            children: [buttonOk(context)],
          ));
}

BoxDecoration setColorBackgroundHeaderDrawer() {
  return BoxDecoration(
    color: CustomTextStyle().setColorDrawerHeader(), // สีพื้นหลังที่คุณต้องการ
  );
}

ClipRRect imageAccountDrawer(String inputImage, double inputRadius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(inputRadius),
    child: Image.network("$inputImage", loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      {
        if (loadingProgress == null) {
          return child;
        } else {
          //กรณี โหลดรูปภาพไม่สำเร็จ
          return CircularProgressIndicator();
        }
      }
    }),
  );
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

TextButton buttonOk(BuildContext context) {
  return TextButton(
      onPressed: () => Navigator.pop(context), child: Text("รับทราบ"));
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

Image phtoWarning() {
  return Image.network(
      "https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/%E0%B8%84%E0%B8%B3%E0%B9%80%E0%B8%95%E0%B8%B7%E0%B8%AD%E0%B8%99.png?alt=media&token=c96407f5-cae9-456f-824f-cdaf42117368");
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

Future<Null> normalDialogOkCancel(
    BuildContext context, String title, String message) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: ListTile(
            leading: photoExit(),
            title: Text(title),
            subtitle: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'ใช่');
                await clearUserData();
                await Firebase.initializeApp().then((value) async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const loginScreen()),
                    );
                  });
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

Future<Null> delDataOKCancel(
    BuildContext context, String title, String message) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: ListTile(
            leading: photoExit(),
            title: Text(title),
            subtitle: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(
                  context,
                );

                await clearUserData();
                await Firebase.initializeApp().then((value) async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const loginScreen()),
                    );
                  });
                });
              },
              child: const Text('ใช่ ต้องการออกจากระบบ'),
            ),
          ],
        );
      });
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

Future<void> clearUserData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('email');
  prefs.remove('password');
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

Future<Null> dialogSort(
    BuildContext context, String title, String message) async {
  String selectedOption = 'มากกว่า'; // ตัวแปรเพื่อเก็บค่าที่เลือกใน Dropdown

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: ListTile(
          leading: photoExit(),
          title: Text(title),
          subtitle: Text(message),
        ),
        content: DropdownButton<String>(
          value: selectedOption,
          onChanged: (newValue) {
            selectedOption = newValue!;
          },
          items: <String>['มากกว่า', 'น้อยกว่า']
              .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
        ),

        //ส่วนปุ่มด้านล่าง
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, selectedOption); // ส่งค่าที่เลือกกลับไป
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

TextButton buttonComfirnSignOut(BuildContext context) {
  return TextButton(
    onPressed: () async {
      Navigator.pop(context, 'ใช่');
      await Firebase.initializeApp().then((value) async {
        await FirebaseAuth.instance.signOut().then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const loginScreen()),
          );
        });
      });
    },
    child: const Text('ตกลง'),
  );
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

TextButton buttonCancel(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.pop(context, 'Cancel'),
    child: const Text('ยกเลิก'),
  );
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

Image photoExit() {
  return Image.network(
      "https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/%E0%B8%97%E0%B8%B2%E0%B8%87%E0%B8%AD%E0%B8%AD%E0%B8%812.jpg?alt=media&token=3c397606-92fa-471a-a616-d44e8325eaa7");
}

//************************************************************* */
//******************************Main*************************** */
//************************************************************* */

class _UniversalState extends State<Universal> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(null, null, null, null,
      "https://firebasestorage.googleapis.com/v0/b/emailpassword-5e319.appspot.com/o/profile%2FuserAccount.jpg?alt=media&token=59dbcaa7-3caa-46e1-91fc-635506c9c7e8");

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
        //  firstName = TextEditingController(text: "${loggedInUser.firstName}");
        //  secondName = TextEditingController(text: "${loggedInUser.secondName}");
        //  email = TextEditingController(text: "${loggedInUser.email}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Page Edit Profile มีความพร้อม");
    return Text("ok");
  }

//Drawer
  Text labelFirstNameAndLastNameInHeaderDrawer() {
    return Text(
      "${loggedInUser.firstName} ${loggedInUser.secondName}",
      style: CustomTextStyle.nameOfTextStyle,
    );
  }

  //************************************************************* */
//******************************Main*************************** */
//************************************************************* */
  bool? isImageLoading2;
  UserAccountsDrawerHeader headerAccountDraw() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        "${loggedInUser.firstName} ${loggedInUser.secondName}",
        style: CustomTextStyle.nameOfTextStyle,
      ),
      accountEmail: Text("Email :  ${loggedInUser.email}"),
      currentAccountPicture: () {
        if (isImageLoading2 == true) {
          return CircularProgressIndicator();
        } else {
          //กรณีผู้ใช้ไม่ใส่รูปภาพเริ่มต้น
          if (loggedInUser.pathImage == null) {
            Fluttertoast.showToast(msg: "คำสั่งบนนี้ทำงาน");
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // ทำให้เป็นวงกลม
                border: Border.all(
                  color: Colors.black, // สีขอบ
                  width: 2.0, // ขนาดขอบ
                ),
              ),
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/placeholder.png",
                  image: "$imagePhotoHeaderDrawerBegin",
                  fit: BoxFit.cover,
                  width: 100,
                  height: 50,
                ),
              ),
            );
          } else {
            //************************************* */
            Fluttertoast.showToast(msg: "คำสั่งล่างทำงาน");
            return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // ทำให้เป็นวงกลม
                  border: Border.all(
                    color: Colors.black, // สีขอบ
                    width: 2.0, // ขนาดขอบ
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network("${loggedInUser.pathImage}"),
                ));
          }
        }
      }(),
    );
  }
}

String imagePhotoHeaderDrawerBegin() {
  return "https://firebasestorage.googleapis.com/v0/b/emailpassword-5e319.appspot.com/o/profile%2Fprofile%2Ftiger.jpg?alt=media&token=3bf23f56-5d82-4ec8-8062-5247094dae49";
}

/************************************** */

SizedBox sizeBoxHeigh(double height) {
  return SizedBox(
    height: height,
  );
}

SizedBox sizeSpaceDrawer() {
  return SizedBox(
    height: 2,
  );
}

List<String> items255 = ['ชื่อวัตถุ', 'วันที่', 'ประเภท', 'ค่าคาร์บอน'];
String selectedItems255 = '';

/************************************** */

Text showText(String valueText) {
  return Text(
    valueText,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Text showTextSetting(String valueText) {
  return Text(
    valueText,
    style: TextStyle(
      fontSize: 20,
    ),
  );
}

String imageAccountBegin() {
  return "https://firebasestorage.googleapis.com/v0/b/emailpassword-5e319.appspot.com/o/profile%2FuserAccount.jpg?alt=media&token=59dbcaa7-3caa-46e1-91fc-635506c9c7e8";
}

String imagePhotoWelcomeLogin() {
  return "https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/loginScreen%2FimagePhotoLoginScreen.jpg?alt=media&token=c41d006b-ecb2-4837-a86a-d11eabd1fe95";
}

/************************************** */
class CustomTextStyle {
  static const TextStyle nameOfTextStyle = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 0, 0, 0),
  );

  Color setColorDrawerHeader() => Color.fromARGB(255, 89, 255, 0);

  static const TextStyle normalText = TextStyle(
    fontSize: 15,
    color: Color.fromARGB(255, 0, 0, 0),
  );

  static const TextStyle linkOfTextStyle = TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 25, 0, 255),
      fontWeight: FontWeight.bold);

  static const TextStyle boldOfTextStyle = TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.bold);

  static const TextStyle menuShow = TextStyle(
    fontSize: 13,
    color: Color.fromARGB(255, 0, 0, 0),
    //fontWeight: FontWeight.bold
    //fontWeight: FontWeight.bold
  );

  static const TextStyle menuCurrent = TextStyle(
      fontSize: 13,
      color: Color.fromARGB(255, 0, 26, 255),
      fontWeight: FontWeight.bold);

  static const TextStyle showNameAndEmail = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 255, 255, 255),
  );
  static Color colorMenuCurrent() => Color.fromARGB(255, 0, 26, 255);
  static Color collorMenuShow() => Color.fromARGB(255, 0, 0, 0);
}

ListTile drawerGuide(
    BuildContext context, TextStyle inputTextStyle, Color inputColor,
    {bool? statusCurrentMenu}) {
  if (statusCurrentMenu == true) {
    return ListTile(
      tileColor: setTileColorByUser(),
      title: Text(
        'แนะนำ',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => page1Guide()));
      },
      leading: Icon(
        Icons.recommend_outlined,
        color: inputColor,
        size: 36,
      ),
    );
  } else {
    return ListTile(
      //tileColor: tileColorWhite(),
      title: Text(
        'แนะนำ',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => page1Guide()));
      },
      leading: Icon(
        Icons.recommend_outlined,
        color: inputColor,
        size: 36,
      ),
    );
  }
}

Color setTileColorByUser() => Color.fromARGB(255, 255, 255, 255);

ListTile drawerScanAndSaveCarbon(
    BuildContext context, TextStyle inputTextStyle, Color inputColor,
    {bool? statusCurrentMenu}) {
  if (statusCurrentMenu == true) {
    return ListTile(
      tileColor: setTileColorByUser(),
      title: Text(
        'บันทึกคาร์บอนของฉัน',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => page2ScanAndSaveCarbon()));
      },
      leading: Icon(
        Icons.save,
        color: inputColor,
        size: 36,
      ),
    );
  } else {
    return ListTile(
      //tileColor: Color.fromARGB(255, 255, 255, 255),
      title: Text(
        'บันทึกคาร์บอนของฉัน',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => page2ScanAndSaveCarbon()));
      },
      leading: Icon(
        Icons.save,
        color: inputColor,
        size: 36,
      ),
    );
  }
}

ListTile drawerTableCarbonMe(
    BuildContext context, TextStyle inputTextStyle, Color inputColor,
    {bool? statusCurrentMenu}) {
  if (statusCurrentMenu == true) {
    return ListTile(
      tileColor: setTileColorByUser(),
      title: Text(
        'ตารางคาร์บอนของฉัน',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => (page3ShowTableCarbonMe())));
      },
      leading: Icon(
        Icons.view_column_outlined,
        color: inputColor,
        size: 36,
      ),
    );
  } else {
    return ListTile(
      title: Text(
        'ตารางคาร์บอนของฉัน',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => (page3ShowTableCarbonMe())));
      },
      leading: Icon(
        Icons.view_column_outlined,
        color: inputColor,
        size: 36,
      ),
    );
  }
}

ListTile drawerChartCarbonMe(
    BuildContext context, TextStyle inputTextStyle, Color inputColor,
    {bool? statusCurrentMenu}) {
  if (statusCurrentMenu == true) {
    return ListTile(
      tileColor: setTileColorByUser(),
      title: Text(
        'แผนภูมิคาร์บอนของฉัน',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => (Page4ShowChart())));
      },
      leading: Icon(
        Icons.bar_chart_sharp,
        color: inputColor,
        size: 36,
      ),
    );
  } else {
    return ListTile(
      //tileColor: setTileColorByUser(),
      title: Text(
        'แผนภูมิคาร์บอนของฉัน',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => (Page4ShowChart())));
      },
      leading: Icon(
        Icons.bar_chart_sharp,
        color: inputColor,
        size: 36,
      ),
    );
  }
}

ListTile drawerSetting(
    BuildContext context, TextStyle inputTextStyle, Color inputColor,
    {bool? statusCurrentMenu}) {
  if (statusCurrentMenu == true) {
    return ListTile(
      tileColor: setTileColorByUser(),
      title: Text(
        'ตั้งค่า',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => settingMainScreen()));
      },
      leading: Icon(
        Icons.settings,
        color: inputColor,
        size: 36,
      ),
    );
  } else {
    return ListTile(
      title: Text(
        'ตั้งค่า',
        style: inputTextStyle,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => settingMainScreen()));
      },
      leading: Icon(
        Icons.settings,
        color: inputColor,
        size: 36,
      ),
    );
  }
}

class Universal extends StatefulWidget {
  const Universal({super.key});

  @override
  State<Universal> createState() => _UniversalState();
}

bool valueOpenCloseDelTable = false;
String imagePhotoAccountBegin() {
  return "https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/icon-4399701_1280.webp?alt=media&token=7d6d920c-a551-41c0-9a8c-10eb7499651f";
}
