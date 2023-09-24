// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, always_specify_types, unused_import, file_names

import 'package:NapooCarboon/model/universal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/login.dart';

class MySignOut extends StatefulWidget {
  const MySignOut({super.key});

  @override
  State<MySignOut> createState() => _MySignOutState();
}

class _MySignOutState extends State<MySignOut> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            delDataOKCancel(
                context, "คำเตือน", "ท่านต้องการออกจากระบบใช่หรือไม่");
          },
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 36,
          ),
          title: Text(
            'ออกจากระบบ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          tileColor: Colors.red,
        ),
      ],
    );
  }
}
