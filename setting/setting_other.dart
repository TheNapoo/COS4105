// // ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, duplicate_ignore

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';

// // ignore: camel_case_types
// class aboutApp extends StatelessWidget {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

//   AndroidDeviceInfo? androidInfo;
//   Future<AndroidDeviceInfo> getInfo() async {
//     return await deviceInfo.androidInfo;
//   }

//   Widget showCard(String name, String value) {
//     return Card(
//       child: ListTile(
//         title: Text(
//           "$name : $value",
//           // ignore: prefer_const_constructors
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("ข้อมูลทั่วไป")),
//         body: SafeArea(
//             child: FutureBuilder<AndroidDeviceInfo>(
//           future: getInfo(),
//           builder: (context, snapshot) {
//             final data = snapshot.data!;
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   showCard('1', data.board),
//                   showCard('2', data.bootloader),
//                   showCard('3', data.display),
//                   showCard('4', data.fingerprint),
//                   showCard('4', data.hardware),
//                   showCard('4', data.host),
//                   showCard('4', data.id),
//                   showCard('4', data.tags),
//                   showCard('brand', data.brand),
//                   showCard('device', data.device),
//                   showCard('model', data.model),
//                   showCard('manufacturer', data.manufacturer),
//                   showCard('product', data.product),
//                   showCard('hardware', data.hardware),
//                   showCard(
//                       'isPhysicalDevice', data.isPhysicalDevice.toString()),
//                   showCard('version', data.version.release.toString()),
//                 ],
//               ),
//             );
//           },
//         )));
//   }
// }
