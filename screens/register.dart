// ignore_for_file: unnecessary_new, prefer_const_constructors, body_might_complete_normally_nullable, unused_local_variable, body_might_complete_normally_catch_error, avoid_print, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, use_build_context_synchronously, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/universal.dart';
import '../model/user_model.dart';
import 'login.dart';
import 'page/page2ScanAndSave.dart';

class _RegistrationScreenState extends State<RegistrationScreen> {
  //************************************************************* */
  //************************************************************* */
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */
  //************************************************************* */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarTitle(context, "สมัครเข้าใช้งาน"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
              child: SingleChildScrollView(
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
                        inputFirstName(),
                        sizeBoxHeigh(20),
                        inputSecondName(),
                        sizeBoxHeigh(20),
                        inputEmail(),
                        sizeBoxHeigh(20),
                        inputPassword(),
                        sizeBoxHeigh(20),
                        inputAgainPassword(),
                        sizeBoxHeigh(20),
                        buttonSignUp(context)
                      ],
                    )),
              ),
            ),
          )),
        ),
      ),
    );
  }

  //************************************************************* */
  //************************************************************* */
  //************************************************************* */
  //****************************Function************************* */
  //************************************************************* */
  //************************************************************* */

  AppBar appBarTitle(BuildContext context, String titles) {
    return AppBar(
      title: Text("${titles}"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: const Color.fromARGB(255, 255, 255, 255)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => loginScreen()),
          );
        },
      ),
    );
  }

  Material buttonSignUp(BuildContext context) {
    return Material(
      elevation: 5,
      color: Color.fromARGB(255, 255, 236, 128),
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(email.text, passwordEditingController.text);
        },
        child: Text(
          "สมัครสมาชิก",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TextFormField inputAgainPassword() {
    return TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      //ตรวจสอบ
      validator: validatorConfirmPassword,
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: decorationShow("Again Password", Icon(Icons.lock_outline)),
    );
  }

  TextFormField inputPassword() {
    return TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      //ตรวจสอบ
      validator: validatorPassword,
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: decorationShow("Password", Icon(Icons.lock_outline)),
    );
  }

  TextFormField inputEmail() {
    return TextFormField(
      autofocus: false,
      controller: email,
      keyboardType: TextInputType.emailAddress,
      validator: validatorEmail,
      onSaved: (value) {
        email.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: decorationShow("Email", Icon(Icons.email_outlined)),
    );
  }

  TextFormField inputSecondName() {
    return TextFormField(
      autofocus: false,
      controller: secondName,
      keyboardType: TextInputType.name,
      //ตรวจสอบ
      validator: validatorSecondName,
      onSaved: (value) {
        secondName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration:
          decorationShow("Second Name", Icon(Icons.person_add_alt_1_sharp)),
    );
  }

  TextFormField inputFirstName() {
    return TextFormField(
      autofocus: false,
      controller: firstName,
      keyboardType: TextInputType.name,
      //ตรวจสอบ
      validator: validatorFirstName,
      onSaved: (value) {
        firstName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration:
          decorationShow("First Name", Icon(Icons.person_add_alt_1_outlined)),
    );
  }

  String? validatorConfirmPassword(value) {
    if (confirmPasswordEditingController.text !=
        passwordEditingController.text) {
      return "รหัสผ่านไม่ตรงกัน";
    }
    return null;
  }

  String? validatorPassword(value) {
    RegExp regex = new RegExp(r'^.{6,}$');
    //กรณีไม่กรอกรหัสผ่าน
    if (value!.isEmpty) {
      return ("รหัสผ่านไม่ควรเป็นค่าว่าง");
    }
    //กรณีรหัสผ่านน้อยกว่า 6 ตัวอักษร
    if (!regex.hasMatch(value)) {
      return ("รหัสผ่านควรไม่ต่ำกว่า 6 ตัวอักษร");
    }
  }

  String? validatorEmail(value) {
    if (value!.isEmpty) {
      return "โปรดกรอกข้อมูลอีเมลล์";
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return ("กรุณากรอก Email ให้เป็นรูปแบบที่ถูกต้อง");
    }
    return null;
  }

  String? validatorSecondName(value) {
    //กรณีไม่กรอกรหัสผ่าน
    if (value!.isEmpty) {
      return ("ชื่อจริงไม่ควรเป็นค่าว่าง");
    }
    return null;
  }

  InputDecoration decorationShow(String inputHinText, Icon inputIcon) {
    return InputDecoration(
        prefixIcon: Icon(inputIcon.icon),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: inputHinText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)));
  }

  String? validatorFirstName(value) {
    RegExp regex = new RegExp(r'^.{3,}$');
    //กรณีไม่กรอกรหัสผ่าน
    if (value!.isEmpty) {
      return ("ชื่อจริงไม่ควรเป็นค่าว่าง");
    }
    //กรณีรหัสผ่านน้อยกว่า 6 ตัวอักษร
    if (!regex.hasMatch(value)) {
      return ("ชื่อจริงไม่ควรต่ำกว่า 3 ตัวอักษร");
    }
    return null;
  }

  void signUp(String email, String password) async {
    EasyLoading.show(status: 'กำลังบันทึก');
    if (_formKey.currentState!.validate()) {
      await db
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: "เกิดข้อผิดพลาด : ${e!}");
      });

      _updateUser();

      EasyLoading.dismiss();
    }

    if ((email.isEmpty) || (password.isEmpty)) {
      EasyLoading.dismiss();
      normalDialog(context, "คำเตือน", "กรุณากรอกข้อมูลให้ครบ");
    }
  }

  postDetailsToFirestore() async {
    //กรณี กำลังติดต่อ Fire Store
    //กรณี กำลังติดต่อ User Model
    //กรณี กำลังส่งข้อมูล

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = db.currentUser;

    UserModel userModel = UserModel("uid", "email", "firstName", "secondName",
        "https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/icon-4399701_1280.webp?alt=media&token=7d6d920c-a551-41c0-9a8c-10eb7499651f");

    //กำลังเขียนค่าทั้งหมด
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstName.text;
    userModel.secondName = secondName.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap())
        .then((value) {
      print("Create Account ");
      return null;
    });

    Fluttertoast.showToast(msg: "บัญชีของคุณสร้างสำเร็จ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => page2ScanAndSaveCarbon()),
        (route) => false);
  }

  //Cloud Firestore:
  var db = FirebaseAuth.instance;

  //formKey
  final _formKey = GlobalKey<FormState>();

  //editting controller
  TextEditingController firstName = new TextEditingController();
  TextEditingController secondName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  //update header drawer
  String? currentFirstName;
  String? currentSecondName;
  String? currentPictureUrl;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _updateUser() {
    setState(() {
      currentFirstName = firstName.text;
      currentSecondName = secondName.text;
    });
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}
