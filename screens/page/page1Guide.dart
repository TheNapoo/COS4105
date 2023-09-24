// ignore_for_file: file_names, prefer_const_constructors, camel_case_types, sort_child_properties_last, unnecessary_string_interpolations, unnecessary_this, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, unused_import, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/buttonSignOut.dart';
import '../../model/universal.dart';
import '../../model/user_model.dart';
import '../setting/page7Setting_main.dart';
import 'guide.dart';
import 'page2ScanAndSave.dart';
import 'page3TableMe.dart';
import 'page4ChartMe.dart';

//************************************************************* */
//*******************************Main************************** */
//************************************************************* */
class _page1GuideState extends State<page1Guide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle(context, "แนะนำ",
          buttonAppBarGotoScanAndSaveCarbonScreen(context)), //funInScreen
      drawer: myDrawer(context), //funInScreen
      body: Column(
        children: [
          Expanded(
            child: bookGuideView(), //funcInScreen
          ),
          Container(
            child: areaDotRangePage(context), //funcInScreen
          ),
          Container(
            //color: Colors.black,
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: buttonNextOrScanObject(context), //funcInScreen
          ),
        ],
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
        statusLoadingImageOnBoard = true;
        statusLoadingImageOnBoard = false;
        isImageLoading2 = null;
        statusLoadingImageHeaderDrawer = null;
      });

      runNumberPage = PageController(initialPage: 0);
      super.initState();
    });
  }

//************************************************************* */
//*******************************headerAccountDraw************************** */
//************************************************************* */
  bool? statusLoadingImageHeaderDrawer;

  UserAccountsDrawerHeader headerAccountDraw() {
    return UserAccountsDrawerHeader(
      decoration: setColorBackgroundHeaderDrawer(), //ฟังก์ชันสาธารณะ
      accountName: labelFirstNameAndLastNameInHeaderDrawer(
        CustomTextStyle.nameOfTextStyle,
      ),
      accountEmail: labelEmailInHeaderDrawer(
        CustomTextStyle.nameOfTextStyle,
      ),
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
            return imageAccountDrawer(
                imagePhotoHeaderDrawerBegin(), 20); //ฟังก์ชันสาธารณะ
          } else {
            //กรณี มีรูปโปรไฟล์ และ บันทึกไว้ใน Firebase
            return imageAccountDrawer(
                loggedInUser.pathImage, 20); //ฟังก์ชันสาธารณะ
          }
        }
      }(),
    );
  }

  Text labelEmailInHeaderDrawer(TextStyle textStyle) {
    return Text(
      "Email :  ${loggedInUser.email}",
      style: textStyle,
    );
  }

  Text labelFirstNameAndLastNameInHeaderDrawer(TextStyle textStyle) {
    return Text(
      "${loggedInUser.firstName} ${loggedInUser.secondName}",
      style: textStyle,
    );
  }

//************************************************************* */
//*******************************buttonNextOrScanObject************************** */
//************************************************************* */
  bool? statusLoadingImageOnBoard;
  ElevatedButton buttonNextOrScanObject(BuildContext context) {
    return ElevatedButton(
      child: Text(currentNumberPage == numberContent.length - 1
          ? "เริ่มต้น Scan วัตถุ"
          : "ถัดไป"),
      onPressed: () {
        statusLoadingImageOnBoard = true;
        statusLoadingImageOnBoard = false;
        if (currentNumberPage == numberContent.length - 1) {
          navigatorGoToPageScanAndSaveCarbon(context);
        }
        runNumberPage.nextPage(
          duration: Duration(milliseconds: 100),
          curve: Curves.bounceIn,
        );
      },
    );
  }

  //************************************************************* */
//*******************************navigatorGoToPageScanAndSaveCarbon************************** */
//************************************************************* */

  Future<dynamic> navigatorGoToPageScanAndSaveCarbon(BuildContext context) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => page2ScanAndSaveCarbon(),
      ),
    );
  }

//************************************************************* */
//*******************************bookGuideView************************** */
//************************************************************* */

  PageView bookGuideView() {
    return PageView.builder(
      controller: runNumberPage,
      itemCount: numberContent.length,
      onPageChanged: (int index) {
        setState(() {
          currentNumberPage = index;
        });
      },
      itemBuilder: (_, i) {
        return Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              areaLabelcontentTitle(i),
              SizedBox(height: 20),
              contentsImage(i),
              SizedBox(height: 20),
              areaLabelContentDiscription(i)
            ],
          ),
        );
      },
    );
  }

//************************************************************* */
//*******************************areaLabelContentDiscription************************** */
//************************************************************* */
  Text areaLabelContentDiscription(int i) {
    return Text(
      numberContent[i].discription!,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  //************************************************************* */
//*******************************contentsImage************************** */
//************************************************************* */
  bool? isImageLoading2;
  Widget contentsImage(int i) {
    if (statusLoadingImageOnBoard == true) {
      return CircularProgressIndicator();
    } else {
      return Image.network(
        numberContent[i].image!,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            statusLoadingImageOnBoard = false;
            return child;
          } else {
            return CircularProgressIndicator();
            // return Center(
            //   child: CircularProgressIndicator(
            //       value: loadingProgress.expectedTotalBytes != null
            //           ? loadingProgress.cumulativeBytesLoaded /
            //               (loadingProgress.expectedTotalBytes ?? 1)
            //           : null),
            // );
          }
        },
      );
    }
  }

  //************************************************************* */
//*******************************contentsTitle************************** */
//************************************************************* */

  Text areaLabelcontentTitle(int i) {
    return Text(
      numberContent[i].title!,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //************************************************************* */
//*******************************areaDotShowPage************************** */
//************************************************************* */

  Row areaDotRangePage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        numberContent.length,
        (index) => buildDot(index, context),
      ),
    );
  }

  //************************************************************* */
//*******************************appBarTitle************************** */
//************************************************************* */

  AppBar appBarTitle(
      BuildContext context, String inputTitle, List<Widget> input) {
    return AppBar(
      title: Text("$inputTitle"),
      actions: input,
    );
  }

  //************************************************************* */
//*******************************buttonAppBarNext************************** */
//************************************************************* */

  List<Widget> buttonAppBarGotoScanAndSaveCarbonScreen(BuildContext context) {
    return <Widget>[
      ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => page2ScanAndSaveCarbon(),
              ),
            );
          },
          child: Text("ข้าม")),
    ];
  }

//************************************************************* */
//*******************************myDrawer************************** */
//************************************************************* */

  Drawer myDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          headerAccountDraw(),
          drawerGuide(context, CustomTextStyle.menuCurrent,
              CustomTextStyle.colorMenuCurrent(),
              statusCurrentMenu: true),
          drawerScanAndSaveCarbon(context, CustomTextStyle.menuShow,
              CustomTextStyle.collorMenuShow()),
          drawerTableCarbonMe(context, CustomTextStyle.menuShow,
              CustomTextStyle.collorMenuShow()),
          drawerChartCarbonMe(context, CustomTextStyle.menuShow,
              CustomTextStyle.collorMenuShow()),
          drawerSetting(context, CustomTextStyle.menuShow,
              CustomTextStyle.collorMenuShow()),
          MySignOut(),
        ],
      ),
    );
  }

//************************************************************* */
//*******************************buildDot************************** */
//************************************************************* */

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentNumberPage == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  //************************************************************* */
//*******************************dispose************************** */
//************************************************************* */

  @override
  void dispose() {
    runNumberPage.dispose();
    super.dispose();
  }

//************************************************************* */
//*******************************Cloud Firestore************************** */
//************************************************************* */
  var db = FirebaseFirestore.instance;
  UserModel loggedInUser =
      UserModel(null, null, null, null, "$imageAccountBegin()");
  User? user = FirebaseAuth.instance.currentUser;

  int currentNumberPage = 0;
  PageController runNumberPage = PageController(initialPage: 0);
}

class page1Guide extends StatefulWidget {
  const page1Guide({super.key});
  @override
  State<page1Guide> createState() => _page1GuideState();
}
