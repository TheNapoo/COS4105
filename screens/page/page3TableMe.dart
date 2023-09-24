// ignore_for_file: prefer_const_constructors, unnecessary_this, unnecessary_new, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls, avoid_print, no_leading_underscores_for_local_identifiers, prefer_final_fields, unnecessary_string_interpolations, sized_box_for_whitespace, dead_code, avoid_unnecessary_containers, file_names, unnecessary_brace_in_string_interps, depend_on_referenced_packages, camel_case_types, unused_field, unused_element, non_constant_identifier_names, unused_import, sort_child_properties_last, prefer_void_to_null, unused_local_variable, unnecessary_null_comparison, deprecated_member_use

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../model/buttonSignOut.dart';
import '../../model/universal.dart';
import '../../model/user_model.dart';
import '../setting/page7Setting_main.dart';
import 'page1Guide.dart';
import 'page2ScanAndSave.dart';
import 'page4ChartMe.dart';

class _page3ShowTableCarbonMeState extends State<page3ShowTableCarbonMe> {
  //************************************************************* */
  //******************************main*************************** */
  //************************************************************* */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: () {
        if (iconAppBarSort == true && iconAppBarFilter == false) {
          return appBarShowIconFilter();
        } else if (iconAppBarFilter == true && iconAppBarSort == false) {
          return appBarShowIconSort();
        } else {
          return appBarShowIconSortAndFilter();
        }
      }(),
      drawer: myMenuDrawer(context),
      body: Column(
        children: <Widget>[
          visibleFilterThenClickIconOnAppbar(),
          visibleSortThenClickIconOnAppbar(),
          txtValue == null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : objectFirstCollection != null
                  ? showTableDataBase(inputTxtValue: txtValue)
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Center(
                        child: Text("ไม่มีข้อมูล ๆ เนื่องจากไม่ได้สแกนวัตถุ"),
                      ),
                    ),
          //showTableDataBase(inputTxtValue: objectFirstCollection),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //color: Colors.black,
                height: 60,
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width / 2.2,
                child: buttonShowChart(context, "แสดงกราฟ"),
              ),
              Container(
                //color: Colors.black,
                height: 60,
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width / 2.2,
                child: buttonSaveCarboon(context, "เพิ่มวัตถุ"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  @override
  void initState() {
    super.initState();
    newMethod();
  }

  Future<void> newMethod() async {
    loadModel();
    loadCamera();

    super.initState();
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
    loadValueFromSharedPreferences();

    showFieldFirst();
    // Fluttertoast.showToast(
    //     msg: "objectFirstCollection : $objectFirstCollection");
  }

  //************************************************************* */
  //******************************ShowAndHideIcon*************************** */
  //************************************************************* */

  AppBar appBarShowIconSortAndFilter() {
    return myTitleAndIconAppbar(
      "แสดงคาร์บอนของฉัน",
      iconSort(Icon(Icons.sort_by_alpha)), //แสดงไอคอน Sort
      iconFilter(Icon(Icons.filter_alt)), //แสดงไอคอน Filter
    );
  }

  AppBar appBarShowIconSort() {
    return myTitleAndIconAppbar(
      "แสดงคาร์บอนของฉัน",
      iconSort(Icon(Icons.sort_by_alpha)), //แสดงไอคอน Sort
      iconFilter(Icon(Icons.verified)), //ซ่อนไอคอน Filter
    );
  }

  AppBar appBarShowIconFilter() {
    return myTitleAndIconAppbar(
      "แสดงคาร์บอนของฉัน",
      iconSort(Icon(Icons.verified)), //ซ่อนไอคอน Sort
      iconFilter(Icon(Icons.filter_alt)), //แสดงไอคอน Filter
    );
  }

  //************************************************************* */
  //************************loadValueFromSharedPreferences******************** */
  //************************************************************* */

  void loadValueFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('valueOpenCloseDelTable');

    if (value != null) {
      setState(() {
        valueOpenCloseDelTable = value;
      });
    }
  }

  //************************************************************* */
  //************************visibleFuncSort******************** */
  //************************************************************* */

  Visibility visibleSortThenClickIconOnAppbar() {
    return Visibility(
      visible: iconAppBarSort, // เป็น boolean ที่บอกว่าควรแสดง Column หรือไม่
      child: funcSort(),
    );
  }

  Visibility visibleFilterThenClickIconOnAppbar() {
    return Visibility(
      visible: iconAppBarFilter, // เป็น boolean ที่บอกว่าควรแสดง Column หรือไม่
      child: funcFilterOnAppbar(),
    );
  }

  //************************************************************* */
  //************************_buildAlertDialog******************** */
  //************************************************************* */

  AlertDialog _buildAlertDialog() {
    return AlertDialog(
      title: Text('เลือกรายการ:'),
      content: DropdownButton<String>(
        value: selectedOption,
        onChanged: (newValue) {
          setState(() {
            selectedOption = newValue!;
          });
        },
        items: items.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, selectedOption);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  //************************************************************* */
  //************************_startAutoRefresh******************** */
  //************************************************************* */

  void _startAutoRefresh() {
    // สร้าง Timer เพื่อรีเฟรช AlertDialog ทุก 5 วินาที
    Timer.periodic(Duration(seconds: 5), (timer) {
      // เรียกใช้ setState เพื่อสร้าง AlertDialog ใหม่
      setState(() {
        alertDialog = _buildAlertDialog();
      });
    });
  }

  //************************************************************* */
  //************************funcFilter******************** */
  //************************************************************* */

  Container funcFilterOnAppbar() {
    return Container(
      color: Colors.blueGrey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              color: Colors.blueGrey[100],
              child: labelFilter("เลือกวัตถุใด โชว์วัตถุนั้น ๆ "),
            ),
          ),
          area100RadioShowLabelSelectObject("เลือกวัตถุ"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: area111RadioSelectFromDropdownList("จาก Dropdown List"),
          ),
          Visibility(
            //ค่าใน Dropdown List เริ่มต้น
            visible: beginFalse101_2_object_selectDropDownList,
            child: area112DropDownListFromFirebase(),
            //child: Text("ok"),
          ),
          area121radioByScanPhotoObject("โดย scan วัตถุ"),
          Visibility(
            visible: beginFalse102_2_object_areaPhoto,
            //child: Text("ok"),
            child: area122ShowCameraScanObject(),
          ),
          area200ShowAllData(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [],
          )
        ],
      ),
    );
  }

  RadioListTile<bool> area200ShowAllData() {
    return RadioListTile<bool>(
      title: Text("แสดงข้อมูลทั้งหมด"),
      value: true,
      groupValue: beginFalse200_bigAll,
      onChanged: (value) {
        if (beginFalse200_bigAll == true) {
          // showTableDataBase(
          //     inputTxtValue: objectFirstCollection); // กรองตามประเภท
        } else {
          // showTableDataBase(
          //     inputTxtValue: objectFirstCollection); // แสดงข้อมูลทั้งหมด
        }
        //showTableDataBase(inputTxtValue: objectFirstCollection);
        setState(() {
          beginFalse200_bigAll = value!;
          subRadioValue = 0;
          beginFalse100_bigObject = false;
          beginFalse11_1_object_textDropdownlist = false;
          beginFalse101_2_object_selectDropDownList = false;
          beginFalse12_1_object_textScan = false;
          beginFalse102_2_object_areaPhoto = false;
        });
      },
    );
  }

  Padding area122ShowCameraScanObject() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        children: [
          areaCamera(context, 0.25),
          Text('${resultThenScanObjectByLeanAI}'),
        ],
      ),
    );
  }

  Padding area121radioByScanPhotoObject(String inputLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: RadioListTile<bool>(
        title: normalLabel("$inputLabel"),
        value: true,
        groupValue: beginFalse12_1_object_textScan,
        onChanged: (value) {
          beginFalse101_2_object_selectDropDownList = false;
          beginFalse102_2_object_areaPhoto = true;
          //showTableDataBase(inputTxtValue: objectFirstCollection);
          setState(() {
            beginFalse12_1_object_textScan = value!;
            beginFalse100_bigObject = true;
            beginFalse11_1_object_textDropdownlist = false;
            beginFalse200_bigAll = false;
          });
        },
      ),
    );
  }

  Padding area112DropDownListFromFirebase() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 42),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(loggedInUser.uid)
                      .collection("saveCarboon")
                      .snapshots(),
                  builder: (context, snapshot) {
                    // กรณีกำลังโหลดข้อมูล
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    List<DocumentSnapshot> documents;
                    documents = snapshot.data!.docs;

                    List<String> objectName = documents
                        .map((doc) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          return data['name object']
                              .toString(); // แก้ไขให้ตรงกับชื่อฟิลด์ใน Firestore
                        })
                        .toSet() // ไม่โชว์รายการที่ซ้ำกัน
                        .toList();

                    if (objectName.isEmpty) {
                      return Text("ข้อมูลว่าง");
                    } else {
                      return dropDownListObjectName(objectName);
                    }
                  },
                ),

                //dropDownConditation(),
                //textInputNumber()
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? objectFirstCollection;
  Future<void> showFieldFirst() async {
    try {
      QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc("${loggedInUser.uid}")
          .collection("saveCarboon")
          .get();

      if (subCollectionSnapshot.docs.isNotEmpty) {
        setState(() {
          DocumentSnapshot firstDocumentSnapshot =
              subCollectionSnapshot.docs.first;
          //ดึงข้อมูลจากเอกสารแรกในคอลเลกชันย่อย:
          Map<String, dynamic> subCollectionData =
              firstDocumentSnapshot.data() as Map<String, dynamic>;

          // นำค่าจากฟิลด์ที่สามของเอกสารในคอลเลกชันย่อย
          dynamic getValueObjectFirstCollection =
              subCollectionData['name object'];

          if (getValueObjectFirstCollection is String) {
            txtValue = getValueObjectFirstCollection;
            objectFirstCollection = getValueObjectFirstCollection;
            // Fluttertoast.showToast(
            //     msg: "ชื่อวัตถุในฟิลแรกคือ $objectFirstCollection");
          } else {
            //objectFirstCollection = "ชื่อวัตถุในฟิลแรกไม่ใช่ข้อความ";
            // Fluttertoast.showToast(
            //     msg: "ชื่อวัตถุในฟิลแรกคือ $objectFirstCollection");
          }
        });
      } else {
        //objectFirstCollection = "ไม่มีข้อมูลใด ๆ ";
        print("ไม่มีข้อมูลใด ๆ ");
      }
      //return objectFirstCollection;
    } catch (error) {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด: $error');
    }
  }

  RadioListTile<bool> area111RadioSelectFromDropdownList(String inputLabel) {
    return RadioListTile<bool>(
      title: normalLabel("$inputLabel"),
      value: true,
      groupValue: beginFalse11_1_object_textDropdownlist,
      onChanged: (value) {
        //showTableDataBase(inputTxtValue: objectFirstCollection);
        beginFalse101_2_object_selectDropDownList = true;
        beginFalse102_2_object_areaPhoto = false;
        setState(() {
          beginFalse11_1_object_textDropdownlist = value!;
          beginFalse100_bigObject = true;
          beginFalse12_1_object_textScan = false;
          beginFalse200_bigAll = false;
        });
      },
    );
  }

  RadioListTile<bool> area100RadioShowLabelSelectObject(String inputLabel) {
    return RadioListTile<bool>(
      title: normalLabel("$inputLabel"),
      value: true,
      groupValue: beginFalse100_bigObject,
      onChanged: (value) {
        beginFalse101_2_object_selectDropDownList = true;
        beginFalse12_1_object_textScan = false;
        setState(() {
          beginFalse100_bigObject = value!;
          beginFalse11_1_object_textDropdownlist = true;
          beginFalse200_bigAll = false;
        });
      },
    );
  }

  Text labelFilter(String inputLabel) {
    return Text(
      "$inputLabel",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  //************************************************************* */
  //************************funcSort******************** */
  //************************************************************* */
  bool sortByObject = false;
  bool visibleSortByDate = true;

  Column funcSort() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textShow("ข้อมูลเท่าเดิม แค่เรียงลำดับใหม่"),
        DropdownButton(
          value: beginItem_Object_Date_TypeObject,
          onChanged: (String? value) {
            setState(() {
              beginItem_Object_Date_TypeObject = value!;
              if (value == "วัตถุ") {
                sortByObject = true;
                visibleSortByDate = false;
              } else if (value == "เวลา") {
                visibleSortByDate = true;
                sortByObject = false;
              }
            });
          },
          items: item_Object_Date_TypeObject
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),

        //************************************************************* */
        //************************sortByObject******************** */
        //************************************************************* */

        Visibility(
          visible: sortByObject,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RadioListTile<SortOrderObject>(
              title: Text('จาก ก. ไป ฮ.'),
              value: SortOrderObject.fromLowestToHighest,
              groupValue: selectedSortObject,
              onChanged: (SortOrderObject? value) {
                setState(() {
                  selectedSortObject = value!;
                  //sortByDate = true;
                  sortByObject = true;
                  print("123123 $value");
                });
              },
            ),
          ),
        ),
        Visibility(
          visible: sortByObject,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RadioListTile<SortOrderObject>(
              title: Text('จาก ฮ. ไป ก.'),
              value: SortOrderObject.fromHighestToLowest,
              groupValue: selectedSortObject,
              onChanged: (SortOrderObject? value) {
                setState(() {
                  selectedSortObject = value!;
                  sortByObject = false;
                  //sortByDate = false;
                });
              },
            ),
          ),
        ),

        //************************************************************* */
        //************************sortByDate******************** */
        //************************************************************* */
        //เมื่อปัจจุบันไปเก่าถูกคลิก

        Visibility(
          visible: visibleSortByDate,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RadioListTile<SortOrderDate>(
              title: Text('ปัจจุบันไปเก่า'),
              value: SortOrderDate.fromLowestToHighest,
              groupValue: selectedSortOrder,
              onChanged: (SortOrderDate? value) {
                setState(() {
                  selectedSortOrder = value!;
                  statusSortByDate = true;
                  print("123123 $value");
                });
              },
            ),
          ),
        ),
        //เมื่อจากเก่าไปปัจุบบันถูกคลิก
        Visibility(
          visible: visibleSortByDate,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RadioListTile<SortOrderDate>(
              title: Text('จากเก่าไปปัจจุบัน'),
              value: SortOrderDate.fromHighestToLowest,
              groupValue: selectedSortOrder,
              onChanged: (SortOrderDate? value) {
                setState(() {
                  selectedSortOrder = value!;
                  visibleSortByDate = true;
                  statusSortByDate = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Padding textShow(String inputText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: const Color.fromARGB(255, 59, 88, 255),
        child: Text(
          "$inputText",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //************************************************************* */
  //************************normalLabel******************** */
  //************************************************************* */

  Text normalLabel(String inputLabel) {
    return Text(
      "$inputLabel",
      style: CustomTextStyle.normalText,
    );
  }

  //************************************************************* */
  //************************dropDownListObjectName******************** */
  //************************************************************* */

  DropdownButton<String> dropDownListObjectName(List<String> selectField) {
    return DropdownButton<String>(
      value: txtValue,
      onChanged: (newValue) {
        setState(() {
          txtValue = newValue!;
          Fluttertoast.showToast(msg: "แสดงค่า txtValue : $txtValue");
          selectedObject = newValue;
        });
      },
      items: selectField.map((String valueObject) {
        return DropdownMenuItem<String>(
          value: valueObject,
          child: Text(valueObject),
        );
      }).toList(),
    );
  }

  //************************************************************* */
  //************************buttonSort******************** */
  //************************************************************* */

  ElevatedButton buttonSort() {
    return ElevatedButton(
      onPressed: () {
        //showTableDataBase(inputTxtValue: objectFirstCollection);
        setState(() {
          beginFalse100_bigObject = true;
          iconAppBarFilter = !iconAppBarFilter;
        });
      },
      child: SizedBox(
        //height: 50,
        width: 150,
        child: Align(
          alignment: Alignment.center,
          child: Text("กรองข้อมูล"),
        ),
      ),
    );
  }

  //************************************************************* */
  //************************textInputNumber******************** */
  //************************************************************* */

  SizedBox textInputNumber() {
    return SizedBox(
      width: 80,
      child: TextFormField(
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'กรอกตัวเลขเท่านั้น',
          hintText: 'เช่น 12345',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  //************************************************************* */
  //************************showTableDataBase******************** */
  //************************************************************* */

  Expanded showTableDataBase({String? inputTxtValue}) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.yellow,
        child: StreamBuilder(
          stream: () {
            //เลือกวัตถุจาก DropDownList
            if (beginFalse200_bigAll == true && statusSortByDate == true) {
              //Fluttertoast.showToast(msg: "เข้าเงื่อนไข 1");
              //แสดงข้อมูลทั้งหมด && ปัจจุบันไปเก่า
              return FirebaseFirestore.instance
                  .collection("users")
                  .doc("${loggedInUser.uid}")
                  .collection("saveCarboon")
                  .orderBy("date Time", descending: true)
                  .snapshots();
            } else if (beginFalse200_bigAll == true &&
                statusSortByDate == false) {
              //Fluttertoast.showToast(msg: "เข้าเงื่อนไข 2");
              return FirebaseFirestore.instance
                  .collection("users")
                  .doc("${loggedInUser.uid}")
                  .collection("saveCarboon")
                  //แสดงข้อมูลทั้งหมด && จากเก่าไปปัจจุบัน
                  .orderBy("date Time", descending: false)
                  .snapshots();

              //***************************************** */
              //**********Filter************************* */
            } else if (beginFalse200_bigAll == false &&
                beginFalse11_1_object_textDropdownlist == true) {
              if (txtValue != null) {
                //Fluttertoast.showToast(msg: "เข้าเงื่อนไข 3");
                return FirebaseFirestore.instance
                    .collection("users")
                    .doc("${loggedInUser.uid}")
                    .collection("saveCarboon")
                    .where("name object", isEqualTo: "${txtValue}")
                    .snapshots();
              } else {
                Text("ไม่ข้อมูลใด ๆ เนื่องจากไม่ได้สแกนวัตถุ");
              }
            } else {
              //Fluttertoast.showToast(msg: "เข้าเงื่อนไข 4");
              FirebaseFirestore.instance
                  .collection("users")
                  .doc("${loggedInUser.uid}")
                  .collection("saveCarboon")
                  .orderBy("name object", descending: false)
                  .snapshots()
                  .listen((QuerySnapshot snapshot) {
                // ตรวจสอบว่ามีข้อมูลหรือไม่
                if (snapshot.docs.isNotEmpty) {
                  // มีข้อมูล
                } else {
                  // ไม่มีข้อมูล
                  Text("ไม่พบข้อมูลใด ๆ ");
                  dataI = true;
                }
              });
            }
          }(),
//เลือกวัตถุจาก Scan Photo
//       stream: beginFalse12_1_object_textScan == true
//           ? FirebaseFirestore.instance
//               .collection("users")
//               .doc("${loggedInUser.uid}")
//               .collection("saveCarboon")
//               .where("name object",
//                   isEqualTo: "${resultThenScanObjectByLeanAI}")
//               .snapshots()
// //เลือกวัตถุทั้งหมด
//           : sortByDate == true
//               ? FirebaseFirestore.instance
//                   .collection("users")
//                   .doc("${loggedInUser.uid}")
//                   .collection("saveCarboon")
//                   //ปัจจุบัน เก่า
//                   .orderBy("date Time", descending: true)
//                   .snapshots()
//               : sortByObject == true && sortByDate == false
//                   ? FirebaseFirestore.instance
//                       .collection("users")
//                       .doc("${loggedInUser.uid}")
//                       .collection("saveCarboon")
//                       //เรียงจากล่าสุดไว้ด้านบน
//                       .orderBy("name object", descending: false)
//                       .snapshots()
//                   : sortByObject == false
//                       ? FirebaseFirestore.instance
//                           .collection("users")
//                           .doc("${loggedInUser.uid}")
//                           .collection("saveCarboon")
//                           //เรียงจากล่าสุดไว้ด้านบน
//                           .orderBy("name object", descending: true)
//                           .snapshots()
//                       : FirebaseFirestore.instance
//                           .collection("users")
//                           .doc("${loggedInUser.uid}")
//                           .collection("saveCarboon")
//                           //เรียงจากล่าสุดไว้ด้านบน
//                           .orderBy("date Time", descending: false)
//                           .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DateTime date =
                        (snapshot.data!.docs[index]['date Time'] as Timestamp)
                            .toDate();
                    String dateAndTimeFormatted =
                        DateFormat('EEEE , dd/MM/yyyy HH:mm').format(date);

                    String nameObject =
                        (snapshot.data!.docs[index]["name object"]);

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 80,
                        decoration: boxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                sizeBoxHeigh(20),
                                Visibility(
                                  child: Text("มีข้อมูล"),
                                  visible: dataI,
                                ),
                                showListNameObject(context, index, nameObject),
                                showListDateTime(context, dateAndTimeFormatted),
                                showListTypeObject(context, snapshot, index),
                                Visibility(
                                  visible: true,
                                  child: buttonDel(snapshot, index, context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ),
    );
  }

  //************************************************************* */
  //************************showObjectNameThenCamera******************** */
  //************************************************************* */

  Text showObjectNameThenCamera() {
    return Text("วัตถุ : ${resultThenScanObjectByLeanAI}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
  }

  //************************************************************* */
  //************************dataBase******************** */
  //************************************************************* */
  bool dataI = false;
  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> dataBase(
      {String? valueInputFromDropDownList}) {
    return StreamBuilder(
      stream: () {
        //เลือกวัตถุจาก DropDownList
        if (beginFalse200_bigAll == true && statusSortByDate == true) {
          return FirebaseFirestore.instance
              .collection("users")
              .doc("${loggedInUser.uid}")
              .collection("saveCarboon")
              .orderBy("date Time", descending: true)
              .snapshots();
        } else if (beginFalse200_bigAll == true && statusSortByDate == false) {
          return FirebaseFirestore.instance
              .collection("users")
              .doc("${loggedInUser.uid}")
              .collection("saveCarboon")
              //เรียงจากล่าสุดไว้ด้านบน
              .orderBy("date Time", descending: false)
              .snapshots();

          //***************************************** */
          //**********Filter************************* */
        } else if (beginFalse200_bigAll == false && statusSortByDate == false) {
          return FirebaseFirestore.instance
              .collection("users")
              .doc("${loggedInUser.uid}")
              .collection("saveCarboon")
              //เรียงจากล่าสุดไว้ด้านบน
              .orderBy("date Time", descending: false)
              .snapshots();
        } else {
          FirebaseFirestore.instance
              .collection("users")
              .doc("${loggedInUser.uid}")
              .collection("saveCarboon")
              //เรียงจากล่าสุดไว้ด้านบน
              .orderBy("name object", descending: false)
              .snapshots()
              .listen((QuerySnapshot snapshot) {
            // ตรวจสอบว่ามีข้อมูลหรือไม่
            if (snapshot.docs.isNotEmpty) {
              // มีข้อมูล
            } else {
              // ไม่มีข้อมูล
              Text("ไม่พบข้อมูลใด ๆ ");
              dataI = true;
            }
          });
        }
      }(),
//เลือกวัตถุจาก Scan Photo
//       stream: beginFalse12_1_object_textScan == true
//           ? FirebaseFirestore.instance
//               .collection("users")
//               .doc("${loggedInUser.uid}")
//               .collection("saveCarboon")
//               .where("name object",
//                   isEqualTo: "${resultThenScanObjectByLeanAI}")
//               .snapshots()
// //เลือกวัตถุทั้งหมด
//           : sortByDate == true
//               ? FirebaseFirestore.instance
//                   .collection("users")
//                   .doc("${loggedInUser.uid}")
//                   .collection("saveCarboon")
//                   //ปัจจุบัน เก่า
//                   .orderBy("date Time", descending: true)
//                   .snapshots()
//               : sortByObject == true && sortByDate == false
//                   ? FirebaseFirestore.instance
//                       .collection("users")
//                       .doc("${loggedInUser.uid}")
//                       .collection("saveCarboon")
//                       //เรียงจากล่าสุดไว้ด้านบน
//                       .orderBy("name object", descending: false)
//                       .snapshots()
//                   : sortByObject == false
//                       ? FirebaseFirestore.instance
//                           .collection("users")
//                           .doc("${loggedInUser.uid}")
//                           .collection("saveCarboon")
//                           //เรียงจากล่าสุดไว้ด้านบน
//                           .orderBy("name object", descending: true)
//                           .snapshots()
//                       : FirebaseFirestore.instance
//                           .collection("users")
//                           .doc("${loggedInUser.uid}")
//                           .collection("saveCarboon")
//                           //เรียงจากล่าสุดไว้ด้านบน
//                           .orderBy("date Time", descending: false)
//                           .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DateTime date =
                    (snapshot.data!.docs[index]['date Time'] as Timestamp)
                        .toDate();
                String dateAndTimeFormatted =
                    DateFormat('EEEE , dd/MM/yyyy HH:mm').format(date);

                String nameObject = (snapshot.data!.docs[index]["name object"]);

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 80,
                    decoration: boxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            sizeBoxHeigh(20),
                            Visibility(
                              child: Text("มีข้อมูล"),
                              visible: dataI,
                            ),
                            showListNameObject(context, index, nameObject),
                            showListDateTime(context, dateAndTimeFormatted),
                            showListTypeObject(context, snapshot, index),
                            Visibility(
                              visible: true,
                              child: buttonDel(snapshot, index, context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else {
          return SizedBox(
              height: 150, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  //************************************************************* */
  //************************dataBase******************** */
  //************************************************************* */

  IconButton buttonDel(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index, BuildContext context) {
    return IconButton(
        onPressed: () {
          Future<Null> delDataOKCancel(
              BuildContext context, String title, String message) async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: ListTile(
                      leading: Icon(Icons.campaign),
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
                          deleteData(snapshot.data!.docs[index].id);
                        },
                        child: const Text('ใช่ถูกต้อง'),
                      ),
                    ],
                  );
                });
          }

          delDataOKCancel(
              context,
              "${snapshot.data!.docs[index]["name object"]}",
              "เป็นข้อมูลที่ท่านต้องการลบใช่หรือไม่");
        },
        icon: Icon(Icons.delete));
  }

  //************************************************************* */
  //************************getTest13******************** */
  //************************************************************* */

  bool getTest13(bool test13) {
    bool test12 = test13;
    return test12;
  }

  //************************************************************* */
  //************************deleteData******************** */
  //************************************************************* */

  void deleteData(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(loggedInUser.uid)
          .collection("saveCarboon")
          .doc(documentId)
          .delete();
      print('ลบข้อมูลเรียบร้อยแล้ว');
      Fluttertoast.showToast(msg: "ลบข้อมูลสำเร็จ");
    } catch (e) {
      print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
      Fluttertoast.showToast(msg: "เกิดข้อผิดพลาด $e");
    }
  }

  //************************************************************* */
  //************************headerTableinPadding******************** */
  //************************************************************* */

  Padding headerTableinPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 80,
        decoration: boxDecoration(),
        child: Container(
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              headerTable(context, "ชื่อวัตถุ", "วัน เดือน ปี", "ประเภท"),
            ],
          ),
        ),
      ),
    );
  }

  //************************************************************* */
  //************************headerTable******************** */
  //************************************************************* */

  Row headerTable(BuildContext context, String headerObjectName,
      String headerObjectDate, String headerTypeObject) {
    return Row(
      children: [
        sizeBoxHeigh(20),
        //Text("001"),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Text("$headerObjectName"),
        ),

        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Text("$headerObjectDate"),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Text("$headerTypeObject"),
        ),
        // showListNameObject(context, run, nameObject),
        // showListDateTime(context, dateAndTimeFormatted),
        // showListTypeObject(context, snapshot, run),
        // IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.edit))
      ],
    );
  }

  //************************************************************* */
  //************************myTitleAndIconAppbar******************** */
  //************************************************************* */

  AppBar myTitleAndIconAppbar(String textAppBar, IconButton buttonIconSort,
      IconButton buttonIconFilter) {
    return AppBar(
      title: Text(textAppBar),
      actions: <Widget>[buttonIconSort, buttonIconFilter],
    );
  }
  //************************************************************* */
  //************************buttonShowChart******************** */
  //************************************************************* */

  ElevatedButton buttonShowChart(BuildContext context, String inputPageChart) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Page4ShowChart()));
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 84, 42, 70), // กำหนดสีพื้นหลังของปุ่ม
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          shadowColor: Color.fromARGB(255, 0, 0, 0),
          elevation: 5,
        ), // กำหนดสีของตัวอักษร
        child: Text("$inputPageChart"));
  }

  //************************************************************* */
  //************************buttonSaveCarboon******************** */
  //************************************************************* */

  ElevatedButton buttonSaveCarboon(
    BuildContext context,
    String labelButton,
  ) {
    return ElevatedButton(
      onPressed: () {
        txtValue = resultThenScanObjectByLeanAI;
        print("อ่านค่าได้ คือ ${txtValue}");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => page2ScanAndSaveCarbon()));
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 26, 122, 0), // กำหนดสีพื้นหลังของปุ่ม
        onPrimary: Color.fromARGB(255, 255, 255, 255),
        shadowColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 5,
      ), // กำหนดสีของตัวอักษร
      child: Text("$labelButton"),
    );
  }

  //************************************************************* */
  //************************boxDecoration******************** */
  //************************************************************* */

  BoxDecoration boxDecoration() {
    return BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(25));
  }

  //************************************************************* */
  //************************showListNameObject******************** */
  //************************************************************* */

  Container showListNameObject(
      BuildContext context, int index, String nameObject) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      // child: Text(snapshot.data!
      //     .docs[index]["name object"]
      //     .toString())
      child: Text("${index + 1}. ${nameObject}"),
    );
  }

  //************************************************************* */
  //************************showListTypeObject******************** */
  //************************************************************* */

  Container showListTypeObject(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Text(snapshot.data!.docs[index]["type"].toString()));
  }

  //************************************************************* */
  //************************showListDateTime******************** */
  //************************************************************* */

  Container showListDateTime(
      BuildContext context, String dateAndTimeFormatted) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Text(" ${dateAndTimeFormatted}"),
    );
  }

  //************************************************************* */
  //************************titleAmountCarboon******************** */
  //************************************************************* */

  Expanded titleAmountCarboon(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(3.5),
      color: Colors.pink,
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.08,
      child: Text(
        'หัวข้อที่ 3',
        style: TextStyle(
          fontSize: 15.2,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    ));
  }

  //************************************************************* */
  //************************titleDateTime******************** */
  //************************************************************* */

  Expanded titleDateTime(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(3.5),
      color: Colors.pink,
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.08,
      child: Text(
        'หัวข้อที่ 2',
        style: TextStyle(
          fontSize: 15.2,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    ));
  }

  //************************************************************* */
  //************************titleNameObject******************** */
  //************************************************************* */

  Expanded titleNameObject(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(3.5),
      color: Colors.pink,
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.08,
      child: Text(
        'หัวข้อที่ 1',
        style: TextStyle(
          fontSize: 15.2,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    ));
  }

  //************************************************************* */
  //************************myMenuDrawer******************** */
  //************************************************************* */

  Drawer myMenuDrawer(BuildContext context) {
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
            CustomTextStyle.menuCurrent,
            CustomTextStyle.colorMenuCurrent(),
            statusCurrentMenu: true,
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
  //************************selectedOption******************** */
  //************************************************************* */

  String selectedOption = 'มากกว่า'; //
  IconButton iconSortDialog() {
    return IconButton(
      icon: Icon(
        color: Colors.white,
        Icons.sort_outlined,
      ),
      onPressed: () {
        //dialogSort(context, "เลือกวัตถุ", "ดำด");

        setState(() {
          //showVisible = !showVisible;
          //funcSort();
        });
        //_showDropdownDialog(context);
      },
    );
  }

  //************************************************************* */
  //************************iconFilter******************** */
  //************************************************************* */

  IconButton iconFilter(Icon inputIconFilter) {
    return IconButton(
      icon: inputIconFilter,
      color: Colors.white,
      onPressed: () {
        setState(() {
          iconAppBarFilter = !iconAppBarFilter;
          iconAppBarSort = false;
        });
        //_showDropdownDialog(context);
      },
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  IconButton iconSort(Icon inputIcon) {
    return IconButton(
      icon: inputIcon,
      color: Colors.white,
      onPressed: () {
        setState(() {
          iconAppBarSort = !iconAppBarSort;
          iconAppBarFilter = false;
        });
        //_showDropdownDialog(context);
      },
    );
  }

  //************************************************************* */
  //************************showAreaSort******************** */
  //************************************************************* */

  void retrievaSubCol() {
    db.collection("users").get().then((value) {
      value.docs.forEach((result) {
        db
            .collection("users")
            .doc(result.id)
            .collection("saveCarboon")
            .snapshots();
      });
    });
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  void showCarboonAllUser() {
    db.collection("users").get().then((value) {
      value.docs.forEach((runAllDocument) {
        db
            .collection("users")
            .doc(runAllDocument.id)
            .collection("saveCarboon")
            //.where("type", isEqualTo: "ภาชนะ")
            .get()
            .then((subcol) {
          subcol.docs.forEach((element) {
            print("********************\n");
            print("show : \n\n\n*********\n");
            print(element.data());
          });
        });
      });
    });
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  void showCarboonUserSelect() {
    db
        .collection("users")
        .doc("${loggedInUser.uid}")
        .collection("saveCarboon")
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print("**********************\n");
          print(
              'แสดงเอกสาร ${docSnapshot.id} \n ${docSnapshot.data()["name object"]}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  final List<String> items = ['เท่ากับ', 'น้อยกว่า', 'มากกว่า', 'ระหว่าง'];
  String? _selectedItem;

  void _showDropdownDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เลือกรายการ'),
          content: DropdownButton<String>(
            value: _selectedItem,
            onChanged: (String? newValue) {
              _selectedItem = newValue;
              //Navigator.of(context).pop(); // ปิด AlertDialog
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            //itemWidth: 50,
            dropdownColor: Colors.red,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด AlertDialog
              },
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  List<String> selectedItems = [];

  void _onItemSelect(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  buttonNoSort() {
    return ElevatedButton(
      onPressed: () {
        //showTableDataBase(inputTxtValue: objectFirstCollection);
        setState(() {
          //_isVisible = !_isVisible;
          beginFalse100_bigObject = false;
        });
      },
      child: SizedBox(
        //height: 50,
        width: 150,
        child: Align(
          alignment: Alignment.center,
          child: Text("แสดงข้อมูลทั้งหมด"),
        ),
      ),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  loadCamera() {
    cameraController = CameraController(cameraMe![0], ResolutionPreset.low);
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
  //************************iconSort******************** */
  //************************************************************* */

  runModel() async {
    if (cameraImage != null) {
      var prediksi = await Tflite.runModelOnFrame(
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
      prediksi!.forEach((element) {
        setState(() {
          resultThenScanObjectByLeanAI = element['label'];
        });
      });
    }
    print(resultThenScanObjectByLeanAI);
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  SizedBox areaCamera(BuildContext context, double size) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * size,
      width: MediaQuery.of(context).size.width / 2.3,
      //เพื่อตรวจสอบว่ากล้องถูกเริ่มต้นและเชื่อมต่อกับอุปกรณ์ได้รือไม่
      child: !cameraController!.value.isInitialized
          ? Container()
          : AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
    );
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  var db = FirebaseFirestore.instance;
  UserModel loggedInUser =
      UserModel(null, null, null, null, "$imageAccountBegin()");

  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController firstName = new TextEditingController();
  TextEditingController secondName = new TextEditingController();
  TextEditingController email = new TextEditingController();

  TextEditingController _textEditingController = TextEditingController();
  String? txtValue;

  //status show Column
  bool iconAppBarFilter = false;

  CameraImage? cameraImage;
  CameraController? cameraController;
  String resultThenScanObjectByLeanAI = '_____';

  String selectedConditation = 'เท่ากับ';
  String selectedObject = 'เครื่องใช้ไฟฟ้า';
  String selectedObjectType = 'ขวดน้ำ';

  List<String> dropdownConditation = [
    'เท่ากับ',
    'มากกว่า',
    'มากกว่าเท่ากับ',
    'น้อยกว่า',
    'น้อยกว่าเท่ากับ',
  ];

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  void _onChangeNameObject(String? newValue) {
    setState(() {
      txtValue = newValue!;
      selectedObject = newValue;
    });
  }

  //************************************************************* */
  //************************iconSort******************** */
  //************************************************************* */

  bool beginFalse100_bigObject = false;
  bool beginFalse11_1_object_textDropdownlist = false;
  bool beginFalse12_1_object_textScan = false;
  bool beginFalse200_bigAll = true;
  int subRadioValue = 1;

  bool beginFalse101_2_object_selectDropDownList = false;
  bool beginFalse102_2_object_areaPhoto = false;
  var showVisibleSort = false;
  late AlertDialog alertDialog; // ตัวแปรสำหรับ AlertDialog

  var iconAppBarSort = false;

  String beginItem_Object_Date_TypeObject = 'เวลา'; // ตั้งค่าเริ่มต้น
  List<String> item_Object_Date_TypeObject = [
    'เวลา',
    'วัตถุ',
    'ประเภท'
  ]; // ตัวเลือก
}

enum SortOrderDate { fromLowestToHighest, fromHighestToLowest }

SortOrderDate selectedSortOrder = SortOrderDate.fromLowestToHighest;
bool sortByDate = false;
bool statusSortByDate = true;

enum SortOrderObject { fromLowestToHighest, fromHighestToLowest }

SortOrderObject selectedSortObject = SortOrderObject.fromLowestToHighest;
bool sortByObject = false;

class page3ShowTableCarbonMe extends StatefulWidget {
  const page3ShowTableCarbonMe({Key? key}) : super(key: key);
  @override
  State<page3ShowTableCarbonMe> createState() => _page3ShowTableCarbonMeState();
}
