// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, unnecessary_new, avoid_print, unnecessary_this, unused_field, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, file_names, unused_local_variable, dead_code, unnecessary_brace_in_string_interps, unused_import, prefer_const_declarations, unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/buttonSignOut.dart';
import '../../model/universal.dart';
import '../../model/user_model.dart';
import '../setting/page7Setting_main.dart';
import 'page1Guide.dart';
import 'page2ScanAndSave.dart';
import 'page3TableMe.dart';

class _Page4ShowChartState extends State<Page4ShowChart> {
  //************************************************************* */
  //******************************Main*************************** */
  //************************************************************* */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5, // จำนวนแท็บ
        child: Scaffold(
          appBar: appBarShowChart(),
          drawer: myDrawer(context),
          body: TabBarView(
            children: [
              Column(
                children: [
                  //กราฟแผนภูมิแท่ง
                  showChartFirebaseBox(),
                  areaLabeldetailChartFirebase(),
                ],
              ),
              Column(
                children: [
                  //กราฟแผนภูมิวงกลม
                  showChartFirebaseCircle(),
                  areaLabeldetailChartFirebase()
                ],
              ),
              Column(
                children: [
                  ////กราฟแผนภูมิ Bubble
                  showChartFirebaseBubble(),
                  areaLabeldetailChartFirebase()
                ],
              ),
              Column(
                children: [
                  //กราฟแผนภูมิแท่ง RadialBar
                  showChartFirebaseRadialBar(),
                  areaLabeldetailChartFirebase()
                ],
              ),
              Column(
                children: [
                  //กราฟแผนภูมิแท่ง Spline
                  showChartFirebaseSpline(),
                  areaLabeldetailChartFirebase()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //************************************************************* */
  //******************************initState*************************** */
  //************************************************************* */
  @override
  void initState() {
    super.initState();
    fetchDataAndInitializeUser();
    //Fluttertoast.showToast(msg: "msg : $averageFood");
    //showChartFirebase2();
  }

  //************************************************************* */
  //******************************appBarShowChart*************************** */
  //************************************************************* */

  AppBar appBarShowChart() {
    return AppBar(
      title: Text('แสดงกราฟคำนวณคาร์บอน'),
      bottom: TabBar(
        tabs: tabChartIcon,
      ),
    );
  }

  //************************************************************* */
  //******************************tabChartIcon*************************** */
  //************************************************************* */

  List<Widget> get tabChartIcon {
    return [
      Tab(icon: Icon(Icons.bar_chart)),
      Tab(icon: Icon(Icons.pie_chart)),
      Tab(icon: Icon(Icons.bubble_chart)),
      Tab(icon: Icon(Icons.radar_sharp)),
      Tab(icon: Icon(Icons.history_toggle_off_sharp)),
    ];
  }

  //************************************************************* */
  //******************************fetchDataAndInitializeUser*************************** */
  //************************************************************* */

  Future<void> fetchDataAndInitializeUser() async {
    await FirebaseFirestore.instance
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

    fetchDataCabon();

    //print("avg = ${averageFood}");
  }

  //************************************************************* */
  //******************************showdetailChartFirebase*************************** */
  //************************************************************* */

  StreamBuilder<QuerySnapshot<Object?>> areaLabeldetailChartFirebase() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc("${loggedInUser.uid}")
          .collection("saveCarboon")
          //.where("User id", isEqualTo: "BTIM5WPDfggyLZt5ElzepupyHWQ2")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;

        for (final doc in docs) {
          final getTypeFromFirebase = doc['type'];
          final getValueCarbonFromFirebase = doc['amount Carboon'];

          //คำนวณ ผลรวม และ นับจำนวน เพื่อหาค่าเฉลี่ยอาหาร
          if (getTypeFromFirebase == 'อาหาร') {
            if (getValueCarbonFromFirebase != null) {
              final carboonValue = getValueCarbonFromFirebase;
              if (carboonValue != null) {
                sumFoodCarboon += carboonValue;
                countFood++;
              }
            }
            //คำนวณ ผลรวม และ นับจำนวน เพื่อหาค่าเฉลี่ยการเดินทาง
          } else if (getTypeFromFirebase == 'การเดินทาง') {
            if (getValueCarbonFromFirebase != null) {
              final carboonValue = getValueCarbonFromFirebase;
              if (carboonValue != null) {
                sumTravelCarboon += carboonValue;
                countTravel++;
              }
            }
            //คำนวณ ผลรวม และ นับจำนวน เพื่อหาค่าเฉลี่ยพลังงานในบ้าน
          } else if (getTypeFromFirebase == 'พลังงานในบ้าน') {
            if (getValueCarbonFromFirebase != null) {
              final carboonValue = getValueCarbonFromFirebase;
              if (carboonValue != null) {
                sumHomeEnergyCarboon += carboonValue;
                countHomeEnergy++;
              }
            }
          }
        }

        return Column(
          children: [
            showLabelAverage("ค่าเฉลี่ยของอาหาร: $averageFood"),
            showLabelAverage("ค่าเฉลี่ยของการเดินทาง: $averageTravel"),
            showLabelAverage("ค่าเฉลี่ยของพลังงานในบ้าน: $averageHomeEnergy"),
          ],
        );
        areaLabeldetailChartFirebase();
      },
    );
  }

  //************************************************************* */
  //******************************showLabelAverage*************************** */
  //************************************************************* */

  Text showLabelAverage(String labelAverage) {
    return Text(
      '$labelAverage',
      style: TextStyle(fontSize: 20),
    );
  }

  //************************************************************* */
  //******************************showChartFirebaseBox*************************** */
  //************************************************************* */

  Container showChartFirebaseBox() {
    return Container(
      height: 400,
      padding: EdgeInsets.all(20.0),
      child: SfCartesianChart(
        // เลือกประเภทของกราฟ (แท่งเป็นตัวอย่าง)
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          // กำหนดข้อมูลและประเภทของกราฟ
          BarSeries<ObjectNameAndValueObject, String>(
            dataSource: <ObjectNameAndValueObject>[
              ObjectNameAndValueObject(averageFood, 'เครื่องใช้ไฟฟ้า'),
              ObjectNameAndValueObject(averageTravel, 'อุปกรณ์สำนักงาน'),
              ObjectNameAndValueObject(averageHomeEnergy, 'อาหาร'),
              ObjectNameAndValueObject(averageHomeEnergy, 'ยานพาหนะ'),
              ObjectNameAndValueObject(averageHomeEnergy, 'ของใช้ทั่วไป'),
            ],
            xValueMapper: (ObjectNameAndValueObject sales, _) => sales.object,
            yValueMapper: (ObjectNameAndValueObject sales, _) =>
                sales.valueCarbon,
          ),
        ],
      ),
    );
  }

  //************************************************************* */
  //*******************************showChartFirebaseCircle************************** */
  //************************************************************* */

  Container showChartFirebaseCircle() {
    return Container(
      height: 400,
      padding: EdgeInsets.all(20.0),
      child: SfCircularChart(
        legend: Legend(
          // ตั้งค่าเป็น true เพื่อให้แสดง Legend
          isVisible: true,
          // ตำแหน่งของ Legend (bottom, top, left, right)
          position: LegendPosition.bottom,
          // การจัดวางของ Legend (center, near, far)
          alignment: ChartAlignment.center,
          // ตั้งค่าขนาดของตัวอักษรของ Legend
          textStyle: TextStyle(fontSize: 12),
        ),
        series: <CircularSeries>[
          DoughnutSeries<ObjectNameAndValueObject, String>(
              dataSource: <ObjectNameAndValueObject>[
                ObjectNameAndValueObject(averageFood, 'อาหาร'),
                ObjectNameAndValueObject(averageTravel, 'การเดินทาง'),
                ObjectNameAndValueObject(averageHomeEnergy, 'พลังงานในบ้าน'),
              ],
              xValueMapper: (ObjectNameAndValueObject sales, _) {
                return sales.object;
              },
              yValueMapper: (ObjectNameAndValueObject sales, _) {
                var sales2 = sales;
                return sales2.valueCarbon;
              },
              // เปิดใช้งานการขยายเมื่อโดนแตะ
              explode: true,
              dataLabelSettings: DataLabelSettings(isVisible: true))
          //dataLabelSettings: DataLabelSettings()),
        ],
      ),
    );
  }

  //************************************************************* */
  //*******************************showChartFirebaseBubble************************** */
  //************************************************************* */

  Container showChartFirebaseBubble() {
    return Container(
        height: 400,
        padding: EdgeInsets.all(20.0),
        child: SfCartesianChart(
          //legend: Legend(isVisible: true),
          // เลือกประเภทของกราฟเป็น Bubble
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            // กำหนดข้อมูลและประเภทของกราฟเป็น Bubble
            BubbleSeries<ObjectNameAndValueObject, String>(
              dataSource: <ObjectNameAndValueObject>[
                ObjectNameAndValueObject(averageFood, 'อาหาร'),
                ObjectNameAndValueObject(averageTravel, 'การเดินทาง'),
                ObjectNameAndValueObject(averageHomeEnergy, 'พลังงานในบ้าน'),
              ],
              // xValueMapper ใช้กำหนดข้อมูลแกน X (String)
              xValueMapper: (ObjectNameAndValueObject sales, _) => sales.object,
              // yValueMapper ใช้กำหนดข้อมูลแกน Y (double)
              yValueMapper: (ObjectNameAndValueObject sales, _) =>
                  sales.valueCarbon,
              // sizeValueMapper ใช้กำหนดขนาดของ Bubble (double)
              //sizeValueMapper: (SalesData sales, _) => sales.size,
            ),
          ],
        ));
  }

  //************************************************************* */
  //*******************************showChartFirebaseRadialBar************************** */
  //************************************************************* */

  Container showChartFirebaseRadialBar() {
    return Container(
        height: 400,
        padding: EdgeInsets.all(20.0),
        child: SfCircularChart(
          legend: Legend(isVisible: true),
          series: <CircularSeries>[
            RadialBarSeries<ObjectNameAndValueObject, String>(
              dataSource: <ObjectNameAndValueObject>[
                ObjectNameAndValueObject(averageFood, 'อาหาร'),
                ObjectNameAndValueObject(averageTravel, 'การเดินทาง'),
                ObjectNameAndValueObject(averageHomeEnergy, 'พลังงานในบ้าน'),
              ],
              xValueMapper: (ObjectNameAndValueObject sales, _) {
                return sales.object;
              },
              yValueMapper: (ObjectNameAndValueObject sales, _) {
                return sales.valueCarbon;
              },
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelIntersectAction:
                    LabelIntersectAction.hide, // ป้องกันการแทนทับ
              ),
            ),
          ],
        ));
  }

  //************************************************************* */
  //*******************************showChartFirebaseSpline************************** */
  //************************************************************* */

  Container showChartFirebaseSpline() {
    return Container(
      height: 400,
      padding: EdgeInsets.all(20.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(), // กำหนดแกน X เป็นแบบ Category (String)
        series: <ChartSeries>[
          SplineSeries<ObjectNameAndValueObject, String>(
            // กำหนด Series เป็น Spline
            dataSource: <ObjectNameAndValueObject>[
              ObjectNameAndValueObject(averageFood, 'อาหาร'),
              ObjectNameAndValueObject(averageTravel, 'การเดินทาง'),
              ObjectNameAndValueObject(averageHomeEnergy, 'พลังงานในบ้าน'),
            ],
            xValueMapper: (ObjectNameAndValueObject sales, _) => sales.object,
            yValueMapper: (ObjectNameAndValueObject sales, _) {
              var sales2 = sales;
              return sales2.valueCarbon;
            },
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  //************************************************************* */
  //******************************fetchDataCabon*************************** */
  //************************************************************* */
  Future<void> fetchDataCabon() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc("${loggedInUser.uid}")
          .collection("saveCarboon")
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          final objectType = doc['type'];
          final double objectValueCarboon = doc['amount Carboon'];

          //foodAverage = foodA;

          setState(() {
            if (objectType == 'อาหาร') {
              if (objectValueCarboon != 0) {
                final carboonValue = objectValueCarboon;
                if (carboonValue != 0) {
                  sumFoodCarboon += carboonValue;
                  countFood++;
                  averageFood = sumFoodCarboon / countFood;
                  Fluttertoast.showToast(msg: "111 $averageFood");
                }
              }
            } else if (objectType == 'การเดินทาง') {
              if (objectValueCarboon != 0) {
                final carboonValue = objectValueCarboon;
                if (carboonValue != 0) {
                  sumTravelCarboon += carboonValue;
                  countTravel++;
                  averageTravel = sumTravelCarboon / countTravel;
                }
              }
            } else if (objectType == 'พลังงานในบ้าน') {
              if (objectValueCarboon != 0) {
                final carboonValue = objectValueCarboon;
                if (carboonValue != 0) {
                  sumHomeEnergyCarboon += carboonValue;
                  countHomeEnergy++;
                  averageHomeEnergy = sumHomeEnergyCarboon / countHomeEnergy;
                }
              }
            } else {}
            //averageFood = foodA;
            //averageHomeEnergy = homeA;
            //averageTravel = travelA;
          });
          //print("avg cabon = ${averageFood}");
        }
      }
    } catch (error) {
      print('เกิดข้อผิดพลาด: $error');
    }
  }

  //************************************************************* */
  //******************************myDrawer*************************** */
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
            CustomTextStyle.menuCurrent,
            CustomTextStyle.colorMenuCurrent(),
            statusCurrentMenu: true,
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
  //******************************headerAccountDraw*************************** */
  //************************************************************* */
  Text labelEmailInHeaderDrawer(TextStyle textStyle) {
    return Text(
      "Email :  ${loggedInUser.email}",
      style: textStyle,
    );
  }

  bool? isImageLoading3;
  UserAccountsDrawerHeader headerAccountDraw() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color:
            CustomTextStyle().setColorDrawerHeader(), // สีพื้นหลังที่คุณต้องการ
      ),
      accountName: Text(
        "${loggedInUser.firstName} ${loggedInUser.secondName}",
        style: CustomTextStyle.nameOfTextStyle,
      ),
      accountEmail: labelEmailInHeaderDrawer(CustomTextStyle.normalText),
      currentAccountPicture: () {
        if (isImageLoading3 == true) {
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
  //******************************firebase*************************** */
  //************************************************************* */
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser =
      UserModel(null, null, null, null, "$imageAccountBegin()");

  TextEditingController firstName = new TextEditingController();
  TextEditingController secondName = new TextEditingController();
  TextEditingController email = new TextEditingController();

  //สำคัญคำนวณค่าเฉลี่ยอาหาร
  double sumFoodCarboon = 0;
  int countFood = 0;
  double averageFood = 0;

  //สำคัญคำนวณค่าเฉลี่ยการเดินทาง
  double sumTravelCarboon = 0;
  int countTravel = 0;
  double averageTravel = 0;

  //สำหรับคำนวณค่าเฉลี่ยพลังงานในบ้าน
  double sumHomeEnergyCarboon = 0;
  int countHomeEnergy = 0;
  double averageHomeEnergy = 0;
}

//************************************************************* */
//******************************ObjectNameAndValueObject*************************** */
//************************************************************* */

class ObjectNameAndValueObject {
  String object;
  double valueCarbon;

  ObjectNameAndValueObject(this.valueCarbon, this.object);
}

//************************************************************* */
//******************************Page4ShowChart*************************** */
//************************************************************* */

class Page4ShowChart extends StatefulWidget {
  @override
  _Page4ShowChartState createState() => _Page4ShowChartState();
}
