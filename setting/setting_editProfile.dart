// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this, use_build_context_synchronously, await_only_futures, unnecessary_brace_in_string_interps, prefer_void_to_null, avoid_print, avoid_function_literals_in_foreach_calls, unused_local_variable, non_constant_identifier_names, unnecessary_new, unnecessary_string_interpolations, avoid_init_to_null, deprecated_member_use, sized_box_for_whitespace, unnecessary_null_comparison, empty_catches, file_names, camel_case_types, unused_field, prefer_final_fields, prefer_const_declarations, depend_on_referenced_packages, unused_import

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../../model/buttonSignOut.dart';
import '../../model/universal.dart';
import '../../model/user_model.dart';
import '../login.dart';
import '../page/page2ScanAndSave.dart';
import '../page/page3TableMe.dart';
import '../page/page4ChartMe.dart';
import 'fingerPrintScreen.dart';
import 'page7Setting_main.dart';

class _editProfileState extends State<editProfile> {
  //************************************************************* */
  //************************main******************** */
  //************************************************************* */
  @override
  Widget build(BuildContext context) {
    print("Page Edit Profile มีความพร้อม");
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarTitle(context),
      // drawer: DrawMenu(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                sizeBoxHeigh(10),
                //**************************** */
                showText("รูปภาพของคุณ"),
                areaPicture(
                    showImage(), clickToOpenGallery(), clickToOpenCamera()),
                sizeBoxHeigh(20),
                editTextFirstName("ชื่อจริง"),
                editTextSecondName("นามสกุล"),
                editTextEmail("อีเมลล์"),
                buttonSaveToFirebase("บันทึกข้อมูลทั้งหมดไว้ที่ Firebase"),
                sizeBoxHeigh(100),
              ],
            ),
          ),
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
  }

  //************************************************************* */
//*******************************appBarTitle************************** */
//************************************************************* */

  AppBar appBarTitle(BuildContext context) {
    return AppBar(
      title: Text("แก้ไขโปรไฟล์"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => settingMainScreen()));
        },
      ),
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
//*******************************buttonSaveToFirebase************************** */
//************************************************************* */

  SizedBox buttonSaveToFirebase(String value) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: saveProfileUserToFirebase, child: Text("${value}")),
    );
  }

  //************************************************************* */
//*******************************clickToOpenCamera************************** */
//************************************************************* */

  Widget clickToOpenCamera() {
    return IconButton(
        onPressed: () {
          chooseImage(ImageSource.camera);
        },
        icon: Icon(
          Icons.add_a_photo,
          size: 36,
        ));
  }

  //************************************************************* */
//*******************************clickToOpenGallery************************** */
//************************************************************* */

  Widget clickToOpenGallery() {
    return IconButton(
        onPressed: () {
          chooseImage(ImageSource.gallery);
        },
        icon: Icon(
          Icons.add_photo_alternate,
          size: 36,
        ));
  }

//************************************************************* */
//*******************************showImage************************** */
//************************************************************* */

  Widget showImage() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 106, 106, 106),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: Container(
          padding: EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: loggedInUser.pathImage == null
              ? Image.network(imagePhotoAccountBegin())
              : file == null
                  ? Image.network('${loggedInUser.pathImage}')
                  : Image.file(file!),
        ),
      ),
    );
  }

  //************************************************************* */
//*******************************areaPicture************************** */
//************************************************************* */

  Widget areaPicture(
      Widget showImageAfterInsert, Widget funcGallery, Widget funcCamera) {
    //ประกอบด้วย 3 ส่วน คือ 1.พื้นที่แสดงรูปภาพ 2.เพิ่มรูปภาพโดยอัลบั้ม 3.เพิ่มรูปภาพโดยกล้อง
    return SingleChildScrollView(
      child: Column(children: [
        showImageAfterInsert,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [funcGallery, funcCamera],
        ),
      ]),
    );
  }

  //************************************************************* */
//*******************************saveProfileUserToFirebase************************** */
//************************************************************* */

  void saveProfileUserToFirebase() async {
    EasyLoading.show(
        status: 'กำลังบันทึกข้อมูลทั้งหมด',
        maskType: EasyLoadingMaskType.black);
    //กรณีผู้ใช้เปลี่ยนรูปภาพ
    if (file == null) {
      print("ไม่ต้องทำอะไร");
    } else {
      print("อัพโหลดรูปลง Firebase");
      await uploadPictureToStorage();
    }

    //****************************************************** */
    //กรณีไม่มีรูปภาพ จะทำการใส่รูปภาพเริ่มต้น

    if (loggedInUser.pathImage == null) {
      print("เข้าเงื่อนไขที่ 1");
      await db.collection("users").doc("${loggedInUser.uid}").set({
        'firstName': firstName.text,
        'secondName': secondName.text,
        'email': email.text,
        'pathImage':
            'https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/icon-4399701_1280.webp?alt=media&token=7d6d920c-a551-41c0-9a8c-10eb7499651f',
        'uid': "${loggedInUser.uid}"
      });
      EasyLoading.dismiss();
      EasyLoading.showSuccess("บันทึกสำเร็จ");
      //****************************************************** */
      //กรณีมีรูปภาพ
    } else {
      print("เข้าเงื่อนไขที่ 2");
      await db.collection("users").doc("${loggedInUser.uid}").set({
        'firstName': firstName.text,
        'secondName': secondName.text,
        'email': email.text,
        'pathImage': '${urlPicture}',
        'uid': "${loggedInUser.uid}"
      });
      _updateUser();
      _scaffoldKey.currentState!.openDrawer();

      EasyLoading.dismiss();
      EasyLoading.showSuccess("บันทึกสำเร็จ");
    }
  }

//************************************************************* */
//*******************************uploadPictureToStorage************************** */
//************************************************************* */

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(10000);
    //FirebaseStoreage
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference storageRefference =
        firebaseStorage.ref().child("profile/user${i}.jpg");
    UploadTask storageUploadTask = storageRefference.putFile(file!);

    //ค้นหาตำแหน่ง url
    urlPicture =
        "https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/icon-4399701_1280.webp?alt=media&token=7d6d920c-a551-41c0-9a8c-10eb7499651f";
    urlPicture = await (await storageUploadTask).ref.getDownloadURL();

    print("แสดง url รูปภาพ ${urlPicture}");
  }

//************************************************************* */
//*******************************chooseImage************************** */
//************************************************************* */

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().getImage(
        source: imageSource,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        //file = object;
        file = File(object!.path);
      });
      //กรณี Error เก็บไว้ในตัวแปร e
    } catch (e) {}
  }

//************************************************************* */
//*******************************buttonSaveCarboon************************** */
//************************************************************* */

  ElevatedButton buttonSaveCarboon(String value) {
    return ElevatedButton(
        onPressed: () {
          addMultipleCollections("${loggedInUser.uid}");
        },
        child: Text("${value}"));
  }

  //************************************************************* */
//*******************************barTitle************************** */
//************************************************************* */

  AppBar barTitle(String textTitle) {
    return AppBar(
      title: Text("${textTitle}"),
      centerTitle: true,
    );
  }

  //************************************************************* */
//*******************************editTextFirstName************************** */
//************************************************************* */

  TextFormField editTextFirstName(String inputFirstName) {
    //print("Show FirstName : ${loggedInUser.firstName}");
    return TextFormField(
      controller: firstName,
      decoration: InputDecoration(
        labelText: '${inputFirstName}',
      ),
      onSaved: (value) {
        firstName.text = value!;
      },
    );
  }

  //************************************************************* */
//*******************************buttonEditProfile************************** */
//************************************************************* */

  void buttonEditProfile() {
    //เมื่อคลิกปุ่มบันทึก ข้อมูลใน firebase จะถูกเปลี่ยนตามที่ผู้ใช้แก้ไข
    print("${loggedInUser.uid}");

    db.collection('users').doc('${loggedInUser.uid}').set({
      "firstName": firstName.text,
      "secondName": secondName.text,
      "email": email.text,
      "uid": '${loggedInUser.uid}'
    });

    firstName.text = "ok";
  }

  //************************************************************* */
//*******************************editTextSecondName************************** */
//************************************************************* */

  TextFormField editTextSecondName(String inputSecondName) {
    //print("Show SecondName : ${loggedInUser.secondName}");
    return TextFormField(
      controller: secondName,
      decoration: InputDecoration(
        labelText: '${inputSecondName}',
      ),
      onSaved: (value) {
        secondName.text = value!;
      },
    );
  }

  //************************************************************* */
//*******************************editTextEmail************************** */
//************************************************************* */

  TextFormField editTextEmail(String inputEmail) {
    //print("Show Email : ${loggedInUser.email}");
    return TextFormField(
      controller: email,
      decoration: InputDecoration(
        labelText: '${inputEmail}',
      ),
      onSaved: (value) {
        email.text = value!;
      },
    );
  }

  //************************************************************* */
//*******************************_loadProfilePicture************************** */
//************************************************************* */

  Future<Uint8List> _loadProfilePicture() async {
    final String imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/icon-4399701_1280.webp?alt=media&token=7d6d920c-a551-41c0-9a8c-10eb7499651f';

    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print(
            'Failed to load profile picture. Status code: ${response.statusCode}');
        return Uint8List(0); // Return an empty Uint8List on failure
      }
    } catch (error) {
      print('Error loading profile picture: $error');
      return Uint8List(0); // Return an empty Uint8List on error
    }
  }

  //************************************************************* */
//*******************************headerDrawer************************** */
//************************************************************* */

  UserAccountsDrawerHeader headerDrawer() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        "${currentFirstName} ${currentSecondName}",
        style: CustomTextStyle.nameOfTextStyle,
      ),
      accountEmail: Text("Email :  ${loggedInUser.email}"),
      currentAccountPicture: FutureBuilder<Uint8List>(
        future: _loadProfilePicture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //EasyLoading.show(status: 'กำลังส่งข้อมูล...');
            return Text("Locding");
          } else if (snapshot.connectionState == ConnectionState.done) {
            //EasyLoading.dismiss();
            return ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: urlPicture == null
                  ? Image.network(loggedInUser.pathImage)
                  : Image.network(urlPicture.toString()),
            );
          } else {
            return Text("ok");
          }
        },
      ),
    );
  } //urlPicture

  //************************************************************* */
//*******************************buttonLogout************************** */
//************************************************************* */

  ActionChip buttonLogout(BuildContext context) {
    return ActionChip(
      label: Text("Logout"),
      onPressed: () {
        logout(context);
      },
    );
  }

  //************************************************************* */
//*******************************logout************************** */
//************************************************************* */

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => loginScreen()));
  }

  //************************************************************* */
//*******************************addMultipleCollections************************** */
//************************************************************* */

  Future<String?> addMultipleCollections(String id) async {
    db
        .collection("users")
        .doc("${loggedInUser.uid}")
        .collection("saveCarboon")
        .add({
      "User id": id,
      "date Time": DateTime.now(),
      "type": "เครื่องใช้ไฟฟ้า",
      "name object": "เครื่องซักผ้า",
      "amount Carboon": "80"
    });
    return null;
  }

  //************************************************************* */
//*******************************_updateUser************************** */
//************************************************************* */

  void _updateUser() {
    setState(() {
      currentFirstName = firstName.text;
      currentSecondName = secondName.text;
      currentPictureUrl = loggedInUser.pathImage;
    });
  }

  //************************************************************* */
//*******************************Firestore************************** */
//************************************************************* */
  var db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser =
      UserModel(null, null, null, null, "$imageAccountBegin()");

  TextEditingController firstName = new TextEditingController();
  TextEditingController secondName = new TextEditingController();
  TextEditingController email = new TextEditingController();

  String? currentFirstName;
  String? currentSecondName;
  String? currentPictureUrl;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //picture profile
  File? file = null;
  String? urlPicture;
}

class editProfile extends StatefulWidget {
  const editProfile({super.key});
  @override
  State<editProfile> createState() => _editProfileState();
}
