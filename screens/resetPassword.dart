// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, avoid_print, unnecessary_new, file_names, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_const_constructors_in_immutables, use_build_context_synchronously, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/universal.dart';

class _resetPasswordScreenState extends State<resetPasswordScreen> {
  //formKey
  final TextEditingController emailController = new TextEditingController();

  //************************************************************* */
  //************************************************************* */
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */
  //************************************************************* */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รีเซ็ตรหัสผ่าน")),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    labelShowText("กรอกอีเมลล์ของท่าน เพื่อรีเซ็ตรหัสผ่าน"),
                    sizeBoxHeigh(20),
                    textBoxInputEmail(),
                    buttonResetPassword(),
                    //chartBar2()
                  ],
                ),
              ),
            ),
          ),
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
  ElevatedButton buttonResetPassword() {
    return ElevatedButton(
        onPressed: () {
          sendPasswordResetEmail();
        },
        child: Text("บันทึก"));
  }

  TextFormField textBoxInputEmail() {
    return TextFormField(
      controller: emailController,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  Text labelShowText(String inputText) {
    return Text(
      "${inputText}",
      style: CustomTextStyle.nameOfTextStyle,
    );
  }

  Future sendPasswordResetEmail() async {
    EasyLoading.show(status: 'กำลังส่งข้อมูล...');
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "กรุณาตรวจสอบ Email");
    } on FirebaseAuthException catch (e) {
      print(e);
      EasyLoading.dismiss();
      normalDialog(context, "ขออภัย ท่านกรอก Email ไม่ถูกต้อง", " $e");
    }
  }
}

class resetPasswordScreen extends StatefulWidget {
  resetPasswordScreen({super.key});
  @override
  State<resetPasswordScreen> createState() => _resetPasswordScreenState();
}
