// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, unnecessary_this, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, file_names, void_checks, deprecated_member_use, duplicate_ignore, unused_import, unnecessary_null_comparison

import "package:flutter_tflite/flutter_tflite.dart";
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import "page1Guide.dart";
import '../../main.dart';
import '../../model/buttonSignOut.dart';
import '../../model/universal.dart';
import '../../model/user_model.dart';
import '../setting/page7Setting_main.dart';
import 'page3TableMe.dart';
import 'page4ChartMe.dart';

class _page2ScanAndSaveCarbonState extends State<page2ScanAndSaveCarbon> {
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */

  //พื้นที่แสดง ส่วนที่ผู้ใช้งานแอพพลิเคชั่นมองเห็น
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle("คำนวณ Carboon"),
      drawer: myDrawer(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          labelWelcomeToApp("สแกนวัตถุรอบตัวท่าน เพื่อคำนวณปริมาณคาร์บอน"),
          areaCamera(context),
          labelShowResultThenScanObjectByCamera("วัตถุ : ${output}"),
          Container(
            //color: Colors.black,
            height: 60,
            margin: EdgeInsets.all(5),
            width: double.infinity,
            child: buttonSaveCarboon(context),
          ),
        ],
      ),
    );
  }

  //************************************************************* */
  //******************************initState*************************** */
  //************************************************************* */

  @override
  void initState() {
    super.initState();
    loadModel();
    loadCamera(ResolutionPreset.veryHigh);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());

      setState(() {});
    });
  }

  //************************************************************* */
  //*******************************loadCamera************************** */
  //************************************************************* */

  loadCamera(ResolutionPreset setResolutionCameraByUser) {
    //cameraMe![0] = กล้องหลัง
    //cameraMe![1] = กล้องหน้า
    cameraController =
        CameraController(cameraMe![0], setResolutionCameraByUser);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  //************************************************************* */
  //*******************************runModel************************** */
  //************************************************************* */

  runModel() async {
    if (cameraImage != null) {
      var getLabelThenTakePhoto = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);
      getLabelThenTakePhoto!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
    print(output);
  }

  //************************************************************* */
  //*******************************loadModel************************** */
  //************************************************************* */

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  //************************************************************* */
  //*******************************areaCamera************************** */
  //************************************************************* */

  SizedBox areaCamera(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      //เพื่อตรวจสอบว่ากล้องถูกเริ่มต้นและเชื่อมต่อกับอุปกรณ์ได้หรือไม่
      child: !cameraController!.value.isInitialized
          ? Text("ไม่พบกล้อง กรุณาอนุญาตให้ใช้กล้อง")
          : AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
    );
  }

  //************************************************************* */
  //*******************************textHelp************************** */
  //************************************************************* */

  Text labelWelcomeToApp(String inputLabelWelcomeToApp) {
    return Text(
      "$inputLabelWelcomeToApp",
      style: CustomTextStyle.nameOfTextStyle,
    );
  }

  //************************************************************* */
  //*******************************buttonSaveCarboon************************** */
  //************************************************************* */

  ElevatedButton buttonSaveCarboon(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          print("*****************\n\n");
          print("อ่านค่าได้ดังนี้ : ${output}");
          print("*****************\n\n");
          print("*****************\n\n");
          buttonSaveCarboonThenScan();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => page3ShowTableCarbonMe()));
        },
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          primary: Color.fromARGB(255, 0, 255, 102), // สีพื้นหลังของปุ่ม
          onPrimary: const Color.fromARGB(255, 0, 0, 0), // สีของตัวอักษรบนปุ่ม
          elevation: 5, // เงาของปุ่ม
          padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10), // ระยะห่างของขอบปุ่มกับเนื้อที่ในปุ่ม
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // รูปร่างของปุ่ม
          ),
        ),
        child: Text("บันทึกคาร์บอน"));
  }

  //************************************************************* */
  //*******************************outputObjectCamera************************** */
  //************************************************************* */

  Text labelShowResultThenScanObjectByCamera(String inputLabel) {
    return Text("$inputLabel",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
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
            CustomTextStyle.menuCurrent,
            CustomTextStyle.colorMenuCurrent(),
            statusCurrentMenu: true,
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
            CustomTextStyle.menuShow,
            CustomTextStyle.collorMenuShow(),
          ),
          MySignOut(),
        ],
      ),
    );
  }

  //************************************************************* */
  //*******************************buttonSaveCarboonThenScans************************** */
  //************************************************************* */

  void buttonSaveCarboonThenScan() async {
    EasyLoading.show(status: 'กำลังส่งข้อมูล...');
    await dbObject
        .collection("object")
        .where("objectName", isEqualTo: "${output}")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print("แสดง ob : ${element.data()["objectType"]}");
                type55 = element.data()["objectType"].toString();
              })
            });
    await dbObject
        .collection("object")
        .where("objectName", isEqualTo: "${output}")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print(
                    "show element data : ${element.data()["objectValueCarboon"]}");
                valueObject =
                    double.parse(element.data()["objectValueCarboon"]);
              })
            });

    await db
        .collection("users")
        .doc(loggedInUser.uid)
        .collection("saveCarboon")
        .add({
      "User id": "${loggedInUser.uid}",
      "amount Carboon": valueObject,
      "date Time": DateTime.now(),
      "name object": "${output}",
      "type": "${type55}"
    }).then((value) {
      print("_____________________\n\n\n");
      print("เลขที่เอกสารแฟ้ม saveCarboon : ${value.id}");
      print("_____________________\n\n\n");
      EasyLoading.showSuccess("บันทึกสำเร็จ");
      EasyLoading.dismiss();
    });
  }

  //************************************************************* */
  //*******************************homeScreen************************** */
  //************************************************************* */

  ActionChip homeScreen(BuildContext context) {
    return ActionChip(
      label: Text("HomeScreen"),
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => settingMainScreen()));
      },
    );
  }

  //************************************************************* */
  //*******************************appBarTitle************************** */
  //************************************************************* */

  AppBar appBarTitle(String inputTitle) {
    return AppBar(
      title: Text('$inputTitle'),
      //leading: buttonBack(context),
      actions: [
        IconButton(
          icon: Icon(Icons.settings), // ไอคอนที่ต้องการแสดง
          onPressed: () {
            // กระทำเมื่อไอคอนถูกคลิก
            print('Settings icon clicked');
            showOptionsCameraDialog(context);
          },
        ),
        // เพิ่มไอคอนเพิ่มเติมตามต้องการ
      ],
    );
  }

  void showOptionsCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เลือกคุณภาพของภาพถ่าย'),
          content: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Option 0');
                    loadCamera(ResolutionPreset.ultraHigh);
                  },
                  child: const Text('คุณภาพสูงมาก ๆ : 2,160 p'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Option 1');
                    loadCamera(ResolutionPreset.veryHigh);
                  },
                  child: const Text('คุณภาพสูงมาก : 1,080 p'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Option 2');
                    loadCamera(ResolutionPreset.high);
                  },
                  child: const Text('คุณภาพสูง : 720 p'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Option 3');
                    loadCamera(ResolutionPreset.medium);
                  },
                  child: const Text('คุณภาพกลาง : 480 p'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Option 4');
                    loadCamera(ResolutionPreset.low);
                  },
                  child: const Text('คุณภาพต่ำ : 240 p'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        print('User selected: $value');
      }
    });
  }

  //************************************************************* */
  //*******************************buttonBack************************** */
  //************************************************************* */

  IconButton buttonBack(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255)),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const settingMainScreen()),
          );
        });
  }

  //************************************************************* */
  //*******************************headerAccountDraw************************** */
  //************************************************************* */

  bool? statusLoadingImageHeaderDrawer;

  UserAccountsDrawerHeader headerAccountDraw() {
    return UserAccountsDrawerHeader(
      decoration: setColorBackgroundHeaderDrawer(),
      accountName: labelFirstNameAndLastNameInHeaderDrawer(),
      accountEmail: labelEmailInHeaderDrawer(CustomTextStyle.normalText),
      currentAccountPicture: () {
        //กรณี กำลังโหลดรูปภาพ บน Drawer
        if (statusLoadingImageHeaderDrawer == true) {
          return CircularProgressIndicator();
        } else {
          //*********************************** */
          //กรณี โหลดรูปภาพสำเร็จ พร้อมแสดงบน Drawer
          //*********************************** */
          if (loggedInUser.pathImage == null) {
            //กรณี ไม่มีไฟล์รูปโปรไฟล์ เพราะผู้ใช้งานไม่ได้ใส่รูปภาพเริ่มต้น
            return imageAccountDrawer(imagePhotoHeaderDrawerBegin(), 20);
          } else {
            //กรณี มีรูปโปรไฟล์ และ บันทึกไว้ใน Firebase
            return imageAccountDrawer(loggedInUser.pathImage, 20);
          }
        }
      }(),
    );
  }

  ClipRRect imageAccountDrawer(String inputImage, double inputRadius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(inputRadius),
      child: Image.network("$inputImage", loadingBuilder: (BuildContext context,
          Widget child, ImageChunkEvent? loadingProgress) {
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

  Text labelEmailInHeaderDrawer(TextStyle textStyle) {
    return Text(
      "Email :  ${loggedInUser.email}",
      style: textStyle,
    );
  }

  Text labelFirstNameAndLastNameInHeaderDrawer() {
    return Text(
      "${loggedInUser.firstName} ${loggedInUser.secondName}",
      style: CustomTextStyle.nameOfTextStyle,
    );
  }

  //************************************************************* */
  //*******************************Cloud Firestore************************** */
  //************************************************************* */
  var db = FirebaseFirestore.instance;
  var dbObject = FirebaseFirestore.instance;
  UserModel loggedInUser =
      UserModel(null, null, null, null, "$imageAccountBegin()");
  User? user = FirebaseAuth.instance.currentUser;

  String output = '_____';
  String? type55;
  double? valueObject;

  //Camera:
  CameraImage? cameraImage;
  CameraController? cameraController;
}

class page2ScanAndSaveCarbon extends StatefulWidget {
  const page2ScanAndSaveCarbon({Key? key}) : super(key: key);
  @override
  State<page2ScanAndSaveCarbon> createState() => _page2ScanAndSaveCarbonState();
}
