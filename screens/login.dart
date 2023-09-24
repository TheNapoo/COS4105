// ignore_for_file: unused_field, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_void_to_null, avoid_print, unused_import, camel_case_types, prefer_single_quotes, use_build_context_synchronously, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_final_fields, curly_braces_in_flow_control_structures, avoid_init_to_null, deprecated_member_use, depend_on_referenced_packages, prefer_const_declarations

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import '../main.dart';
import '../model/universal.dart';
import 'CCTV/captureCCTV.dart';
import 'CCTV/viewCCTV.dart';
import 'page/page1Guide.dart';
import 'page/page2ScanAndSave.dart';
import 'register.dart';
import 'resetPassword.dart';
import 'setting/setting_editProfile.dart';
import 'setting/page7Setting_main.dart';
import 'package:http/http.dart' as http;

class _loginScreenState extends State<loginScreen> {
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        photoWelcomeLogin(),
                        sizeBoxHeigh(20),
                        inputEmail(),
                        sizeBoxHeigh(20),
                        inputPassword(),
                        sizeBoxHeigh(20),
                        buttonLogin(context),
                        sizeBoxHeigh(5),
                        forgetPassword(context),
                        sizeBoxHeigh(5),
                        noAccountCreateAccount(context),
                        areaCameraCCTV(false),
                      ],
                    )),
              ),
            ),
          ),
        ),
      )),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  Future sendEmail() async {
    //final : หมายถึง ไม่เปลี่ยนแปลงค่าแน่นอน
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    final service_id = "service_hh40481";
    final template_id = "template_4ials0b";
    final user_id = "9Ag3Ya5it38hR5WRu";

    String to_email = "thenapoo@gmail.com";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    var respond = await http.post(url,
        headers: {
          'origin': 'http:/localhost',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "service_id": service_id,
          "template_id": template_id,
          "user_id": user_id,
          "template_params": {
            "user_name": 'hello',
            "imageSafty": urlPicture,
            "to_email": to_email,
            "subjectTitleEmail": "การแจ้งเตือนความปลอดภัย",
            "message":
                "คุณได้เข้าสู่แอพ Napoo Carbon ครั้งล่าสุด เมื่อวันที่ $formattedDate ${urlPicture}"
          }
        }));
    print(" ddd : $respond.body");
  }

  //************************************************************* */
  //************************areaCameraCCTV******************** */
  //************************************************************* */

  FutureBuilder<void> areaCameraCCTV(bool valueVisible) {
    return FutureBuilder<void>(
      future: _intializeCameraCtrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Visibility(
              visible: valueVisible, child: CameraPreview(_cameraCtrl!));
        } else {
          return Visibility(
              visible: valueVisible,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  //************************************************************* */
  //************************autoLogin******************** */
  //************************************************************* */

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      try {
        await db.signInWithEmailAndPassword(
            email: savedEmail, password: savedPassword);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => page2ScanAndSaveCarbon()));
      } catch (error) {
        // กระบวนการการเข้าสู่ระบบไม่สำเร็จ
        print("เข้าสู่ระบบไม่สำเร็จ: $error");
        // คุณสามารถแจ้งเตือนผู้ใช้หรือดำเนินการอื่น ๆ ตามที่คุณต้องการ
      }
    }
  }

  //************************************************************* */
  //************************areaPicture******************** */
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
  //************************showImage******************** */
  //************************************************************* */

  Widget showImage() {
    return CircleAvatar(
        radius: 150,
        backgroundColor: Color.fromARGB(255, 106, 106, 106),
        child: Container(
          padding: EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          //child: ClipOval(child: Image.file(file!)),
        ));
  }

  //************************************************************* */
  //************************clickToOpenGallery******************** */
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
  //************************chooseImage******************** */
  //************************************************************* */

  File? file = null;
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
    } catch (e) {
      print(e);
    }
  }

  //************************************************************* */
  //************************clickToOpenCamera******************** */
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
  //************************autoLogin55******************** */
  //************************************************************* */

  void autoLogin55(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      //Fluttertoast.showToast(msg: "พบเจอข้อมูลใน");
      EasyLoading.dismiss();
      try {
        // ส่วนนี้คือการเข้าสู่ระบบ
        // ...
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => page1Guide()));
      } catch (error) {
        print("เข้าสู่ระบบไม่สำเร็จ: $error");
      }
    } else {
      //Fluttertoast.showToast(msg: "ไม่พบข้อมูลใน Share Preferences");
    }
  }

  //************************************************************* */
  //************************photoWelcomeLogin******************** */
  //************************************************************* */
  bool? isImageLoading;
  ClipRRect photoWelcomeLogin() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: () {
          if (isImageLoading == true) {
            return Text("ok");
            //return CircularProgressIndicator();
          } else {
            return Image.network(
              //"https://images.pexels.com/photos/462118/pexels-photo-462118.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
              imagePhotoWelcomeLogin(),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  isImageLoading = false;
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
        }());
  }

  //************************************************************* */
  //************************buttonSignInWithGoogle******************** */
  //************************************************************* */

  Container buttonSignInWithGoogle() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: SignInButton(
        buttonType: ButtonType.google,
        onPressed: () {
          processSignInWithGoogle();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  //************************************************************* */
  //************************processSignInWithGoogle******************** */
  //************************************************************* */

  Future<Null> processSignInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    await Firebase.initializeApp().then((value) async {
      await _googleSignIn.signIn().then((value) {
        String? name = value?.displayName;
        String? email = value?.email;
        print("login With Gamil สำเร็จ");
      });
    });
  }

  //************************************************************* */
  //************************buttonLogin******************** */
  //************************************************************* */

  Material buttonLogin(BuildContext context) {
    return Material(
      elevation: 5,
      color: Color.fromARGB(255, 255, 236, 128),
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "เข้าสู่ระบบ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //************************************************************* */
  //************************buildSignInGoogle******************** */
  //************************************************************* */

  Container buildSignInGoogle() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: SignInButton(
        buttonType: ButtonType.google,
        onPressed: () {},
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  var statusRedEye = true;

  TextFormField inputPassword() {
    return TextFormField(
      //autofocus: true,
      controller: passwordController,
      obscureText: statusRedEye,
      //ตรวจสอบ
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        //กรณีไม่กรอกรหัสผ่าน
        if (value!.isEmpty) {
          return ("รหัสผ่านไม่ควรเป็นค่าว่าง");
        }
        //กรณีรหัสผ่านน้อยกว่า 6 ตัวอักษร
        if (!regex.hasMatch(value)) {
          return ("รหัสผ่านควรไม่ต่ำกว่า 6 ตัวอักษร");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,

      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
              },
              icon: statusRedEye
                  //ปิดตา
                  ? Icon(
                      Icons.visibility_off_sharp,
                      //color: MyConstant.dark,
                    )
                  : Icon(
                      //เปิดตา
                      Icons.visibility,
                      //color: MyConstant.dark,
                    )),
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  TextFormField inputEmail() {
    return TextFormField(
      //autofocus: true,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // initialValue: getLastLoggedInEmail() == null
      //     ? ""
      //     : getLastLoggedInEmail()
      //         .toString(), // ใส่ค่าเริ่มต้นจาก shared_preferences
      validator: (value) {
        if (value!.isEmpty) {
          return "โปรดกรอกข้อมูลอีเมลล์";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  //************************************************************* */
  //************************noAccountCreateAccount******************** */
  //************************************************************* */

  Column noAccountCreateAccount(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: const ui.Color.fromARGB(255, 255, 255, 255),
            height: 40,
            margin: EdgeInsets.all(0),
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              labeYouHaveNoAccount(),
              buttonCreateAccount(context),
            ]),
          ),
        ]);
  }

  GestureDetector buttonCreateAccount(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegistrationScreen();
        }));
      },
      child: Text(
        "สมัครสมาชิก",
        style: CustomTextStyle.linkOfTextStyle,
      ),
    );
  }

  Text labeYouHaveNoAccount() {
    return Text(
      "คุณยังไม่มีบัญชีผู้ใช้ใช่ไหม? ",
      style: CustomTextStyle.nameOfTextStyle,
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  Column forgetPassword(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          color: const ui.Color.fromARGB(255, 255, 255, 255),
          height: 40,
          margin: EdgeInsets.only(top: 10),
          width: double.infinity,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            labelForgetPassword(),
            buttonResetPassword(context),
          ]),
        ),
      ],
    );
  }

  Text labelForgetPassword() {
    return Text("ลืมรหัสผ่านใช่หรือไม่ ? ",
        style: CustomTextStyle.nameOfTextStyle);
  }

  GestureDetector buttonResetPassword(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => resetPasswordScreen()));
      },
      child: Text(
        "รีเซ็ตรหัสผ่าน",
        style: CustomTextStyle.linkOfTextStyle,
      ),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  // void startLoginDelayTimer() {
  //   setState(() {
  //     loginDelaySeconds = 20; // Set the initial delay time in seconds
  //   });

  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (loginDelaySeconds > 0) {
  //       setState(() {
  //         loginDelaySeconds--; // Decrement the countdown
  //       });
  //     } else {
  //       setState(() {
  //         timer.cancel(); // Cancel the timer when countdown reaches 0
  //         isLoginDelayed = false; // Reset the delay flag
  //       });
  //     }
  //   });
  // }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */
  String? ant;
  File? imageFile;

  void signIn(String email, String password) async {
    //กรณี Login สำเร็จ
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'กำลังเข้าสู่ระบบ...');
      await db
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) async {
        countClickButtonLogin = 0;
        statusLogin = false;

        Fluttertoast.showToast(msg: "Login สำเร็จ");
        //******************************************* */
        await createVarEmailAndPasswordToSaveSharedPreferences(email, password);
        await saveEmailAndPasswordInSharedPreferences(email, password);
        EasyLoading.dismiss();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => page1Guide()));
      }).catchError((e) async {
        //********************************************************** */
        //กรณี Login ไม่สำเร็จ กรอกรหัสผิด
        EasyLoading.dismiss();
        countClickButtonLogin++;
        Fluttertoast.showToast(msg: "Login ผิดครั้งที่ $countClickButtonLogin");

        //เมื่อกรอกรหัสผ่านผิดเกิน 3 ครั้ง
        if (countClickButtonLogin > 3) {
          //แสดงจำนวนครั้งที่กรอกผิด
          Fluttertoast.showToast(
              msg: "Login เกินจำนวน  : Login ครั้งที่ $countClickButtonLogin");

          try {
            EasyLoading.show(status: 'ท่านกรอกรหัสไม่ถูกต้อง...');
            await _intializeCameraCtrlFuture;

            //ตั้งชื่อภาพที่ถ่ายได้
            final path = join(
                (await getTemporaryDirectory()).path, "${DateTime.now()}.png");

            imageFile = File(path);

            //ถ่ายรูปทันที
            XFile picture = await _cameraCtrl!.takePicture();

            //เก็บรูปภาพไว้ใน path
            await picture.saveTo(path);

            //ส่งอีเมลล์
            await sendEmail();
            nextViewImageScreen(path);
            EasyLoading.dismiss();
          } catch (e) {
            print(e);
          }
        }
      });
    }

    try {
      if (imageFile == null) {
        //Fluttertoast.showToast(msg: "ไม่ได้อัพโหลดรูปลง Firebase : $imageFile");
      } else {
        Fluttertoast.showToast(msg: "อัพโหลดรูปลง Firebase : $imageFile");
        await uploadPictureToStorage(imageFile!);
        Fluttertoast.showToast(msg: "ส่งอีเมมล์สำเร็จ");
      }
      //await uploadPictureToStorage();
    } catch (e) {
      Fluttertoast.showToast(msg: "เกิดข้อผิดพลาด : $e");
      print("eeee $e");
    }
    //กรณี Login
    //********************************************************** */

    // Ignore: dead_code
    if ((email.isEmpty) || (password.isEmpty)) {
      normalDialog(context, "คำเตือน", "กรุณากรอกข้อมูลให้ครบ");
    }

    // countClickButtonLogin++;

    // Fluttertoast.showToast(msg: "login ครั้งที่ : $countClickButtonLogin");

    // Fluttertoast.showToast(msg: "แสดงสถานะ login : $isLoginDelayed");

    // if (isLoginDelayed == false) {
    //   Fluttertoast.showToast(msg: "ปัจจุบัน login : $isLoginDelayed");

    //   Fluttertoast.showToast(
    //       msg:
    //           "โปรดรอ $loginDelaySeconds วินาที เนื่องจากกรอกรหัสผิดเกินจำนวนครั้ง");
    //   captureCCTV();

    //   return;
    // }
    //********************************************************** */
  }

  Future<dynamic> nextViewImageScreen(String path) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => viewImageScreen(
          imagePath: path,
        ),
      ),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */
  String urlPicture = "ค่าเริ่มต้น url picture";
  Future<dynamic> navigatorToPage3ScanSaveCarbon() {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => page2ScanAndSaveCarbon()));
  }

  Future<void> uploadPictureToStorage(File inputImageFile) async {
    Random random = Random();
    int i = random.nextInt(30);
    //FirebaseStoreage
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference storageRefference =
        firebaseStorage.ref().child("secured/login${i}.jpg");

    if (imageFile == null) {
      print("ไม่ต้องทำอะไร");
    } else {
      UploadTask storageUploadTask = storageRefference.putFile(inputImageFile);
      urlPicture = await (await storageUploadTask).ref.getDownloadURL();
      print("แสดง url รูปภาพ ${urlPicture}");
    }

    //ค้นหาตำแหน่ง url
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  Future<void> createVarEmailAndPasswordToSaveSharedPreferences(
      String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  Future<void> captureAndNavigate(BuildContext context) async {
    try {
      await _intializeCameraCtrlFuture;
      final path =
          join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");

      XFile picture = await _cameraCtrl!.takePicture();
      picture.saveTo(path);

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
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  Future<void> captureAndSaveScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // ความละเอียด
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uint8list = byteData!.buffer.asUint8List();

      await ImageGallerySaver.saveImage(uint8list); // บันทึกลงแกลเลอรี
      print('แสดงScreenshot saved');
    } catch (e) {
      print('แสดงFailed to save screenshot: $e');
    }
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  bool statusLogin = false;
  int loginDelaySeconds = 0;
  GlobalKey _globalKey = GlobalKey();
  int countClickButtonLogin = 0;

  //************************************** */
  //สำหรับการเก็บข้อมูลไว้ใน SharedPreferences
  Future<void> saveEmailAndPasswordInSharedPreferences(
      String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('email') && prefs.containsKey('password');
  }

  //************************************** */

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  final _formKey = GlobalKey<FormState>();
  String? nameUser;

  //editting controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //Cloud Firestore:
  final db = FirebaseAuth.instance;

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  CameraController? _cameraCtrl;
  Future<void>? _intializeCameraCtrlFuture;
  Future<void>? _intializeCameraCtrlFuture2;

  @override
  void initState() {
    super.initState();
    autoLogin55(context);
    _cameraCtrl = CameraController(cameraMe![1], ResolutionPreset.medium);
    _intializeCameraCtrlFuture = _cameraCtrl!.initialize();
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  @override
  void dispose() {
    _cameraCtrl!.dispose();
    super.dispose();
  }
}

class GoogleAuthApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> signIn() async {
    if (await _googleSignIn.isSignedIn()) {
      return GoogleSignIn().currentUser;
    } else {
      return await _googleSignIn.signIn();
    }
  }
}

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});
  @override
  State<loginScreen> createState() => _loginScreenState();
}
